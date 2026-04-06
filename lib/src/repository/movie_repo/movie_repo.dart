import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/src/models/banner_model/banner_model.dart';
import 'package:shortflix/src/models/comment_model/comment_model.dart';
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
    if (await networkInfo.isConnected) {
      final res = await client.get(GET_ALL_MOVIES);
      return res.data["data"].map<MovieModel>((movie) {
        return MovieModel.fromJson(movie);
      }).toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // search movies
  // **************************************************************************

  Future<List<MovieModel>> searchMovies(String query) async {
    if (await networkInfo.isConnected) {
      final res = await client.get(
        SEARCH_MOVIES,
        queryParameters: {"q": query},
      );
      return res.data["data"].map<MovieModel>((movie) {
        return MovieModel.fromJson(movie);
      }).toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // fetch movies
  // **************************************************************************

  Future<List<MovieModel>> fetchMoviesOfUser() async {
    // crashlyticsLog(page: 'CategoriesRepo', function: 'fetchCategories');

    if (await networkInfo.isConnected) {
      final res = await client.get(GET_ALL_MOVIES_OF_USER);
      return res.data["data"].map<MovieModel>((movie) {
        return MovieModel.fromJson(movie);
      }).toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // fetch movie banners
  // **************************************************************************

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

  // **************************************************************************
  // fetch movie details
  // **************************************************************************

  Future<MovieDetailsModel> fetchMovieDetails(String movieId) async {
    // crashlyticsLog(page: 'CategoriesRepo', function: 'fetchCategories');

    if (await networkInfo.isConnected) {
      final res = await client.get(GET_MOVIE_DETAILS + movieId);
      return MovieDetailsModel.fromJson(res.data);
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // fetch episodes
  // **************************************************************************

  Future<List<EpisodeModel>> fetchEpisodes(String movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await client.get(GET_EPISODES + movieId);

        final List data = res.data as List;

        return data.map((episode) {
          return EpisodeModel.fromJson(episode);
        }).toList();
      } catch (e) {
        throw Exception("Failed to fetch episodes");
      }
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // fetch movie details
  // **************************************************************************

  Future<List<EpisodeDetailsModel>> fetchEpisode(String movieId, episodeNumber) async {
    // crashlyticsLog(page: 'CategoriesRepo', function: 'fetchCategories');

    if (await networkInfo.isConnected) {
      final res = await client.get(
        GET_EPISODE,
        queryParameters: {
          "movieId": movieId,
          "episodeNumber": episodeNumber,
          "seasonNumber": 1,
        },
      );
     return res.data["data"].map<EpisodeDetailsModel>((episode) {
          return EpisodeDetailsModel.fromJson(episode);
        }).toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // Like movie
  // **************************************************************************

  Future<void> likeEpisode(String episodeId) async {
    // crashlyticsLog(page: 'CategoriesRepo', function: 'fetchCategories');

    if (await networkInfo.isConnected) {
      await client.post(LIKE_EPISODE + episodeId);
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // Save episode
  // **************************************************************************

  Future<void> saveEpisode(String episodeId) async {
    if (await networkInfo.isConnected) {
      await client.post(SAVE_EPISODE + episodeId);
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // Save movie
  // **************************************************************************

  Future<void> saveMovie(String movieId) async {
    if (await networkInfo.isConnected) {
      await client.post(SAVE_MOVIE + movieId);
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // Fetch saved movies
  // **************************************************************************

  Future<List<MovieModel>> fetchSavedMovies() async {
    if (await networkInfo.isConnected) {
      final res = await client.get(SAVED_MOVIES);
      return res.data.map<MovieModel>((movie) {
        return MovieModel.fromJson(movie);
      }).toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // post movie
  // **************************************************************************

  Future<void> postMovie({
    required String titleUz,
    required String titleRu,
    required String titleEn,
    required String descriptionUz,
    required String descriptionRu,
    required String descriptionEn,
    required String ageLimit,
    required int releaseYear,
    required String categoryId,
    required String imageUrl,
  }) async {
    if (await networkInfo.isConnected) {
      await client.post(
        CREATE_MOVIE,
        data: {
          "titleUz": titleUz,
          "titleRu": titleRu,
          "titleEn": titleEn,
          "descriptionUz": descriptionUz,
          "descriptionRu": descriptionRu,
          "descriptionEn": descriptionEn,
          "ageLimit": ageLimit,
          "releaseYear": releaseYear,
          "categoryId": categoryId,
          "imageUrl": imageUrl,
        },
      );
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // post episode
  // **************************************************************************

  Future<void> postEpisode({
    required int season,
    required int episodeNumber,
    required String movieId,
    required String titleUz,
    required String titleRu,
    required String titleEn,
    String? descriptionUz,
    String? descriptionRu,
    String? descriptionEn,
    String? videoUrl,
    String? imageUrl,
    int? duration,
  }) async {
    if (await networkInfo.isConnected) {
      await client.post(
        CREATE_EPISODE,
        data: {
          "season": season,
          "episodeNumber": episodeNumber,
          "movieId": movieId,
          "titleUz": titleUz,
          "titleRu": titleRu,
          "titleEn": titleEn,
          if (descriptionUz != null) "descriptionUz": descriptionUz,
          if (descriptionRu != null) "descriptionRu": descriptionRu,
          if (descriptionEn != null) "descriptionEn": descriptionEn,
          if (videoUrl != null) "videoUrl": videoUrl,
          if (imageUrl != null) "imageUrl": imageUrl,
          if (duration != null) "duration": duration,
        },
      );
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // upload image
  // **************************************************************************

  Future<String> uploadImage(String filePath) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final fileName = filePath.split('/').last;

    final res = await client.post(
      MEDIA_UPLOAD,
      data: {
        "fileName": fileName,
        "contentType": "image/jpeg",
        "folder": "images",
      },
    );

    final String uploadUrl = res.data['uploadUrl'];
    final String fileUrl = res.data['fileUrl'];

    final bytes = await File(filePath).readAsBytes();
    await Dio().put(
      uploadUrl,
      data: bytes,
      options: Options(
        headers: {'Content-Type': 'image/jpeg', 'Content-Length': bytes.length},
      ),
    );

    return fileUrl;
  }

  // **************************************************************************
  // upload video
  // **************************************************************************

 Future<String> uploadVideo(String filePath) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final fileName = filePath.split('/').last;

    final res = await client.post(
      MEDIA_UPLOAD,
      data: {
        "fileName": fileName,
        "contentType": "video/mp4",
        "folder": "videos",
      },
    );

    final String uploadUrl = res.data['uploadUrl'];
    final String fileUrl = res.data['fileUrl'];

    final bytes = await File(filePath).readAsBytes();
    await Dio().put(
      uploadUrl,
      data: bytes,
      options: Options(
        headers: {'Content-Type': 'video/mp4', 'Content-Length': bytes.length},
      ),
    );

    return fileUrl;
  }

  // **************************************************************************
  // fetch comments
  // **************************************************************************

  Future<List<CommentModel>> fetchComments({
    required String movieId,
    required String episodeId,
  }) async {
    if (await networkInfo.isConnected) {
      final res = await client.get(
        episodeComments(filmId: movieId, episodeId: episodeId),
      );
      return (res.data["data"] as List)
          .map<CommentModel>((c) => CommentModel.fromJson(c))
          .toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // add comment
  // **************************************************************************

  Future<void> addComment({
    required String comment,
    required String movieId,
    required String episodeId,
  }) async {
    if (await networkInfo.isConnected) {
      await client.post(
        ADD_COMMENT,
        data: {
          "comment": comment,
          "movieId": movieId,
          "episodeId": episodeId,
        },
      );
    } else {
      throw NetworkException();
    }
  }
}
