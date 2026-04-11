import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {}

class SignInSubmitEvent extends SignInEvent {
  final String email;
  final String password;

  SignInSubmitEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignInGoogleEvent extends SignInEvent {
  @override
  List<Object?> get props => [];
}