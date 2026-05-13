import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class RecState extends Equatable {}

class Initial extends RecState {
  @override
  List<Object?> get props => [];
}

class FetchShortsState extends RecState {
  final BaseState state;
  FetchShortsState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class RecToggleState extends RecState {
  final bool isPlaying;
  RecToggleState({required this.isPlaying});
  @override
  List<Object?> get props => [isPlaying];
}

class RecMuteState extends RecState {
  final bool isMuted;
  RecMuteState({required this.isMuted});
  @override
  List<Object?> get props => [isMuted];
}

class RecLikeState extends RecState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class RecSaveState extends RecState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class RecPageChangedState extends RecState {
  final int index;
  RecPageChangedState({required this.index});
  @override
  List<Object?> get props => [index, UniqueKey()];
}

class RecFetchCommentsState extends RecState {
  final BaseState state;
  RecFetchCommentsState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class RecAddCommentState extends RecState {
  final BaseState state;
  RecAddCommentState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

