import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/src/ui/pages/home_page/home_bloc.dart';
import 'package:shortflix/src/ui/pages/home_page/home_event.dart';
import 'package:shortflix/src/ui/pages/home_page/home_state.dart';
import 'package:shortflix/src/ui/pages/playlists_page/playlists_page.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_page.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_page.dart';
import 'package:shortflix/src/ui/post_page/post_page.dart';
import 'package:shortflix/src/ui/widgets/global/movies_grid.dart';
import 'package:shortflix/src/ui/widgets/home_page/featured_carousel.dart';

// ─────────────────────────────────────────
//  NAV ITEM MODEL
// ─────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

const List<_NavItem> _navItems = [
  _NavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'Home',
  ),
  _NavItem(
    icon: Icons.video_collection_outlined,
    activeIcon: Icons.video_collection_rounded,
    label: 'Shorts',
  ),
  _NavItem(
    icon: Icons.add_circle_outline_rounded,
    activeIcon: Icons.add_circle_rounded,
    label: 'Post',
  ),
  _NavItem(
    icon: Icons.playlist_play_outlined,
    activeIcon: Icons.playlist_play_rounded,
    label: 'Playlists',
  ),
  _NavItem(
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    label: 'Profile',
  ),
];

// ─────────────────────────────────────────
//  PAGES
// ─────────────────────────────────────────
const List<Widget> _pages = [
  _HomeContent(),
  RecPage(),
  PostPage(),
  PlaylistsPage(),
  ProfilePage(),
];

// ─────────────────────────────────────────
//  HOME PAGE  (main scaffold)
// ─────────────────────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();

    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc,
      buildWhen: (_, state) => state is ChangeNavBarIndexState,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorName.backgroundPrimary,
          body: IndexedStack(
            index: homeBloc.currentNavBarIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: homeBloc.currentNavBarIndex,
            onTap: (index) {
              homeBloc.add(ChangeNavBarIndexEvent(navBarIndex: index));
            },
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
//  HOME CONTENT  (tab 0)
// ─────────────────────────────────────────
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(FetchCategoriesEvent());
    homeBloc.add(FetchMoviesEvent());
    homeBloc.add(FetchBannersEvent());

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────
          const SliverToBoxAdapter(child: _Header()),

          // ── Search ──────────────────────────────
          const SliverToBoxAdapter(child: _SearchBar()),

          // ── Section: Featured ───────────────────
          const SliverToBoxAdapter(
            child: _SectionTitle(title: 'Featured Today'),
          ),

          // ── Carousel ────────────────────────────
          SliverToBoxAdapter(
            child: BlocBuilder<HomeBloc, HomeState>(
              bloc: homeBloc,
              buildWhen: (_, state) => state is FetchBannersState,
              builder: (context, state) {
                return FeaturedCarousel(banners: homeBloc.banners);
              },
            ),
          ),

          // ── Section: Popular ─────────────────────
          const SliverToBoxAdapter(
            child: _SectionTitle(title: 'Popular on Shortflix'),
          ),

          // ── Movies Grid ──────────────────────────
          SliverToBoxAdapter(
            child: BlocBuilder<HomeBloc, HomeState>(
              bloc: homeBloc,
              buildWhen: (_, state) => state is FetchMoviesState,
              builder: (context, state) {
                if (state is FetchMoviesState &&
                    state.state == BaseState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: ColorName.accent),
                  );
                }
                return MoviesGrid(movies: homeBloc.movies);
              },
            ),
          ),

          // ── Section: Categories ──────────────────
          const SliverToBoxAdapter(
            child: _SectionTitle(title: 'Browse by Genre'),
          ),

          // ── Categories Wrap ───────────────────────
          SliverToBoxAdapter(child: _buildCategoriesWrap(homeBloc)),

          // ── Bottom padding ────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  CATEGORIES WRAP
  // ─────────────────────────────────────────
  Widget _buildCategoriesWrap(HomeBloc bloc) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
      buildWhen: (_, state) => state is FetchCategoriesState,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(bloc.categories.length, (index) {
              return GestureDetector(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ColorName.backgroundSecondary,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: ColorName.surfaceSecondary,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    bloc.categories[index].name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ColorName.accent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'N',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Someone',
                  style: TextStyle(
                    color: ColorName.contentPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'What are you watching today?',
                  style: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Notifications
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                generateRoutes(
                  RouteSettings(name: Navigation.notificationsPage),
                )!,
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ColorName.backgroundSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorName.surfaceSecondary),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Avatar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                generateRoutes(
                  RouteSettings(name: Navigation.profilePage),
                )!,
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [ColorName.accent, ColorName.accentDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SEARCH BAR
// ─────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: ColorName.backgroundSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorName.surfaceSecondary, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search_rounded, color: ColorName.contentSecondary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                style: const TextStyle(
                  color: ColorName.contentPrimary,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Search movies, series, genres…',
                  hintStyle: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: ColorName.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Go',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SECTION TITLE
// ─────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: ColorName.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: ColorName.contentPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          Text(
            'See all',
            style: TextStyle(
              color: ColorName.accent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  BOTTOM NAV BAR
// ─────────────────────────────────────────
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorName.backgroundSecondary,
        border: Border(
          top: BorderSide(color: ColorName.surfaceSecondary, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isActive = index == currentIndex;
              final isPost = index == 2;

              // ── Post button (center) ─────────────────
              if (isPost) {
                return GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ColorName.accent,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: ColorName.accent.withValues(alpha: .4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(item.activeIcon, color: Colors.white, size: 26),
                  ),
                );
              }

              // ── Regular nav item ─────────────────────
              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? ColorName.accent.withValues(alpha: .12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive
                              ? ColorName.accent
                              : ColorName.contentSecondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: isActive
                              ? ColorName.accent
                              : ColorName.contentSecondary,
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.w400,
                        ),
                        child: Text(item.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}