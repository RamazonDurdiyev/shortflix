import 'package:equatable/equatable.dart';

abstract class ConfirmationEvent extends Equatable {}

class ConfirmationSubmitEvent extends ConfirmationEvent {
  final String email;
  final String code;

  ConfirmationSubmitEvent({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}

class ConfirmationResendEvent extends ConfirmationEvent {
  final String email;

  ConfirmationResendEvent({required this.email});

  @override
  List<Object?> get props => [email];
}