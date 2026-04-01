import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class PlayState extends Equatable {}

class Initial extends PlayState {
  @override
  List<Object?> get props => [];
}

class PlayPageChangedState extends PlayState {
  final BaseState state;
  final int index;
  PlayPageChangedState({required this.state, required this.index});
  @override
  List<Object?> get props => [state, index];
}

class FetchEpisodeState extends PlayState {
  final BaseState state;
  FetchEpisodeState({required this.state});
  @override
  List<Object?> get props => [state];
}

class PlayToggleState extends PlayState {
  final bool isPlaying;
  PlayToggleState({required this.isPlaying});
  @override
  List<Object?> get props => [isPlaying];
}

class PlayLikeState extends PlayState {
  final BaseState state;
  final bool isLiked;
  PlayLikeState({required this.state, required this.isLiked});
  @override
  List<Object?> get props => [state, isLiked];
}

class PlaySaveState extends PlayState {
  final BaseState state;
  final bool isSaved;
  PlaySaveState({required this.state, required this.isSaved});
  @override
  List<Object?> get props => [state, isSaved];
}