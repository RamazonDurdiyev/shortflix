import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class PostState extends Equatable {}

class PostInitial extends PostState {
  @override
  List<Object?> get props => [];
}

class PickVideoState extends PostState {
  final BaseState state;
  PickVideoState({required this.state});
  @override
  List<Object?> get props => [state];
}

class PickThumbnailState extends PostState {
  final BaseState state;
  PickThumbnailState({required this.state});
  @override
  List<Object?> get props => [state];
}

class FetchCategoriesState extends PostState {
  final BaseState state;
  FetchCategoriesState({required this.state});
  @override
  List<Object?> get props => [state];
}

class SelectCategoryState extends PostState {
  final String categoryId;
  SelectCategoryState({required this.categoryId});
  @override
  List<Object?> get props => [categoryId];
}

class SelectAgeLimitState extends PostState {
  final String ageLimit;
  SelectAgeLimitState({required this.ageLimit});
  @override
  List<Object?> get props => [ageLimit];
}

class CreatePostState extends PostState {
  final BaseState state;
  CreatePostState({required this.state});
  @override
  List<Object?> get props => [state];
}