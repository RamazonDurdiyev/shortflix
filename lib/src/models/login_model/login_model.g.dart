// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
  id: json['id'] as String?,
  accessToken: json['accessToken'] as String?,
  refreshToken: json['refreshToken'] as String?,
  isProfileCompleted: json['isProfileCompleted'] as bool?,
);

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'isProfileCompleted': instance.isProfileCompleted,
    };
