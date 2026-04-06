import 'package:equatable/equatable.dart';

abstract class RecEvent extends Equatable {}

class FetchShortsEvent extends RecEvent {
  @override
  List<Object?> get props => [];
}

class RecTogglePlayPauseEvent extends RecEvent {
  @override
  List<Object?> get props => [];
}

class RecToggleMuteEvent extends RecEvent {
  @override
  List<Object?> get props => [];
}

class RecLikeEvent extends RecEvent {
  final String episodeId;
  RecLikeEvent({required this.episodeId});
  @override
  List<Object?> get props => [episodeId];
}

class RecSaveEvent extends RecEvent {
  final String episodeId;
  RecSaveEvent({required this.episodeId});
  @override
  List<Object?> get props => [episodeId];
}

class RecPageChangedEvent extends RecEvent {
  final int index;
  RecPageChangedEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class RecFetchCommentsEvent extends RecEvent {
  @override
  List<Object?> get props => [];
}

class RecAddCommentEvent extends RecEvent {
  final String comment;
  RecAddCommentEvent({required this.comment});
  @override
  List<Object?> get props => [comment];
}
