import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/src/models/banner_model/banner_model.dart';
import 'package:shortflix/src/models/comment_model/comment_model.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/models/report_model/report_model.dart';

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
  // fetch movies by category
  // **************************************************************************

  Future<List<MovieModel>> fetchMoviesByCategory(String categoryId) async {
    if (await networkInfo.isConnected) {
      final res = await client.get(
        SEARCH_MOVIES,
        queryParameters: {"categoryId": categoryId},
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

  Future<List<MovieModel>> fetchMoviesOfUser(String userId) async {
    if (await networkInfo.isConnected) {
      final res = await client.get(moviesByUser(userId));
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

  Future<({List<EpisodeDetailsModel> episodes, int totalEpisodes})> fetchEpisode(String movieId, episodeNumber) async {
    if (await networkInfo.isConnected) {
      final res = await client.get(
        GET_EPISODE,
        queryParameters: {
          "movieId": movieId,
          "episodeNumber": episodeNumber,
          "seasonNumber": 1,
        },
      );
      final list = (res.data["data"] as List)
          .map<EpisodeDetailsModel>((e) => EpisodeDetailsModel.fromJson(e))
          .toList();
      final total = (res.data["numberOfEpisodes"] as int?) ?? list.length;
      return (episodes: list, totalEpisodes: total);
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
  // Rate movie
  // **************************************************************************

  Future<void> rateMovie({
    required String movieId,
    required int rating,
    required bool isUpdate,
  }) async {
    if (await networkInfo.isConnected) {
      if (isUpdate) {
        await client.patch(
          UPDATE_RATE_MOVIE + movieId,
          data: {"rating": rating},
        );
      } else {
        await client.post(
          RATE_MOVIE,
          data: {"movieId": movieId, "rating": rating},
        );
      }
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
  // Fetch shorts
  // **************************************************************************

  Future<Map<String, dynamic>> fetchShort() async {
    if (await networkInfo.isConnected) {
      final res = await client.get(
        SHORTS,
      );
      final data = res.data as Map<String, dynamic>;
      return {
        "episode": EpisodeDetailsModel.fromJson(data),
        "index": data["index"] ?? 0,
        "total": data["total"] ?? 0,
      };
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // Fetch saved episodes
  // **************************************************************************

  Future<List<EpisodeModel>> fetchSavedEpisodes() async {
    if (await networkInfo.isConnected) {
      final res = await client.get(SAVED_EPISODES);
      return (res.data as List)
          .map<EpisodeModel>((e) => EpisodeModel.fromJson(e))
          .toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // Fetch liked episodes
  // **************************************************************************

  Future<List<EpisodeModel>> fetchLikedEpisodes() async {
    if (await networkInfo.isConnected) {
      final res = await client.get(LIKED_EPISODES);
      return (res.data as List)
          .map<EpisodeModel>((e) => EpisodeModel.fromJson(e))
          .toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // post movie
  // **************************************************************************

  Future<void> postMovie({
    required String title,
    required String description,
    required String ageLimit,
    required int releaseYear,
    required String categoryId,
    required String imageUrl,
  }) async {
    if (await networkInfo.isConnected) {
      await client.post(
        CREATE_MOVIE,
        data: {
          "title": title,
          "description": description,
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
  // update movie
  // **************************************************************************

  Future<void> updateMovie({
    required String movieId,
    String? title,
    String? description,
    String? ageLimit,
    int? releaseYear,
    String? categoryId,
    String? imageUrl,
  }) async {
    if (await networkInfo.isConnected) {
      await client.patch(
        UPDATE_MOVIE + movieId,
        data: {
          "title": ?title,
          "description": ?description,
          "ageLimit": ?ageLimit,
          "releaseYear": ?releaseYear,
          "categoryId": ?categoryId,
          "imageUrl": ?imageUrl,
        },
      );
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // delete movie
  // **************************************************************************

  Future<void> deleteMovie(String movieId) async {
    if (await networkInfo.isConnected) {
      await client.delete(DELETE_MOVIE + movieId);
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // archive movie
  // **************************************************************************

  Future<void> archiveMovie(String movieId) async {
    if (await networkInfo.isConnected) {
      await client.post(ARCHIVE_MOVIE + movieId);
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // fetch archived movies
  // **************************************************************************

  Future<List<MovieModel>> fetchArchivedMovies() async {
    if (await networkInfo.isConnected) {
      final res = await client.get(ARCHIVED_MOVIES);
      return res.data["data"].map<MovieModel>((movie) {
        return MovieModel.fromJson(movie);
      }).toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // fetch archived episodes
  // **************************************************************************

  Future<List<EpisodeModel>> fetchArchivedEpisodes() async {
    if (await networkInfo.isConnected) {
      final res = await client.get(ARCHIVED_EPISODES);
      return (res.data as List)
          .map<EpisodeModel>((e) => EpisodeModel.fromJson(e))
          .toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // fetch archived episode details
  // **************************************************************************

  Future<EpisodeDetailsModel> fetchArchivedEpisodeDetails(String episodeId) async {
    if (await networkInfo.isConnected) {
      final res = await client.get(ARCHIVED_EPISODE_DETAILS + episodeId);
      return EpisodeDetailsModel.fromJson(res.data);
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
    required String title,
    String? description,
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
          "title": title,
          "description": ?description,
          "videoUrl": ?videoUrl,
          "imageUrl": ?imageUrl,
          "duration": ?duration,
        },
      );
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // update episode
  // **************************************************************************

  Future<void> updateEpisode({
    required String episodeId,
    int? season,
    int? episodeNumber,
    String? title,
    String? description,
    String? videoUrl,
    String? imageUrl,
    int? duration,
  }) async {
    if (await networkInfo.isConnected) {
      await client.patch(
        UPDATE_EPISODE + episodeId,
        data: {
          "season": ?season,
          "episodeNumber": ?episodeNumber,
          "title": ?title,
          "description": ?description,
          "videoUrl": ?videoUrl,
          "imageUrl": ?imageUrl,
          "duration": ?duration,
        },
      );
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // delete episode
  // **************************************************************************

  Future<void> deleteEpisode(String episodeId) async {
    if (await networkInfo.isConnected) {
      await client.delete(DELETE_EPISODE + episodeId);
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // archive episode
  // **************************************************************************

  Future<void> archiveEpisode(String episodeId) async {
    if (await networkInfo.isConnected) {
      await client.post(ARCHIVE_EPISODE + episodeId);
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // fetch report categories
  // **************************************************************************

  Future<List<ReportCategoryModel>> fetchReportCategories() async {
    if (await networkInfo.isConnected) {
      final res = await client.get(GET_REPORT_CATEGORIES);
      final raw = res.data;
      final List list = raw is List
          ? raw
          : (raw is Map && raw["data"] is List ? raw["data"] as List : const []);
      return list
          .map<ReportCategoryModel>(
              (e) => ReportCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw NetworkException();
    }
  }

  // **************************************************************************
  // report episode
  // **************************************************************************

  Future<void> reportEpisode({
    required String episodeId,
    required String subcategoryId,
    String? text,
  }) async {
    if (await networkInfo.isConnected) {
      await client.post(
        REPORT_EPISODE,
        data: {
          "episodeId": episodeId,
          "subcategoryId": subcategoryId,
          if (text != null && text.isNotEmpty) "text": text,
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

 Future<String> uploadVideo(
    String filePath, {
    void Function(double progress)? onProgress,
  }) async {
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
      onSendProgress: (sent, total) {
        if (onProgress == null) return;
        final t = total > 0 ? total : bytes.length;
        if (t <= 0) return;
        onProgress((sent / t).clamp(0.0, 1.0));
      },
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

  // **************************************************************************
  // fetch report categories
  // **************************************************************************

  Future<List<ReportCommentCategoryModel>> fetchReportCommentCategories() async {
    if (await networkInfo.isConnected) {
      final res = await client.get(GET_REPORT_COMMENT_CATEGORIES);
      final raw = res.data;
      final List list = raw is List
          ? raw
          : (raw is Map && raw["data"] is List ? raw["data"] as List : const []);
      return list
          .map<ReportCommentCategoryModel>(
              (e) => ReportCommentCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw NetworkException();
    }
  }


  // **************************************************************************
  // report comment
  // **************************************************************************

    Future<void> reportComment({
    required String commentId,
    required String subcategoryId,
    String? text,
  }) async {
    if (await networkInfo.isConnected) {
      await client.post(
        REPORT_COMMENT,
        data: {
          "commentId": commentId,
          "subcategoryId": subcategoryId,
          if (text != null && text.isNotEmpty) "text": text,
        },
      );
    } else {
      throw NetworkException();
    }
  }


}




  


