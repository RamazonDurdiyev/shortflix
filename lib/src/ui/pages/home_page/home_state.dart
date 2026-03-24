import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class HomeState extends Equatable{}

class Initial extends HomeState{
  @override
  List<Object?> get props => [];
}

class FetchCategoriesState extends HomeState{
  final BaseState state;

  FetchCategoriesState({required this.state});
  @override
  List<Object?> get props => [state];
}

class FetchMoviesState extends HomeState{
  final BaseState state;

  FetchMoviesState({required this.state});
  @override
  List<Object?> get props => [state];
}

class FetchBannersState extends HomeState{

  final BaseState state;

  FetchBannersState({required this.state});
  @override
  List<Object?> get props => [state];
}