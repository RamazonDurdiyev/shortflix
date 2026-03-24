import 'package:equatable/equatable.dart';

abstract class PlayEvent extends Equatable{}
 
class PlayPageChangedEvent extends PlayEvent {
  final int index;

  PlayPageChangedEvent({required this.index});
  
  @override
  List<Object?> get props => [];
}
 
 
