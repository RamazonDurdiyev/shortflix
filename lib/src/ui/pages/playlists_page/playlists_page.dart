import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';

// ─────────────────────────────────────────
//  PLAYLISTS PAGE
// ─────────────────────────────────────────
class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 8),
                  _buildSectionTitle('My Library'),
                  _buildMenuGroup([
                    _PlaylistItem(
                      icon: Icons.bookmark_rounded,
                      label: 'Watchlist',
                      subtitle: '12 titles saved',
                      badge: '12',
                    ),
                    _PlaylistItem(
                      icon: Icons.history_rounded,
                      label: 'Watch History',
                      subtitle: 'Continue where you left off',
                    ),
                    _PlaylistItem(
                      icon: Icons.download_rounded,
                      label: 'Downloads',
                      subtitle: '3 videos available offline',
                      badge: '3',
                    ),
                    _PlaylistItem(
                      icon: Icons.favorite_rounded,
                      label: 'Liked Videos',
                      subtitle: '36 videos liked',
                      color: ColorName.accent,
                    ),
                  ]),
                  _buildSectionTitle('Playlists'),
                  _buildCreatePlaylistButton(),
                  const SizedBox(height: 12),
                  _buildPlaylistCard(
                    title: 'My Favourites',
                    count: 8,
                    icon: Icons.star_rounded,
                    color: const Color(0xFFFFB300),
                  ),
                  _buildPlaylistCard(
                    title: 'Watch Later',
                    count: 5,
                    icon: Icons.schedule_rounded,
                    color: const Color(0xFF2196F3),
                  ),
                  _buildPlaylistCard(
                    title: 'Action Movies',
                    count: 14,
                    icon: Icons.local_fire_department_rounded,
                    color: ColorName.accent,
                  ),
                  const SizedBox(height: 32),
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
//  MODEL
// ─────────────────────────────────────────
class _PlaylistItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final String? badge;
  final Color? color;

  const _PlaylistItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.badge,
    this.color,
  });
}

// ─────────────────────────────────────────
//  TOP BAR
// ─────────────────────────────────────────
Widget _buildTopBar() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Row(
      children: [
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'My Library',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: ColorName.backgroundSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorName.surfaceSecondary),
          ),
          child: const Icon(
            Icons.search_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  SECTION TITLE
// ─────────────────────────────────────────
Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: ColorName.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: ColorName.contentSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  MENU GROUP
// ─────────────────────────────────────────
Widget _buildMenuGroup(List<_PlaylistItem> items) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: ColorName.backgroundSecondary,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ColorName.surfaceSecondary),
    ),
    child: Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        final color = item.color ?? Colors.white;

        return Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (item.color ?? ColorName.contentSecondary).withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              color: color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              color: ColorName.contentSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.badge != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ColorName.accent.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.badge!,
                          style: TextStyle(
                            color: ColorName.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorName.contentSecondary,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
            if (!isLast)
              Container(
                height: 1,
                margin: const EdgeInsets.only(left: 70),
                color: ColorName.surfaceSecondary,
              ),
          ],
        );
      }),
    ),
  );
}

// ─────────────────────────────────────────
//  CREATE PLAYLIST BUTTON
// ─────────────────────────────────────────
Widget _buildCreatePlaylistButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: () {},
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: ColorName.backgroundSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ColorName.accent.withValues(alpha: .4),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: ColorName.accent, size: 20),
            const SizedBox(width: 8),
            Text(
              'Create new playlist',
              style: TextStyle(
                color: ColorName.accent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────
//  PLAYLIST CARD
// ─────────────────────────────────────────
Widget _buildPlaylistCard({
  required String title,
  required int count,
  required IconData icon,
  required Color color,
}) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorName.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorName.surfaceSecondary),
      ),
      child: Row(
        children: [
          // Icon box
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$count videos',
                  style: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // More options
          Icon(
            Icons.more_vert_rounded,
            color: ColorName.contentSecondary,
            size: 20,
          ),
        ],
      ),
    ),
  );
}