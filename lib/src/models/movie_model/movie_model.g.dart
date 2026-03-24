// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
  id: json['id'] as String,
  title: json['title'] as String,
  category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
  releaseYear: (json['releaseYear'] as num).toInt(),
  rating: (json['rating'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'releaseYear': instance.releaseYear,
      'rating': instance.rating,
      'imageUrl': instance.imageUrl,
    };
