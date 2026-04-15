import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';

// ─────────────────────────────────────────
//  PLAYLISTS PAGE
// ─────────────────────────────────────────
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

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
                  _buildMenuGroup(context),
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
Widget _buildMenuGroup(BuildContext context) {
  final items = [
    _MenuItem(
      icon: Icons.movie_creation_rounded,
      label: 'My Movies',
      subtitle: 'Movies you created',
      onTap: () {
        Navigator.push(
          context,
          generateRoutes(
            RouteSettings(name: Navigation.myMoviesPage),
          )!,
        );
      },
    ),
    _MenuItem(
      icon: Icons.bookmark_rounded,
      label: 'Saved Movies',
      subtitle: 'Movies you bookmarked',
      onTap: () {
        Navigator.push(
          context,
          generateRoutes(
            RouteSettings(name: Navigation.savedMoviesPage),
          )!,
        );
      },
    ),
    _MenuItem(
      icon: Icons.video_library_rounded,
      label: 'Saved Episodes',
      subtitle: 'Episodes you bookmarked',
      onTap: () {
        Navigator.push(
          context,
          generateRoutes(
            RouteSettings(name: Navigation.savedEpisodesPage),
          )!,
        );
      },
    ),
    _MenuItem(
      icon: Icons.favorite_rounded,
      label: 'Liked Episodes',
      subtitle: 'Episodes you liked',
      color: ColorName.accent,
      onTap: () {
        Navigator.push(
          context,
          generateRoutes(
            RouteSettings(name: Navigation.likedEpisodesPage),
          )!,
        );
      },
    ),
    _MenuItem(
      icon: Icons.archive_rounded,
      label: 'Archived',
      subtitle: 'Movies and episodes you archived',
      onTap: () {
        Navigator.push(
          context,
          generateRoutes(
            RouteSettings(name: Navigation.archivedPage),
          )!,
        );
      },
    ),
  ];

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
              onTap: item.onTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (item.color ?? ColorName.contentSecondary)
                            .withValues(alpha: .1),
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
//  MENU ITEM MODEL
// ─────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color? color;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.color,
    this.onTap,
  });
}
