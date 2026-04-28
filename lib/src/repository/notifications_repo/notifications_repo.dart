import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/src/models/notification_model/notification_model.dart';

class NotificationsRepo {
  final NetworkInfo networkInfo;
  final Dio client;
  final Box localStorage;

  NotificationsRepo({
    required this.networkInfo,
    required this.client,
    required this.localStorage,
  });

  // ─────────────────────────────────────────
  //  REGISTER DEVICE TOKEN
  //  POST /api/notifications/device-token
  // ─────────────────────────────────────────
  Future<void> registerDeviceToken({
    required String token,
    required String platform,
  }) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    await client.post(
      DEVICE_TOKEN,
      data: {
        'token': token,
        'platform': platform,
      },
    );
    await localStorage.put(FCM_TOKEN, token);
  }

  // ─────────────────────────────────────────
  //  DELETE DEVICE TOKEN
  //  DELETE /api/notifications/device-token
  // ─────────────────────────────────────────
  Future<void> deleteDeviceToken({required String token}) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    await client.delete(
      DEVICE_TOKEN,
      data: {'token': token},
    );
    await localStorage.delete(FCM_TOKEN);
  }

  // ─────────────────────────────────────────
  //  BROADCAST (SUPER_ADMIN)
  //  POST /api/notifications/broadcast
  // ─────────────────────────────────────────
  Future<void> broadcast({
    required String title,
    required String body,
  }) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    await client.post(
      BROADCAST_NOTIFICATION,
      data: {
        'title': title,
        'body': body,
      },
    );
  }

  // ─────────────────────────────────────────
  //  LIST ALL
  //  GET /api/notifications
  // ─────────────────────────────────────────
  Future<List<NotificationModel>> list({int limit = 50, int offset = 0}) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final res = await client.get(
      MY_NOTIFICATIONS,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return _parseList(res.data);
  }

  // ─────────────────────────────────────────
  //  LIST BROADCASTS (general / system-wide)
  //  GET /api/notifications
  // ─────────────────────────────────────────
  Future<List<NotificationModel>> broadcasts({
    int limit = 50,
    int offset = 0,
  }) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final res = await client.get(
      NOTIFICATIONS,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return _parseList(res.data);
  }

  List<NotificationModel> _parseList(dynamic data) {
    final List items = data is List
        ? data
        : (data is Map ? (data['items'] ?? data['data'] ?? []) as List : const []);
    return items
        .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  // ─────────────────────────────────────────
  //  UNREAD COUNT
  //  GET /api/notifications/me/unread-count -> { "unreadCount": int }
  // ─────────────────────────────────────────
  Future<int> unreadCount() async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final res = await client.get(UNREAD_COUNT_NOTIFICATIONS);
    final data = res.data;
    if (data is Map) {
      final raw = data['unreadCount'];
      if (raw is int) return raw;
      if (raw is num) return raw.toInt();
      if (raw is String) return int.tryParse(raw) ?? 0;
    }
    return 0;
  }

  // ─────────────────────────────────────────
  //  MARK ALL PERSONAL READ
  //  PATCH /api/notifications/me/read-all
  //  Marks all of the current user's PERSONAL notifications (likes/comments)
  //  as read. Does not affect general broadcasts.
  // ─────────────────────────────────────────
  Future<void> markAllPersonalRead() async {
    if (!await networkInfo.isConnected) throw NetworkException();

    await client.patch(READ_ALL_PERSONAL_NOTIFICATIONS);
  }

  // ─────────────────────────────────────────
  //  MARK ALL GENERAL READ
  //  PATCH /api/notifications/read-all
  //  Marks all general (broadcast) notifications as read for the current user.
  // ─────────────────────────────────────────
  Future<void> markAllGeneralRead() async {
    if (!await networkInfo.isConnected) throw NetworkException();

    await client.patch(READ_ALL_GENERAL_NOTIFICATIONS);
  }
}
