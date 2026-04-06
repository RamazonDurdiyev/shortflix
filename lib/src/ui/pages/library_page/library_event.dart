import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {}

class FetchSavedMoviesEvent extends LibraryEvent {
  @override
  List<Object?> get props => [];
}

class FetchSavedEpisodesEvent extends LibraryEvent {
  @override
  List<Object?> get props => [];
}

class FetchLikedEpisodesEvent extends LibraryEvent {
  @override
  List<Object?> get props => [];
}

class FetchMyMoviesEvent extends LibraryEvent {
  @override
  List<Object?> get props => [];
}
