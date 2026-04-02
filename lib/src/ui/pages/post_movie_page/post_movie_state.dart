import 'package:shortflix/core/utils/base_state.dart';

abstract class PostMovieState {}

class PostMovieInitial extends PostMovieState {}

class PickImageState extends PostMovieState {
  final BaseState state;
  PickImageState({required this.state});
}

class FetchCategoriesState extends PostMovieState {
  final BaseState state;
  FetchCategoriesState({required this.state});
}

class SelectCategoryState extends PostMovieState {
  final String categoryId;
  SelectCategoryState({required this.categoryId});
}

class SelectAgeLimitState extends PostMovieState {
  final String ageLimit;
  SelectAgeLimitState({required this.ageLimit});
}

class CreateMovieState extends PostMovieState {
  final BaseState state;
  CreateMovieState({required this.state});
}