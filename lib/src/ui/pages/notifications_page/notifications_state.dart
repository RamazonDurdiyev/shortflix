import 'package:equatable/equatable.dart';
import 'package:shortflix/core/utils/base_state.dart';

abstract class NotificationsState extends Equatable{}

class Initial extends NotificationsState{
  @override
  List<Object?> get props => [];
}

class FetchNotificationsState extends NotificationsState {
  final BaseState state;

  FetchNotificationsState({required this.state});

  @override
  List<Object?> get props => [state];
}
