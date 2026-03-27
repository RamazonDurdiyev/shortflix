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

class ChangeNavBarIndexEvent extends HomeEvent{
  final int navBarIndex;

  ChangeNavBarIndexEvent({required this.navBarIndex});
  @override
  List<Object?> get props => [navBarIndex];
}