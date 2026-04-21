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
  //  HISTORY (SUPER_ADMIN)
  //  GET /api/notifications/history
  // ─────────────────────────────────────────
  Future<List<NotificationModel>> history() async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final res = await client.get(NOTIFICATION_HISTORY);
    final data = res.data;
    final List list = data is List
        ? data
        : (data is Map ? (data['items'] ?? data['data'] ?? []) as List : const []);
    return list
        .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
