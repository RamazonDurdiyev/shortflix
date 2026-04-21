import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/repository/notifications_repo/notifications_repo.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM][bg] ${message.messageId} data=${message.data}');
}

class FcmService {
  final NotificationsRepo notificationsRepo;
  final Box localStorage;

  FcmService({
    required this.notificationsRepo,
    required this.localStorage,
  });

  StreamSubscription<String>? _tokenSub;
  StreamSubscription<RemoteMessage>? _fgSub;
  StreamSubscription<RemoteMessage>? _openSub;

  String get _platform => Platform.isIOS ? 'ios' : 'android';

  /// Call once on app startup (after Firebase.initializeApp).
  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    printDebug('[FCM] permission=${settings.authorizationStatus}');

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _fgSub ??= FirebaseMessaging.onMessage.listen((m) {
      printDebug('[FCM][fg] ${m.notification?.title} / ${m.notification?.body}');
    });
    _openSub ??= FirebaseMessaging.onMessageOpenedApp.listen((m) {
      printDebug('[FCM][opened] ${m.data}');
    });

    _tokenSub ??= messaging.onTokenRefresh.listen((token) async {
      printDebug('[FCM] onTokenRefresh');
      await _sendToken(token);
    });
  }

  /// Call after a successful login — fetches the FCM token and sends it
  /// to the backend. Safe to call multiple times.
  Future<void> registerCurrentToken() async {
    try {
      final messaging = FirebaseMessaging.instance;

      if (Platform.isIOS) {
        // Ensure APNs token is attached before asking for FCM token —
        // otherwise getToken() throws on iOS.
        for (var i = 0; i < 10; i++) {
          final apns = await messaging.getAPNSToken();
          if (apns != null) break;
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      final token = await messaging.getToken();
      if (token == null || token.isEmpty) {
        printDebug('[FCM] getToken returned null — skipping register');
        return;
      }
      await _sendToken(token);
    } catch (e, st) {
      printDebug('[FCM] registerCurrentToken error => $e');
      printDebug(st);
    }
  }

  /// Call on logout — tells backend to forget this device and deletes the
  /// on-device FCM token so the next login issues a fresh one.
  Future<void> unregisterCurrentToken() async {
    try {
      final cached = localStorage.get(FCM_TOKEN) as String?;
      final token = cached ?? await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        try {
          await notificationsRepo.deleteDeviceToken(token: token);
        } catch (e) {
          printDebug('[FCM] deleteDeviceToken error => $e');
        }
      }
      await FirebaseMessaging.instance.deleteToken();
      await localStorage.delete(FCM_TOKEN);
    } catch (e, st) {
      printDebug('[FCM] unregisterCurrentToken error => $e');
      printDebug(st);
    }
  }

  Future<void> _sendToken(String token) async {
    final cached = localStorage.get(FCM_TOKEN) as String?;
    if (cached == token) return;
    await notificationsRepo.registerDeviceToken(
      token: token,
      platform: _platform,
    );
  }

  Future<void> dispose() async {
    await _tokenSub?.cancel();
    await _fgSub?.cancel();
    await _openSub?.cancel();
    _tokenSub = null;
    _fgSub = null;
    _openSub = null;
  }
}
