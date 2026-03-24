import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;

  CategoryModel({required this.id, required this.name});

   factory CategoryModel.fromJson(Map<String, dynamic> data) =>
      _$CategoryModelFromJson(data);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

}
