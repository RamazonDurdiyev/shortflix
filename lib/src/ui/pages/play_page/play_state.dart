import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
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
  List<Object?> get props => [state, UniqueKey()];
}

class PlayToggleState extends PlayState {
  final bool isPlaying;
  PlayToggleState({required this.isPlaying});
  @override
  List<Object?> get props => [isPlaying];
}

class PlayMuteState extends PlayState {
  final bool isMuted;
  PlayMuteState({required this.isMuted});
  @override
  List<Object?> get props => [isMuted];
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

class FetchCommentsState extends PlayState {
  final BaseState state;
  FetchCommentsState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class AddCommentState extends PlayState {
  final BaseState state;
  AddCommentState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class FetchReportCommentCategoriesState extends PlayState{
  final BaseState state;

  FetchReportCommentCategoriesState({required this.state});
  @override
  List<Object?> get props => [state];
}

class ReportCommentState extends PlayState{
  final BaseState state;

  ReportCommentState({required this.state});
  @override
  List<Object?> get props => [state];
}