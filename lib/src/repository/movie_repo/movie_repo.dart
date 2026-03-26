import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/src/models/banner_model/banner_model.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';

class MovieRepo {
  final NetworkInfo networkInfo;
  final Dio client;
  final Box localStorage;

  MovieRepo({
    required this.networkInfo,
    required this.client,
    required this.localStorage,
  });

   // **************************************************************************
  // fetch movies
  // **************************************************************************

  Future<List<MovieModel>> fetchMovies() async {
    // crashlyticsLog(page: 'CategoriesRepo', function: 'fetchCategories');

    if (await networkInfo.isConnected) {
      final res = await client.get(GET_ALL_MOVIES);
      return res.data["data"].map<MovieModel>((movie) {
        return MovieModel.fromJson(movie);
      }).toList();
    } else {
      throw NetworkException();
    }
  }

    Future<List<BannerModel>> fetchMovieBanners() async {
    // crashlyticsLog(page: 'CategoriesRepo', function: 'fetchCategories');

    if (await networkInfo.isConnected) {
      final res = await client.get(GET_BANNERS);
      return res.data.map<BannerModel>((banner) {
        return BannerModel.fromJson(banner);
      }).toList();
    } else {
      throw NetworkException();
    }
  }

}
