import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/auth_model/auth_model.dart';
import 'package:shortflix/src/services/notifications/fcm_service.dart';
import 'package:shortflix/src/ui/pages/splash_page/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final Box localStorage;
  final NetworkInfo networkInfo;

  SplashCubit({
    required this.localStorage,
    required this.networkInfo,
  }) : super(SplashLoading());

  Future<void> init() async {
    // small delay so splash is visible
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!await networkInfo.isConnected) {
      emit(SplashNoNetwork());
      return;
    }

    final auth = localStorage.get(USER_TOKEN) as AuthModel?;

    if (auth != null &&
        auth.accessToken != null &&
        auth.accessToken!.isNotEmpty) {
      unawaited(_registerFcm());
      emit(SplashGoHome());
    } else {
      emit(SplashGoSignIn());
    }
  }

  Future<void> _registerFcm() async {
    try {
      await GetIt.instance.get<FcmService>().registerCurrentToken();
    } catch (e) {
      printDebug('[Splash] registerCurrentToken error => $e');
    }
  }
}