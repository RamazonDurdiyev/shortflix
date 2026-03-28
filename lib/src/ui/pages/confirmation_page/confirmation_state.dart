import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class ConfirmationState extends Equatable {}

class ConfirmationInitial extends ConfirmationState {
  @override
  List<Object?> get props => [];
}

class ConfirmationSubmitState extends ConfirmationState {
  final BaseState state;
  ConfirmationSubmitState({required this.state});
  @override
  List<Object?> get props => [state];
}

class ConfirmationResendState extends ConfirmationState {
  final BaseState state;
  ConfirmationResendState({required this.state});
  @override
  List<Object?> get props => [state];
}