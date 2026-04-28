import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable{}

class FetchNotificationsEvent extends NotificationsEvent {
  @override
  List<Object?> get props => [];
}
