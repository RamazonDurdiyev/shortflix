import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/login_model/login_model.dart';
import 'package:shortflix/src/repository/login_repo/login_repo.dart';

Dio addInterceptor(Dio dio) {
  final tokenHelper = GetIt.instance.get<RefreshTokenHelper>();
  // For sending language code to backend
  final box = Hive.box('default');

  dio.interceptors.add(
    PrettyDioLogger(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = tokenHelper.getToken();
        // Get selected language
        final selectedLangCode = box.get('selected_language') ?? 'uz';
        if (token != null) {
          options.headers['Authorization'] = "bearer $token";
          options.headers['Accept'] = "Application/json";
          options.headers['languageCode'] = selectedLangCode;
          printDebug("addInterceptor: headers => ${options.headers}");
          return handler.next(options);
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (((e.response?.statusCode == 401) ||
                (e.response?.statusCode == 400)) &&
            !e.requestOptions.path.toLowerCase().contains("login")) {
          final isTokenRefreshed = await tokenHelper.updateToken().future;
          if (isTokenRefreshed) {
            try {
              final res = await _retry(e.requestOptions);
              return handler.resolve(res);
            } catch (error) {
              handler.next(e);
            }
          } else {
            return handler.next(e);
          }
        }
        return handler.next(e);
      },
    ),
  );
  return dio;
}

_retry(RequestOptions requestOptions) {
  final client = GetIt.instance.get<Dio>();

  final options = Options(
    method: requestOptions.method,
    headers: requestOptions.headers,
  );
  return client.request(
    requestOptions.path,
    data: requestOptions.data,
    queryParameters: requestOptions.queryParameters,
    options: options,
  );
}

class RefreshTokenHelper {
  final requests = <Completer<bool>>[];
  final Box box;
  bool isRefreshing = false;

  RefreshTokenHelper({required this.box});

  Completer<bool> updateToken() {
    final completer = Completer<bool>();
    requests.add(completer);
    if (!isRefreshing) {
      isRefreshing = true;
      _updateToken();
    }
    return completer;
  }

  Future<bool> _updateToken() async {
    final LoginRepo loginRepo = GetIt.instance.get<LoginRepo>();

    try {
      final lastToken = getToken(true);
      final newToken = await loginRepo.refresh(lastToken ?? "");
      box.put(USER_TOKEN, newToken);
      completeRefresh(true);
      return true;
    } catch (e) {
      completeRefresh(false);
      return false;
    }
  }

  void completeRefresh(bool isRefreshed) {
    isRefreshing = false;
    for (var element in requests) {
      element.complete(isRefreshed);
    }
    requests.clear();
  }

  String? getToken([bool isRefresh = false]) {
    final loginData = box.get(USER_TOKEN) as LoginModel?;
    if (loginData != null) {
      return isRefresh ? loginData.refreshToken : loginData.accessToken;
    }
    return null;
  }
}
