import 'package:equatable/equatable.dart';

abstract class AllMoviesEvent extends Equatable {}

class FetchAllMoviesEvent extends AllMoviesEvent {
  @override
  List<Object?> get props => [];
}

class FetchCategoriesEvent extends AllMoviesEvent {
  @override
  List<Object?> get props => [];
}

class SelectCategoryEvent extends AllMoviesEvent {
  final String? categoryId;

  SelectCategoryEvent({required this.categoryId});
  @override
  List<Object?> get props => [categoryId];
}
