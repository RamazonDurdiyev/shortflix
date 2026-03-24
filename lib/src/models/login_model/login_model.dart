import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  String? id;
  String? accessToken;
  String? refreshToken;
  bool? isProfileCompleted;

  LoginModel({
    this.id,
    this.accessToken,
    this.refreshToken,
    this.isProfileCompleted,
  });

  factory LoginModel.fromJson(Map<String, dynamic> data) =>
      _$LoginModelFromJson(data);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
