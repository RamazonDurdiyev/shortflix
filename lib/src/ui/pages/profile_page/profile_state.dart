import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable{}

class Initial extends ProfileState{
  @override
  List<Object?> get props => [];
}