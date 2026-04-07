import 'package:json_annotation/json_annotation.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel {
  final String id;
  final String title;
  final CategoryModel category;
  final String? imageUrl;
  final double? averageRating;
  final int? currentUserRating;

  BannerModel({required this.id, required this.title, required this.category, this.imageUrl, this.averageRating, this.currentUserRating});

   factory BannerModel.fromJson(Map<String, dynamic> data) =>
      _$BannerModelFromJson(data);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
  
}