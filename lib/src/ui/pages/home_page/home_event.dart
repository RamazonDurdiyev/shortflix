import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class FetchCategoriesEvent extends HomeEvent{
  @override
  List<Object?> get props => [];
}

class FetchMoviesEvent extends HomeEvent{
  @override
  List<Object?> get props => [];
}

class FetchBannersEvent extends HomeEvent{
  @override
  List<Object?> get props => [];
}
