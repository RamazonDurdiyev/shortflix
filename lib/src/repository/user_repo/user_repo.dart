import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/src/models/user_model/user_model.dart';

class UserRepo {
  final NetworkInfo networkInfo;
  final Dio client;
  final Box localStorage;

  UserRepo({
    required this.networkInfo,
    required this.client,
    required this.localStorage,
  });

  // **************************************************************************
  // fetch current user
  // **************************************************************************

  Future<UserModel> fetchCurrentUser() async {
    if (await networkInfo.isConnected) {
      final res = await client.get(GET_USER);
      return UserModel.fromJson(Map<String, dynamic>.from(res.data as Map));
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // update current user
  // **************************************************************************

  Future<UserModel> updateUser({
    required String fullName,
    required String phone,
    required String avatar,
    required String dateOfBirth,
  }) async {
    if (await networkInfo.isConnected) {
      final res = await client.patch(
        GET_USER,
        data: {
          "fullName": fullName,
          "phone": phone,
          "avatar": avatar,
          "dateOfBirth": dateOfBirth,
        },
      );
      return UserModel.fromJson(Map<String, dynamic>.from(res.data as Map));
    } else {
      throw NetworkException();
    }
  }
}
