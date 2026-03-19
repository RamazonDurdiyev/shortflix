import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable{}

class Initial extends HomeState{
  @override
  List<Object?> get props => [];
}