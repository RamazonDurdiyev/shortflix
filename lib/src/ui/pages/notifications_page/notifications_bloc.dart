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
    emit(FetchNotificationsState(state: BaseState.loading));

    List<NotificationModel> mine = [];
    List<NotificationModel> broadcasts = [];
    bool mineOk = false;
    bool broadcastsOk = false;

    await Future.wait([
      () async {
        try {
          mine = await notificationsRepo.list();
          mineOk = true;
        } catch (e) {
          printDebug("NotificationsBloc fetch personal error => $e");
        }
      }(),
      () async {
        try {
          broadcasts = await notificationsRepo.broadcasts();
          broadcastsOk = true;
        } catch (e) {
          printDebug("NotificationsBloc fetch broadcasts error => $e");
        }
      }(),
    ]);

    if (!mineOk && !broadcastsOk) {
      notifications = [];
      emit(FetchNotificationsState(state: BaseState.error));
      return;
    }

    final combined = [...mine, ...broadcasts];
    combined.sort((a, b) {
      final ad = a.createdAt;
      final bd = b.createdAt;
      if (ad == null && bd == null) return 0;
      if (ad == null) return 1;
      if (bd == null) return -1;
      return bd.compareTo(ad);
    });
    notifications = combined;
    emit(FetchNotificationsState(state: BaseState.loaded));

    if (mineOk) {
      _markAllReadInBackground();
    }
  }

  void _markAllReadInBackground() {
    notificationsRepo.markAllRead().catchError((e) {
      printDebug("NotificationsBloc _markAllRead error => $e");
    });
  }
}
