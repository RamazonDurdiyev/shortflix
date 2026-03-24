import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class PlayState extends Equatable {}

class Initial extends PlayState{
  @override
  List<Object?> get props => [];
}

class PlayPageChangedState extends PlayState{

  final BaseState state;

  PlayPageChangedState({required this.state});
  @override
  List<Object?> get props => [];
}