import 'package:equatable/equatable.dart';

abstract class PlaylistsEvent extends Equatable {}

class FetchSavedMoviesEvent extends PlaylistsEvent {
  @override
  List<Object?> get props => [];
}
