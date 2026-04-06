import 'package:json_annotation/json_annotation.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  final String? id;
  final String? title;
  final CategoryModel? category;
  final int? releaseYear;
  final double? rating;
  @JsonKey(name: 'imageUrl')
  final String? media;

  const MovieModel({
    required this.id,
    required this.title,
    required this.category,
    required this.releaseYear,
    required this.rating,
    required this.media,
  });

  factory MovieModel.fromJson(Map<String, dynamic> data) =>
      _$MovieModelFromJson(data);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}

@JsonSerializable()
class MovieDetailsModel {
  final String? id;
  final String? title;
  final String? description;
  final CategoryModel? category;
  final int? releaseYear;
  final double? rating;
  @JsonKey(name: 'imageUrl')
  final String? media;
  final String? ageLimit;
  final bool? isLiked;
  final bool? isSaved;
  final int? season;
  final int? episode;
  final bool? watched;

  const MovieDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.releaseYear,
    required this.rating,
    required this.media,
    required this.ageLimit,
    required this.isLiked,
    required this.isSaved,
    required this.season,
    required this.episode,
    required this.watched,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> data) =>
      _$MovieDetailsModelFromJson(data);

  Map<String, dynamic> toJson() => _$MovieDetailsModelToJson(this);
}

@JsonSerializable()
class EpisodeModel {
  final String? id;
  final String? createdAt;
  final int? season;
  final int? episodeNumber;
  final String? title;
  final String? description;
  final String? videoUrl;
  final String? imageUrl;
  final int? duration;
  @JsonKey(readValue: _readMovieId)
  final String? movieId;
  final bool? watched;

  const EpisodeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.season,
    required this.episodeNumber,
    required this.watched,
    required this.createdAt,
    required this.videoUrl,
    required this.imageUrl,
    required this.duration,
    required this.movieId,
  });

  static Object? _readMovieId(Map json, String key) {
    if (json['movieId'] != null) return json['movieId'];
    if (json['movie'] is Map) return (json['movie'] as Map)['id'];
    return null;
  }

  factory EpisodeModel.fromJson(Map<String, dynamic> data) =>
      _$EpisodeModelFromJson(data);

  Map<String, dynamic> toJson() => _$EpisodeModelToJson(this);
}


@JsonSerializable()
class EpisodeDetailsModel {
  final String? id;
  final String? createdAt;
  final int? season;
  final int? episodeNumber;
  final String? title;
  final String? description;
  final String? videoUrl;
  final int? duration;
  @JsonKey(readValue: _readMovieId)
  final String? movieId;
  final bool? watched;
  final bool? isLiked;
  final bool? isSaved;
  final int? commentCount;
  final bool? canEdit;

  const EpisodeDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.season,
    required this.episodeNumber,
    required this.watched,
    required this.createdAt,
    required this.videoUrl,
    required this.duration,
    required this.movieId,
    this.isLiked,
    this.isSaved,
    this.commentCount,
    this.canEdit,
  });

  static Object? _readMovieId(Map json, String key) {
    if (json['movieId'] != null) return json['movieId'];
    if (json['movie'] is Map) return (json['movie'] as Map)['id'];
    return null;
  }

  factory EpisodeDetailsModel.fromJson(Map<String, dynamic> data) =>
      _$EpisodeDetailsModelFromJson(data);

  Map<String, dynamic> toJson() => _$EpisodeDetailsModelToJson(this);
}
