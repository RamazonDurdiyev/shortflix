import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class EpisodesState extends Equatable {}

class EpisodesInitial extends EpisodesState {
  @override
  List<Object?> get props => [];
}

class EpisodesFetchState extends EpisodesState {
  final BaseState state;
  EpisodesFetchState({required this.state});
  @override
  List<Object?> get props => [state];
}

class EpisodesSelectSeasonState extends EpisodesState {
  final int season;
  EpisodesSelectSeasonState({required this.season});
  @override
  List<Object?> get props => [season];
}

class EpisodesSaveMovieState extends EpisodesState {
  final BaseState state;
  final bool isSaved;
  EpisodesSaveMovieState({required this.state, required this.isSaved});
  @override
  List<Object?> get props => [state, isSaved];
}

class EpisodesRateMovieState extends EpisodesState {
  final BaseState state;
  final int rating;
  EpisodesRateMovieState({required this.state, required this.rating});
  @override
  List<Object?> get props => [state, rating];
}