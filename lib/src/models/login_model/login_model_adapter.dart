import 'package:hive_flutter/hive_flutter.dart';

import 'login_model.dart';

class LoginModelAdapter extends TypeAdapter<LoginModel> {
  @override
  final int typeId = 0;

  @override
  LoginModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return LoginModel(
      id: fields[0] as String?,
      accessToken: fields[1] as String?,
      refreshToken: fields[2] as String?,
      isProfileCompleted: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, LoginModel obj) {
    writer
      ..writeByte(4) // total number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.refreshToken)
      ..writeByte(3)
      ..write(obj.isProfileCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
