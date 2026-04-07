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

class EpisodesSaveMovieEvent extends EpisodesEvent {
  final String movieId;
  EpisodesSaveMovieEvent({required this.movieId});
  @override
  List<Object?> get props => [movieId];
}

class EpisodesRateMovieEvent extends EpisodesEvent {
  final String movieId;
  final int rating;
  EpisodesRateMovieEvent({required this.movieId, required this.rating});
  @override
  List<Object?> get props => [movieId, rating];
}