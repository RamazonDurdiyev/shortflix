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
  final String? userId;

  FetchMyMoviesEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

class FetchArchivedMoviesEvent extends LibraryEvent {
  @override
  List<Object?> get props => [];
}

class FetchArchivedEpisodesEvent extends LibraryEvent {
  @override
  List<Object?> get props => [];
}