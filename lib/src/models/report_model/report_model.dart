import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

class ReportCategoryModel {
  final String id;
  final String code;
  final String name;
  final List<ReportSubcategoryModel> subcategories;

  const ReportCategoryModel({
    required this.id,
    required this.code,
    required this.name,
    required this.subcategories,
  });

  factory ReportCategoryModel.fromJson(Map<String, dynamic> json) {
    final subs = json['subcategories'];
    return ReportCategoryModel(
      id: json['id'].toString(),
      code: json['code']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      subcategories: subs is List
          ? subs
              .map((e) =>
                  ReportSubcategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}

class ReportSubcategoryModel {
  final String id;
  final String code;
  final String name;
  final bool requiresText;

  const ReportSubcategoryModel({
    required this.id,
    required this.code,
    required this.name,
    required this.requiresText,
  });

  factory ReportSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return ReportSubcategoryModel(
      id: json['id'].toString(),
      code: json['code']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      requiresText: json['requiresText'] as bool? ?? false,
    );
  }
}

@JsonSerializable()
class ReportCommentCategoryModel{
  final String id;
  final int code;
  final String name;
  final String subcategory;
  final bool requiresText;

  ReportCommentCategoryModel({required this.id, required this.code, required this.name, required this.subcategory, required this.requiresText});

    factory ReportCommentCategoryModel.fromJson(Map<String, dynamic> data) =>
      _$ReportCommentCategoryModelFromJson(data);

  Map<String, dynamic> toJson() => _$ReportCommentCategoryModelToJson(this);
}