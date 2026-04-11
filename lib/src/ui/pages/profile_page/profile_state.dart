import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class ProfileState extends Equatable{}

class Initial extends ProfileState{
  @override
  List<Object?> get props => [];
}

class FetchUserState extends ProfileState{
  final BaseState state;

  FetchUserState({required this.state});
  @override
  List<Object?> get props => [state];
}

class LogoutState extends ProfileState{
  final BaseState state;

  LogoutState({required this.state});
  @override
  List<Object?> get props => [state];
}
