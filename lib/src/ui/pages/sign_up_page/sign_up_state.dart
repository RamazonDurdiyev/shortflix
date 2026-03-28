import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class SignUpState extends Equatable {}

class SignUpInitial extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpSubmitState extends SignUpState {
  final BaseState state;
  final String email;

  SignUpSubmitState({required this.state, required this.email});

  @override
  List<Object?> get props => [state, email];
}