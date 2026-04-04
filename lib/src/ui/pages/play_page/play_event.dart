import 'package:equatable/equatable.dart';

abstract class PlayEvent extends Equatable {}

class PlayPageChangedEvent extends PlayEvent {
  final int index;
  PlayPageChangedEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class FetchEpisodeEvent extends PlayEvent {
  final int episodeNumber;
  final String movieId;
  FetchEpisodeEvent({required this.movieId, required this.episodeNumber});
  @override
  List<Object?> get props => [movieId];
}

class PlayTogglePlayPauseEvent extends PlayEvent {
  @override
  List<Object?> get props => [];
}

class PlayLikeMovieEvent extends PlayEvent {
  final String movieId;
  PlayLikeMovieEvent({required this.movieId});
  @override
  List<Object?> get props => [movieId];
}

class PlaySaveMovieEvent extends PlayEvent {
  final String movieId;
  PlaySaveMovieEvent({required this.movieId});
  @override
  List<Object?> get props => [movieId];
}