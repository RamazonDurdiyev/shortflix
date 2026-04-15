import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class LibraryState extends Equatable {}

class Initial extends LibraryState {
  @override
  List<Object?> get props => [];
}

class FetchSavedMoviesState extends LibraryState {
  final BaseState state;
  FetchSavedMoviesState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class FetchSavedEpisodesState extends LibraryState {
  final BaseState state;
  FetchSavedEpisodesState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class FetchLikedEpisodesState extends LibraryState {
  final BaseState state;
  FetchLikedEpisodesState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class FetchMyMoviesState extends LibraryState {
  final BaseState state;
  FetchMyMoviesState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class FetchArchivedMoviesState extends LibraryState {
  final BaseState state;
  FetchArchivedMoviesState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class FetchArchivedEpisodesState extends LibraryState {
  final BaseState state;
  FetchArchivedEpisodesState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}