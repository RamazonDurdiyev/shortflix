import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable{}

class Initial extends SignUpState{
  @override
  List<Object?> get props => [];
}