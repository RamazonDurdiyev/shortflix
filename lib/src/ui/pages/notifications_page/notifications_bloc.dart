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

    List<NotificationModel> personal = [];
    List<NotificationModel> general = [];
    bool personalOk = false;
    bool generalOk = false;

    await Future.wait([
      () async {
        try {
          personal = await notificationsRepo.list();
          personalOk = true;
        } catch (e) {
          printDebug("NotificationsBloc fetch personal error => $e");
        }
      }(),
      () async {
        try {
          general = await notificationsRepo.broadcasts();
          generalOk = true;
        } catch (e) {
          printDebug("NotificationsBloc fetch general error => $e");
        }
      }(),
    ]);

    if (!personalOk && !generalOk) {
      notifications = [];
      emit(FetchNotificationsState(state: BaseState.error));
      return;
    }

    final combined = [...personal, ...general];
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

    if (personalOk) {
      _markAllPersonalReadInBackground();
    }
    if (generalOk) {
      _markAllGeneralReadInBackground();
    }
  }

  void _markAllPersonalReadInBackground() {
    notificationsRepo.markAllPersonalRead().catchError((e) {
      printDebug("NotificationsBloc _markAllPersonalRead error => $e");
    });
  }

  void _markAllGeneralReadInBackground() {
    notificationsRepo.markAllGeneralRead().catchError((e) {
      printDebug("NotificationsBloc _markAllGeneralRead error => $e");
    });
  }
}
