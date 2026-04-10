import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {}

class PickImageEvent extends EditProfileEvent {
  @override
  List<Object?> get props => [];
}

class UpdateUserEvent extends EditProfileEvent {
  final String fullName;
  final String phone;
  final String currentAvatar;
  final String dateOfBirth;

  UpdateUserEvent({
    required this.fullName,
    required this.phone,
    required this.currentAvatar,
    required this.dateOfBirth,
  });

  @override
  List<Object?> get props => [fullName, phone, currentAvatar, dateOfBirth];
}
