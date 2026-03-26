import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';

class CategoryRepo {
  final NetworkInfo networkInfo;
  final Dio client;
  final Box localStorage;

  CategoryRepo({
    required this.networkInfo,
    required this.client,
    required this.localStorage,
  });

  // **************************************************************************
  // fetch categories
  // **************************************************************************

  Future<List<CategoryModel>> fetchCategories() async {
    // crashlyticsLog(page: 'CategoriesRepo', function: 'fetchCategories');

    if (await networkInfo.isConnected) {
      final res = await client.get(CATEGORIES);
      return res.data.map<CategoryModel>((category) {
        return CategoryModel.fromJson(category);
      }).toList();
    } else {
      throw NetworkException();
    }
  }
}
