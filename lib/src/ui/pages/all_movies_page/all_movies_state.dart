import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class AllMoviesState extends Equatable {}

class Initial extends AllMoviesState {
  @override
  List<Object?> get props => [];
}

class FetchAllMoviesState extends AllMoviesState {
  final BaseState state;

  FetchAllMoviesState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}

class FetchCategoriesState extends AllMoviesState {
  final BaseState state;

  FetchCategoriesState({required this.state});
  @override
  List<Object?> get props => [state, UniqueKey()];
}
