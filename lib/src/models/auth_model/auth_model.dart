import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  String? accessToken;
  String? refreshToken;

  AuthModel({
    this.accessToken,
    this.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> data) =>
      _$AuthModelFromJson(data);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}
