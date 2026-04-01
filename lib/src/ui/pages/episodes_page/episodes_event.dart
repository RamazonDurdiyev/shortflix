import 'package:equatable/equatable.dart';

abstract class EpisodesEvent extends Equatable {}

class EpisodesFetchEvent extends EpisodesEvent {
  final String movieId;
  EpisodesFetchEvent({required this.movieId});
  @override
  List<Object?> get props => [movieId];
}

class EpisodesSelectSeasonEvent extends EpisodesEvent {
  final int season;
  EpisodesSelectSeasonEvent({required this.season});
  @override
  List<Object?> get props => [season];
}