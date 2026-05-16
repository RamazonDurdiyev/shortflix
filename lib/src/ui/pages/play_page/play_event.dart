import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

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

class FetchNextEpisodeEvent extends PlayEvent {
  @override
  List<Object?> get props => [];
}

class FetchArchivedEpisodeEvent extends PlayEvent {
  final String episodeId;
  FetchArchivedEpisodeEvent({required this.episodeId});
  @override
  List<Object?> get props => [episodeId];
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

class FetchCommentsEvent extends PlayEvent {
  @override
  List<Object?> get props => [];
}

class PlayToggleMuteEvent extends PlayEvent {
  @override
  List<Object?> get props => [];
}

class AddCommentEvent extends PlayEvent {
  final String comment;
  AddCommentEvent({required this.comment});
  @override
  List<Object?> get props => [comment];
}

class FetchReportCommentCategoriesEvent extends PlayEvent{
  
  @override
  List<Object?> get props => [];
}

class ReportCommentEvent extends PlayEvent{
  final String commentId;
  final String subcategoryId;

  ReportCommentEvent({required this.commentId, required this.subcategoryId});
  @override
  List<Object?> get props => [commentId, subcategoryId];
}