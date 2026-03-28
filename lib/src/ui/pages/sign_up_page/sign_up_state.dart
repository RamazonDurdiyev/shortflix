import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class SignUpState extends Equatable {}

class SignUpInitial extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpSubmitState extends SignUpState {
  final BaseState state;
  SignUpSubmitState({required this.state});
  @override
  List<Object?> get props => [state];
}