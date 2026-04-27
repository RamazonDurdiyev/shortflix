import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable{}

class FetchUserEvent extends ProfileEvent{
  @override
  List<Object?> get props => [];
}

class LogoutEvent extends ProfileEvent{
  @override
  List<Object?> get props => [];
}

class DeleteAccountEvent extends ProfileEvent{
  @override
  List<Object?> get props => [];
}
