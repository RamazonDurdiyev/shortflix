import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/auth_model/auth_model.dart';
import 'package:shortflix/src/services/notifications/fcm_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepo {
  final NetworkInfo networkInfo;
  final Dio client;
  final Box localStorage;

  AuthRepo({
    required this.networkInfo,
    required this.client,
    required this.localStorage,
  });

  Future<void> _registerFcmToken() async {
    try {
      await GetIt.instance.get<FcmService>().registerCurrentToken();
    } catch (e) {
      printDebug('[AuthRepo] _registerFcmToken error => $e');
    }
  }

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
      await _registerFcmToken();
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
  //  GOOGLE SIGN IN
  //  1) get idToken from Google on-device
  //  2) POST /api/auth/google { idToken }
  //  3) store AuthModel in Hive
  // ─────────────────────────────────────────
  Future<void> signInWithGoogle() async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final googleSignIn = GoogleSignIn(
      clientId: Platform.isIOS ? GOOGLE_IOS_CLIENT_ID : null,
      serverClientId: GOOGLE_WEB_CLIENT_ID,
      scopes: const ['email', 'profile'],
    );

    GoogleSignInAccount? account;
    try {
      // force a fresh chooser — avoids sticky stale account
      try {
        await googleSignIn.signOut();
      } catch (e) {
        debugPrint('[GoogleSignIn] signOut pre-clean failed (ignored): $e');
      }

      debugPrint('[GoogleSignIn] calling signIn()');
      account = await googleSignIn.signIn();
      debugPrint('[GoogleSignIn] signIn() returned: ${account?.email}');
    } on PlatformException catch (e, st) {
      debugPrint(
        '[GoogleSignIn] PlatformException code=${e.code} '
        'message=${e.message} details=${e.details}',
      );
      debugPrint(st.toString());
      throw GoogleSignInFailedException(
        'Google sign-in failed: ${e.code} ${e.message ?? ''}',
      );
    } catch (e, st) {
      debugPrint('[GoogleSignIn] unexpected error: $e');
      debugPrint(st.toString());
      rethrow;
    }

    if (account == null) throw GoogleSignInCancelledException();

    final GoogleSignInAuthentication googleAuth;
    try {
      googleAuth = await account.authentication;
    } on PlatformException catch (e, st) {
      debugPrint(
        '[GoogleSignIn] authentication PlatformException '
        'code=${e.code} message=${e.message}',
      );
      debugPrint(st.toString());
      throw GoogleSignInFailedException(
        'Google auth failed: ${e.code} ${e.message ?? ''}',
      );
    }

    final idToken = googleAuth.idToken;
    debugPrint(
      '[GoogleSignIn] idToken present=${idToken != null} '
      'length=${idToken?.length ?? 0}',
    );
    if (idToken == null || idToken.isEmpty) {
      throw GoogleSignInFailedException(
        'Google idToken is null — check that the platform OAuth client IDs '
        'match the ones configured on the backend.',
      );
    }

    try {
      final res = await client.post(
        GOOGLE_AUTH,
        data: {'idToken': idToken},
      );

      final auth = AuthModel.fromJson(
        Map<String, dynamic>.from(res.data as Map),
      );
      await localStorage.put(USER_TOKEN, auth);
      await _registerFcmToken();
    } on DioException catch (e, st) {
      debugPrint(
        '[GoogleSignIn] backend /auth/google failed '
        'status=${e.response?.statusCode} body=${e.response?.data}',
      );
      debugPrint(st.toString());
      rethrow;
    }
  }

  // ─────────────────────────────────────────
  //  APPLE SIGN IN (iOS only)
  //  1) generate raw nonce, send SHA-256(nonce) to Apple
  //  2) POST /api/auth/apple { identityToken, fullName?, nonce: raw }
  //  3) store AuthModel in Hive
  // ─────────────────────────────────────────
  Future<void> signInWithApple() async {
    if (!await networkInfo.isConnected) throw NetworkException();

    if (!(Platform.isIOS || Platform.isMacOS)) {
      throw AppleSignInFailedException(
        'Apple Sign In is only available on iOS/macOS.',
      );
    }

    final rawNonce = _generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    AuthorizationCredentialAppleID credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
    } on SignInWithAppleAuthorizationException catch (e, st) {
      debugPrint('[AppleSignIn] SignInWithAppleAuthorizationException '
          'code=${e.code} message=${e.message}');
      debugPrint(st.toString());
      if (e.code == AuthorizationErrorCode.canceled) {
        throw AppleSignInCancelledException();
      }
      throw AppleSignInFailedException(
        'Apple sign-in failed: ${e.code.name} ${e.message}',
      );
    } catch (e, st) {
      debugPrint('[AppleSignIn] unexpected error: $e');
      debugPrint(st.toString());
      throw AppleSignInFailedException('Apple sign-in failed: $e');
    }

    final identityToken = credential.identityToken;
    debugPrint('[AppleSignIn] identityToken present=${identityToken != null} '
        'email=${credential.email} givenName=${credential.givenName}');
    if (identityToken == null || identityToken.isEmpty) {
      throw AppleSignInFailedException('Apple identityToken is null.');
    }

    // Apple returns fullName only on the FIRST sign-in for this Apple ID.
    // Combine given + family and send it; on later sign-ins it will be null,
    // which the backend handles.
    final givenName = credential.givenName?.trim() ?? '';
    final familyName = credential.familyName?.trim() ?? '';
    final fullName = [givenName, familyName]
        .where((s) => s.isNotEmpty)
        .join(' ')
        .trim();

    try {
      final res = await client.post(
        APPLE_AUTH,
        data: {
          'identityToken': identityToken,
          if (fullName.isNotEmpty) 'fullName': fullName,
          'nonce': rawNonce,
        },
      );

      final auth = AuthModel.fromJson(
        Map<String, dynamic>.from(res.data as Map),
      );
      await localStorage.put(USER_TOKEN, auth);
      await _registerFcmToken();
    } on DioException catch (e, st) {
      debugPrint('[AppleSignIn] backend /auth/apple failed '
          'status=${e.response?.statusCode} body=${e.response?.data}');
      debugPrint(st.toString());
      rethrow;
    }
  }

  String _generateRawNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
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
        'dateOfBirth': birthDateIso,
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
    await _registerFcmToken();
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
    try {
      await GetIt.instance.get<FcmService>().unregisterCurrentToken();
    } catch (e) {
      printDebug('[AuthRepo] clearAuth unregisterCurrentToken error => $e');
    }
    await localStorage.delete(USER_TOKEN);
  }
}

// ─────────────────────────────────────────
//  CUSTOM EXCEPTION
// ─────────────────────────────────────────
class NotSignedUpException implements Exception {
  final String message = 'User not signed up';
}

class GoogleSignInCancelledException implements Exception {
  final String message = 'Google sign-in cancelled';
}

class GoogleSignInFailedException implements Exception {
  final String message;
  GoogleSignInFailedException(this.message);
  @override
  String toString() => 'GoogleSignInFailedException: $message';
}

class AppleSignInCancelledException implements Exception {
  final String message = 'Apple sign-in cancelled';
}

class AppleSignInFailedException implements Exception {
  final String message;
  AppleSignInFailedException(this.message);
  @override
  String toString() => 'AppleSignInFailedException: $message';
}