import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class PlaylistsState extends Equatable {}

class Initial extends PlaylistsState {
  @override
  List<Object?> get props => [];
}

class FetchSavedMoviesState extends PlaylistsState {
  final BaseState state;
  FetchSavedMoviesState({required this.state});
  @override
  List<Object?> get props => [state];
}
