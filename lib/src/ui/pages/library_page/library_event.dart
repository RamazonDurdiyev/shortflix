import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {}

class FetchSavedMoviesEvent extends LibraryEvent {
  @override
  List<Object?> get props => [];
}
