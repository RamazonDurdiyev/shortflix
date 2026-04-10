import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class EditProfileState extends Equatable {}

class Initial extends EditProfileState {
  @override
  List<Object?> get props => [];
}

class PickImageState extends EditProfileState {
  final BaseState state;

  PickImageState({required this.state});

  @override
  List<Object?> get props => [state];
}

class UpdateUserState extends EditProfileState {
  final BaseState state;

  UpdateUserState({required this.state});

  @override
  List<Object?> get props => [state];
}
