import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class SignInState extends Equatable {}

class SignInInitial extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInSubmitState extends SignInState {
  final BaseState state;
  SignInSubmitState({required this.state});
  @override
  List<Object?> get props => [state];
}

class SignInGoogleState extends SignInState {
  final BaseState state;
  final String? errorMessage;
  SignInGoogleState({required this.state, this.errorMessage});
  @override
  List<Object?> get props => [state, errorMessage];
}

class SignInAppleState extends SignInState {
  final BaseState state;
  final String? errorMessage;
  SignInAppleState({required this.state, this.errorMessage});
  @override
  List<Object?> get props => [state, errorMessage];
}

// emitted when backend says user not signed up
class SignInNotSignedUpState extends SignInState {
  final String email;
  SignInNotSignedUpState({required this.email});
  @override
  List<Object?> get props => [email];
}