// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
  id: json['id'] as String,
  title: json['title'] as String,
  category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
  imageUrl: json['imageUrl'] as String?,
  averageRating: (json['averageRating'] as num?)?.toDouble(),
  currentUserRating: (json['currentUserRating'] as num?)?.toInt(),
);

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'averageRating': instance.averageRating,
      'currentUserRating': instance.currentUserRating,
    };
