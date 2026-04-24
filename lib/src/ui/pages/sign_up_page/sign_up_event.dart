import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {}

class SignUpSubmitEvent extends SignUpEvent {
  final String fullName;
  final String email;
  final String password;
  final String birthDateIso; // ISO 8601 UTC

  SignUpSubmitEvent({
    required this.fullName,
    required this.email,
    required this.password,
    required this.birthDateIso,
  });

  @override
  List<Object?> get props => [fullName, email, password, birthDateIso];
}

class SignUpGoogleEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

class SignUpAppleEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}