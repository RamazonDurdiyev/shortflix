import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/notification_model/notification_model.dart';
import 'package:shortflix/src/ui/pages/notifications_page/notifications_bloc.dart';
import 'package:shortflix/src/ui/pages/notifications_page/notifications_event.dart';
import 'package:shortflix/src/ui/pages/notifications_page/notifications_state.dart';

// ─────────────────────────────────────────
//  NOTIFICATIONS PAGE
// ─────────────────────────────────────────
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.backgroundPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            Expanded(
              child: BlocBuilder<NotificationsBloc, NotificationsState>(
                builder: (context, state) {
                  final bloc = context.read<NotificationsBloc>();

                  if (state is FetchNotificationsState &&
                      state.state == BaseState.loading &&
                      bloc.notifications.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorName.accent,
                        strokeWidth: 2,
                      ),
                    );
                  }

                  if (state is FetchNotificationsState &&
                      state.state == BaseState.error &&
                      bloc.notifications.isEmpty) {
                    return _buildError(context);
                  }

                  if (bloc.notifications.isEmpty) {
                    return _buildEmpty();
                  }

                  return _buildList(context, bloc.notifications);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  LIST
// ─────────────────────────────────────────
Widget _buildList(BuildContext context, List<NotificationModel> items) {
  final now = DateTime.now();
  final today = <NotificationModel>[];
  final earlier = <NotificationModel>[];
  for (final n in items) {
    final created = n.createdAt;
    if (created != null &&
        created.year == now.year &&
        created.month == now.month &&
        created.day == now.day) {
      today.add(n);
    } else {
      earlier.add(n);
    }
  }

  return RefreshIndicator(
    color: ColorName.accent,
    backgroundColor: ColorName.backgroundSecondary,
    onRefresh: () async {
      context.read<NotificationsBloc>().add(FetchNotificationsEvent());
    },
    child: ListView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        if (today.isNotEmpty) _buildSectionLabel('Today'),
        ...today.map(_buildNotificationItem),
        if (today.isNotEmpty && earlier.isNotEmpty) _buildDivider('Earlier'),
        if (today.isEmpty && earlier.isNotEmpty) _buildSectionLabel('Earlier'),
        ...earlier.map(_buildNotificationItem),
        const SizedBox(height: 24),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  TOP BAR
// ─────────────────────────────────────────
Widget _buildTopBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorName.surfaceSecondary),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  SECTION LABEL
// ─────────────────────────────────────────
Widget _buildSectionLabel(String label) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
    child: Text(
      label,
      style: TextStyle(
        color: ColorName.contentSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    ),
  );
}

// ─────────────────────────────────────────
//  SECTION DIVIDER
// ─────────────────────────────────────────
Widget _buildDivider(String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 1,
        color: ColorName.surfaceSecondary,
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      _buildSectionLabel(label),
    ],
  );
}

// ─────────────────────────────────────────
//  NOTIFICATION ITEM
// ─────────────────────────────────────────
Widget _buildNotificationItem(NotificationModel n) {
  final title = n.title ?? '';
  final body = n.body ?? '';
  final time = _formatRelative(n.createdAt);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: ColorName.accent.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.notifications_rounded,
            color: ColorName.accent,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (time.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: ColorName.contentSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
              if (body.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  EMPTY / ERROR
// ─────────────────────────────────────────
Widget _buildEmpty() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.notifications_off_outlined,
          color: ColorName.contentSecondary,
          size: 48,
        ),
        const SizedBox(height: 12),
        Text(
          'No notifications yet',
          style: TextStyle(
            color: ColorName.contentSecondary,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

Widget _buildError(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline_rounded,
          color: ColorName.contentSecondary,
          size: 48,
        ),
        const SizedBox(height: 12),
        Text(
          'Failed to load notifications',
          style: TextStyle(
            color: ColorName.contentSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context
              .read<NotificationsBloc>()
              .add(FetchNotificationsEvent()),
          child: const Text(
            'Retry',
            style: TextStyle(color: ColorName.accent),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────
String _formatRelative(DateTime? dt) {
  if (dt == null) return '';
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) return '${diff.inDays} days ago';
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '${dt.year}-$m-$d';
}
