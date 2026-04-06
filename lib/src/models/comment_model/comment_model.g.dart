// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
  id: json['id'] as String?,
  comment: json['comment'] as String?,
  userId: json['userId'] as String?,
  userName: json['userName'] as String?,
  createdTime: json['createdTime'] as String?,
);

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'userId': instance.userId,
      'userName': instance.userName,
      'createdTime': instance.createdTime,
    };
