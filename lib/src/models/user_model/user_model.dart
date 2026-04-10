class UserModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? dateOfBirth;
  final String? createdAt;
  final String? role;

  const UserModel({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.avatar,
    this.dateOfBirth,
    this.createdAt,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String?,
    fullName: json['fullName'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    avatar: json['avatar'] as String?,
    dateOfBirth: json['dateOfBirth'] as String?,
    createdAt: json['createdAt'] as String?,
    role: json['role'] as String?,
  );
}
