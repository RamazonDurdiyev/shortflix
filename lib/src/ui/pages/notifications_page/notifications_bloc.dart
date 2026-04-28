import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/notification_model/notification_model.dart';
import 'package:shortflix/src/repository/notifications_repo/notifications_repo.dart';
import 'package:shortflix/src/ui/pages/notifications_page/notifications_event.dart';
import 'package:shortflix/src/ui/pages/notifications_page/notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepo notificationsRepo;

  List<NotificationModel> notifications = [];

  NotificationsBloc({required this.notificationsRepo}) : super(Initial()) {
    on<FetchNotificationsEvent>((event, emit) async {
      await _fetchNotifications(emit);
    });
  }

  Future<void> _fetchNotifications(Emitter<NotificationsState> emit) async {
    try {
      emit(FetchNotificationsState(state: BaseState.loading));
      notifications = await notificationsRepo.list();
      emit(FetchNotificationsState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchNotificationsState(state: BaseState.error));
      printDebug("NotificationsBloc _fetchNotifications error => $e");
    }
  }
}
