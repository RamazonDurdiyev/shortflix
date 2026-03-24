import 'package:json_annotation/json_annotation.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  final String id;
  final String title;
  final CategoryModel category;
  final int releaseYear;
  final double rating;
  final String imageUrl;

  const MovieModel({
    required this.id,
    required this.title,
    required this.category,
    required this.releaseYear,
    required this.rating,
    required this.imageUrl,
  });


    factory MovieModel.fromJson(Map<String, dynamic> data) =>
      _$MovieModelFromJson(data);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}
