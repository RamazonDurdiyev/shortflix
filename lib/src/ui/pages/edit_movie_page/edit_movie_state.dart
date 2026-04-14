import 'package:shortflix/core/utils/base_state.dart';

abstract class EditMovieState {}

class EditMovieInitial extends EditMovieState {}

class FetchCategoriesState extends EditMovieState {
  final BaseState state;
  FetchCategoriesState({required this.state});
}

class PickImageState extends EditMovieState {
  final BaseState state;
  PickImageState({required this.state});
}

class RemoveImageState extends EditMovieState {}

class SelectCategoryState extends EditMovieState {
  final String categoryId;
  SelectCategoryState({required this.categoryId});
}

class SelectAgeLimitState extends EditMovieState {
  final String ageLimit;
  SelectAgeLimitState({required this.ageLimit});
}

class UpdateMovieState extends EditMovieState {
  final BaseState state;
  UpdateMovieState({required this.state});
}

class DeleteMovieState extends EditMovieState {
  final BaseState state;
  DeleteMovieState({required this.state});
}

class ArchiveMovieState extends EditMovieState {
  final BaseState state;
  ArchiveMovieState({required this.state});
}
