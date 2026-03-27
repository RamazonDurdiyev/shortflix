import 'package:equatable/equatable.dart';

abstract class RecState extends Equatable{}

class Initial extends RecState{
  @override
  List<Object?> get props => [];
}