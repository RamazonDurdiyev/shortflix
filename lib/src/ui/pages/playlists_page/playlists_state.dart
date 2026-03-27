import 'package:equatable/equatable.dart';

abstract class PlaylistsState extends Equatable{}

class Initial extends PlaylistsState{
  @override
  List<Object?> get props => [];
}