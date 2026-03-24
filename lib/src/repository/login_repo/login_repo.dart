import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/src/models/login_model/login_model.dart';

class LoginRepo {
  final NetworkInfo networkInfo;
  final Dio client;
  final Box localStorage;

  LoginRepo({
    required this.networkInfo,
    required this.client,
    required this.localStorage,
  });

  Future<LoginModel> refresh(String refreshToken) async {
    // crashlyticsLog(
    //     page: 'LoginRepo',
    //     function: 'Refresh',
    //     data: 'refreshToken: $refreshToken');

    if (await networkInfo.isConnected) {
      final ref = await client.post(
        REFRESH,
        data: {"refreshToken": refreshToken},
      );
      return LoginModel.fromJson(ref.data["result"]);
    } else {
      throw NetworkException();
    }
  }

  Future<bool> sendSms(String phone) async {
    // crashlyticsLog(
    //     page: 'LoginRepo', function: 'SendSms', data: 'phone: $phone');
    if (await networkInfo.isConnected) {
      await client.post(SEND_CODE, data: {"email": phone});
      return true;
    } else {
      throw NetworkException();
    }
  }

  Future<LoginModel> register(String phone, String code) async {
    // crashlyticsLog(
    //     page: 'LoginRepo',
    //     function: 'ConfirmSms',
    //     data: 'phone: $phone, code: $code');
    if (await networkInfo.isConnected) {
      final res = await client.post(
        CHECK_CODE,
        queryParameters: {"email": phone, "otpCode": code},
      );
      final loginData = LoginModel.fromJson(res.data["result"]);
      if (!loginData.isProfileCompleted!) {
        localStorage.put(USER_TOKEN, LoginModel);
        return loginData;
      }
      localStorage.put(USER_TOKEN, LoginModel);
      await localStorage.put(USER_COMPLETED_PROFILE, true);
      return loginData;
    } else {
      throw NetworkException();
    }
  }

  Future<LoginModel> completeProfile(
    String firstName,
    String lastName,
    // String? email,
  ) async {
    if (await networkInfo.isConnected) {
      // crashlyticsLog(
      //     page: 'LoginRepo',
      //     function: 'Register',
      //     data:
      //         'name: $name, email: $email, birthday: $birthday, image: $image, district: $district, credential: $credential');

      // final language = (await localStorage.get(LANGUAGE) as String?) ?? "en";
      final ref = await client.post(
        REGISTER,
        data: {"firstName": firstName, "lastName": lastName},
      );
      final loginData = LoginModel.fromJson(ref.data["result"]);
      await localStorage.put(USER_IS_GUEST, false);
      await localStorage.put(USER_COMPLETED_PROFILE, true);

      return loginData;
    } else {
      throw NetworkException();
    }
  }
}
