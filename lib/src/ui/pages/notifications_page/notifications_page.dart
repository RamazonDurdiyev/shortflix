import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';

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
            _buildSectionLabel('Today'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildNotificationItem(
                    type: _NotifType.newEpisode,
                    title: 'New Episode Available',
                    body: 'Season 2 Episode 4 of The Bear is now available.',
                    time: '2m ago',
                    isUnread: true,
                  ),
                  _buildNotificationItem(
                    type: _NotifType.continueWatching,
                    title: 'Continue Watching',
                    body: 'Pick up where you left off — Dune: Part Two.',
                    time: '1h ago',
                    isUnread: true,
                  ),
                  _buildNotificationItem(
                    type: _NotifType.newEpisode,
                    title: 'New Episode Available',
                    body: 'Season 1 Episode 7 of Saltburn is out now.',
                    time: '3h ago',
                    isUnread: false,
                  ),
                  _buildDivider('Earlier'),
                  _buildNotificationItem(
                    type: _NotifType.trending,
                    title: 'Trending Now',
                    body: 'Oppenheimer is #1 in your region today.',
                    time: 'Yesterday',
                    isUnread: false,
                  ),
                  _buildNotificationItem(
                    type: _NotifType.watchlist,
                    title: 'Watchlist Reminder',
                    body: 'Inception has been in your watchlist for 7 days.',
                    time: 'Yesterday',
                    isUnread: false,
                  ),
                  _buildNotificationItem(
                    type: _NotifType.continueWatching,
                    title: 'Continue Watching',
                    body: 'Resume Past Lives — you are 42 minutes in.',
                    time: '2 days ago',
                    isUnread: false,
                  ),
                  _buildNotificationItem(
                    type: _NotifType.trending,
                    title: 'New Arrival',
                    body: 'Killers of the Flower Moon just landed on Shortflix.',
                    time: '3 days ago',
                    isUnread: false,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  NOTIFICATION TYPE
// ─────────────────────────────────────────
enum _NotifType { newEpisode, continueWatching, trending, watchlist }

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
        // Mark all read button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: ColorName.backgroundSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorName.surfaceSecondary),
          ),
          child: Text(
            'Mark all read',
            style: TextStyle(
              color: ColorName.contentSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
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
Widget _buildNotificationItem({
  required _NotifType type,
  required String title,
  required String body,
  required String time,
  required bool isUnread,
}) {
  return Container(
    color: isUnread
        ? ColorName.backgroundSecondary.withValues(alpha: .5)
        : Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _notifColor(type).withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _notifIcon(type),
              color: _notifColor(type),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isUnread ? Colors.white : ColorName.contentSecondary,
                          fontSize: 14,
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: ColorName.contentSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Unread dot
          if (isUnread)
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 4),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: ColorName.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────
IconData _notifIcon(_NotifType type) {
  switch (type) {
    case _NotifType.newEpisode:       return Icons.play_circle_outline_rounded;
    case _NotifType.continueWatching: return Icons.history_rounded;
    case _NotifType.trending:         return Icons.local_fire_department_rounded;
    case _NotifType.watchlist:        return Icons.bookmark_outline_rounded;
  }
}

Color _notifColor(_NotifType type) {
  switch (type) {
    case _NotifType.newEpisode:       return ColorName.accent;
    case _NotifType.continueWatching: return const Color(0xFF2196F3);
    case _NotifType.trending:         return const Color(0xFFFF9800);
    case _NotifType.watchlist:        return const Color(0xFF8BC34A);
  }
}