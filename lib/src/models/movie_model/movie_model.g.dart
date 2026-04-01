// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
  id: json['id'] as String?,
  title: json['title'] as String?,
  category: json['category'] == null
      ? null
      : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
  releaseYear: (json['releaseYear'] as num?)?.toInt(),
  rating: (json['rating'] as num?)?.toDouble(),
  media: json['media'] as String?,
);

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'releaseYear': instance.releaseYear,
      'rating': instance.rating,
      'media': instance.media,
    };

MovieDetailsModel _$MovieDetailsModelFromJson(Map<String, dynamic> json) =>
    MovieDetailsModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      releaseYear: (json['releaseYear'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
      media: json['media'] as String?,
      ageLimit: json['ageLimit'] as String?,
      isLiked: json['isLiked'] as bool?,
      isSaved: json['isSaved'] as bool?,
      season: (json['season'] as num?)?.toInt(),
      episode: (json['episode'] as num?)?.toInt(),
      watched: json['watched'] as bool?,
    );

Map<String, dynamic> _$MovieDetailsModelToJson(MovieDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'releaseYear': instance.releaseYear,
      'rating': instance.rating,
      'media': instance.media,
      'ageLimit': instance.ageLimit,
      'isLiked': instance.isLiked,
      'isSaved': instance.isSaved,
      'season': instance.season,
      'episode': instance.episode,
      'watched': instance.watched,
    };

EpisodeModel _$EpisodeModelFromJson(Map<String, dynamic> json) => EpisodeModel(
  id: json['id'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  season: (json['season'] as num?)?.toInt(),
  episodeNumber: (json['episodeNumber'] as num?)?.toInt(),
  watched: json['watched'] as bool?,
  createdAt: json['createdAt'] as String?,
  videoUrl: json['videoUrl'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  movieId: json['movieId'] as String?,
);

Map<String, dynamic> _$EpisodeModelToJson(EpisodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'season': instance.season,
      'episodeNumber': instance.episodeNumber,
      'title': instance.title,
      'description': instance.description,
      'videoUrl': instance.videoUrl,
      'duration': instance.duration,
      'movieId': instance.movieId,
      'watched': instance.watched,
    };

EpisodeDetailsModel _$EpisodeDetailsModelFromJson(Map<String, dynamic> json) =>
    EpisodeDetailsModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      season: (json['season'] as num?)?.toInt(),
      episodeNumber: (json['episodeNumber'] as num?)?.toInt(),
      watched: json['watched'] as bool?,
      createdAt: json['createdAt'] as String?,
      videoUrl: json['videoUrl'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      movieId: json['movieId'] as String?,
    );

Map<String, dynamic> _$EpisodeDetailsModelToJson(
  EpisodeDetailsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'season': instance.season,
  'episodeNumber': instance.episodeNumber,
  'title': instance.title,
  'description': instance.description,
  'videoUrl': instance.videoUrl,
  'duration': instance.duration,
  'movieId': instance.movieId,
  'watched': instance.watched,
};
