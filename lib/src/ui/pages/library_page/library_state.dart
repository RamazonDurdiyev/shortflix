import 'package:equatable/equatable.dart';
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
  List<Object?> get props => [state];
}
