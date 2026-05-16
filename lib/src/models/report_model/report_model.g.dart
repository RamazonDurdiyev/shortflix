// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportCommentCategoryModel _$ReportCommentCategoryModelFromJson(
  Map<String, dynamic> json,
) => ReportCommentCategoryModel(
  id: json['id'] as String,
  code: (json['code'] as num).toInt(),
  name: json['name'] as String,
  subcategory: json['subcategory'] as String,
  requiresText: json['requiresText'] as bool,
);

Map<String, dynamic> _$ReportCommentCategoryModelToJson(
  ReportCommentCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'subcategory': instance.subcategory,
  'requiresText': instance.requiresText,
};
