import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/error/exceptions.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/src/models/post_model/post_model.dart';

class PostRepo {
  final NetworkInfo networkInfo;
  final Dio client;
  final Box localStorage;

  PostRepo({
    required this.networkInfo,
    required this.client,
    required this.localStorage,
  });

  // ─────────────────────────────────────────
  //  CREATE POST
  //  media field carries both video + image
  //  as multipart — backend handles both
  // ─────────────────────────────────────────
  Future<void> createPost(PostModel post) async {
    if (!await networkInfo.isConnected) throw NetworkException();

    final formData = FormData.fromMap({
      'season': post.season,
      'episode': post.episode,
      'titleUz': post.titleUz,
      'titleRu': post.titleRu,
      'titleEn': post.titleEn,
      'descriptionUz': post.descriptionUz,
      'descriptionRu': post.descriptionRu,
      'descriptionEn': post.descriptionEn,
      'releaseYear': post.releaseYear,
      'categoryId': post.categoryId,
      // media field sends both files under the same key
      'media': [
        await MultipartFile.fromFile(post.videoPath),
        await MultipartFile.fromFile(post.imagePath),
      ],
    });

    await client.post(
      CREATE_POST, // add to app_constants.dart
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}