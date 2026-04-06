import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String? id;
  final String? comment;
  final String? userId;
  final String? userName;
  final String? createdTime;

  const CommentModel({
    this.id,
    this.comment,
    this.userId,
    this.userName,
    this.createdTime,
  });

  factory CommentModel.fromJson(Map<String, dynamic> data) =>
      _$CommentModelFromJson(data);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
