import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/src/models/auth_model/auth_model.dart';

class AuthRepo {
  final NetworkInfo networkInfo;
  final Dio client;
  final Box localStorage;

  AuthRepo({
    required this.networkInfo,
    required this.client,
    required this.localStorage,
  });

  // ─────────────────────────────────────────
  //  SIGN IN
  // ─────────────────────────────────────────
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    try {
      final res = await client.post(
        SIGN_IN,
        data: {
          'email': email,
          'password': password,
        },
      );

      final auth = AuthModel.fromJson(
        Map<String, dynamic>.from(res.data as Map),
      );
      await localStorage.put(USER_TOKEN, auth);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message']?.toString().toLowerCase() ?? '';
      if (message.contains('not signed up') ||
          message.contains('user not found')) {
        throw NotSignedUpException();
      }
      rethrow;
    }
  }

  // ─────────────────────────────────────────
  //  SIGN UP
  // ─────────────────────────────────────────
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String birthDateIso,
  }) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    await client.post(
      SIGN_UP,
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'birthDate': birthDateIso,
      },
    );
  }

  // ─────────────────────────────────────────
  //  SEND CONFIRMATION CODE
  // ─────────────────────────────────────────
  Future<void> sendConfirmationCode({required String email}) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    await client.post(
      SEND_CODE,
      data: {'email': email},
    );
  }

  // ─────────────────────────────────────────
  //  VERIFY CODE
  // ─────────────────────────────────────────
  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final res = await client.post(
      VERIFY_CODE,
      data: {
        'email': email,
        'code': code,
      },
    );

    final auth = AuthModel.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
    await localStorage.put(USER_TOKEN, auth);
  }

  // ─────────────────────────────────────────
  //  REFRESH TOKEN
  //  matches old LoginRepo.refresh(String) pattern
  //  network_interceptor calls refresh(lastToken)
  // ─────────────────────────────────────────
  Future<AuthModel> refresh(String refreshToken) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final res = await client.post(
      REFRESH,
      data: {'refreshToken': refreshToken},
    );

    final auth = AuthModel.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
    await localStorage.put(USER_TOKEN, auth);
    return auth;
  }

  // ─────────────────────────────────────────
  //  CLEAR AUTH
  // ─────────────────────────────────────────
  Future<void> clearAuth() async {
    await localStorage.delete(USER_TOKEN);
  }
}

// ─────────────────────────────────────────
//  CUSTOM EXCEPTION
// ─────────────────────────────────────────
class NotSignedUpException implements Exception {
  final String message = 'User not signed up';
}