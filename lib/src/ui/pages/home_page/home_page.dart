import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/src/ui/pages/home_page/home_bloc.dart';
import 'package:shortflix/src/ui/pages/home_page/home_event.dart';
import 'package:shortflix/src/ui/pages/home_page/home_state.dart';
import 'package:shortflix/src/ui/pages/library_page/library_page.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_page.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_page.dart';
import 'package:shortflix/src/ui/pages/post_page/post_page.dart';
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

List<_NavItem> _buildNavItems(AppLocalizations l) => [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: l.navHome,
      ),
      _NavItem(
        icon: Icons.video_collection_outlined,
        activeIcon: Icons.video_collection_rounded,
        label: l.shorts,
      ),
      _NavItem(
        icon: Icons.add_circle_outline_rounded,
        activeIcon: Icons.add_circle_rounded,
        label: l.navPost,
      ),
      _NavItem(
        icon: Icons.playlist_play_outlined,
        activeIcon: Icons.playlist_play_rounded,
        label: l.navLibrary,
      ),
      _NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: l.profile,
      ),
    ];

// ─────────────────────────────────────────
//  PAGES
// ─────────────────────────────────────────
const List<Widget> _pages = [
  _HomeContent(),
  RecPage(),
  PostPage(),
  LibraryPage(),
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
class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(FetchCategoriesEvent());
    homeBloc.add(FetchMoviesEvent());
    homeBloc.add(FetchBannersEvent());
    homeBloc.add(FetchUserEvent());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _onSearch(query);
    });
  }

  void _onSearch(String query) {
    final bloc = context.read<HomeBloc>();
    if (query.trim().isEmpty) {
      bloc.add(ClearSearchEvent());
    } else {
      bloc.add(SearchMoviesEvent(query: query.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();

    return SafeArea(
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (_, state) =>
            state is SearchMoviesState || state is ClearSearchState,
        builder: (context, state) {
          final isSearching = homeBloc.isSearching;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ──────────────────────────────
              const SliverToBoxAdapter(child: _Header()),

              // ── Search ──────────────────────────────
              SliverToBoxAdapter(
                child: _SearchBar(
                  controller: _searchController,
                  onSearch: _onSearch,
                  onChanged: _onSearchChanged,
                  focusNode: _searchFocusNode,
                  onClear: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                    homeBloc.add(ClearSearchEvent());
                  },
                  isSearching: isSearching,
                ),
              ),

              // ── Search results OR normal content ────
              if (isSearching) ...[
                // Search results
                SliverToBoxAdapter(
                  child: _buildSearchResults(homeBloc, state),
                ),
              ] else ...[
                // ── Section: Featured ───────────────────
                SliverToBoxAdapter(
                  child: _SectionTitle(
                      title: AppLocalizations.of(context).featuredToday),
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
                SliverToBoxAdapter(
                  child: _SectionTitle(
                    title: AppLocalizations.of(context).popularOnShortflix,
                    onSeeAll: () {
                      Navigator.push(
                        context,
                        generateRoutes(
                          const RouteSettings(
                            name: Navigation.allMoviesPage,
                          ),
                        )!,
                      );
                    },
                  ),
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
                          child:
                              CircularProgressIndicator(color: ColorName.accent),
                        );
                      }
                      return MoviesGrid(movies: homeBloc.movies);
                    },
                  ),
                ),

                // ── Section: Categories ──────────────────
                SliverToBoxAdapter(
                  child: _SectionTitle(
                      title: AppLocalizations.of(context).browseByGenre),
                ),

                // ── Categories Wrap ───────────────────────
                SliverToBoxAdapter(child: _buildCategoriesWrap(homeBloc)),
              ],

              // ── Bottom padding ────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(HomeBloc bloc, HomeState state) {
    final l = AppLocalizations.of(context);
    if (state is SearchMoviesState && state.state == BaseState.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(color: ColorName.accent),
        ),
      );
    }

    if (bloc.searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            l.noMoviesFound,
            style: TextStyle(color: ColorName.contentSecondary, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text(
            l.searchResultsCount(bloc.searchResults.length),
            style: const TextStyle(
              color: ColorName.contentPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
        ),
        MoviesGrid(movies: bloc.searchResults),
      ],
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
              final category = bloc.categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    generateRoutes(
                      RouteSettings(
                        name: Navigation.allMoviesPage,
                        arguments: category.id,
                      ),
                    )!,
                  );
                },
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
                    category.name,
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
            child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (_, state) => state is FetchUserState,
              builder: (context, state) {
                final l = AppLocalizations.of(context);
                final fullName = context.read<HomeBloc>().user?.fullName ?? '';
                final hasName = fullName.trim().isNotEmpty;
                final firstName = hasName
                    ? fullName.trim().split(RegExp(r'\s+')).first
                    : l.fallbackGreetingName;
                const nameStyle = TextStyle(
                  color: ColorName.contentPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(l.hello, style: nameStyle),
                        Flexible(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 700),
                            switchInCurve:
                                const Interval(0.55, 1.0, curve: Curves.easeOut),
                            switchOutCurve:
                                const Interval(0.55, 1.0, curve: Curves.easeIn),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(opacity: animation, child: child),
                            child: Text(
                              firstName,
                              key: ValueKey(firstName),
                              style: nameStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.whatAreYouWatchingToday,
                      style: TextStyle(
                        color: ColorName.contentSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
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
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SEARCH BAR
// ─────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool isSearching;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onSearch,
    required this.onChanged,
    required this.onClear,
    required this.isSearching,
  });

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
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onSubmitted: onSearch,
                style: const TextStyle(
                  color: ColorName.contentPrimary,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchMoviesHint,
                  hintStyle: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (isSearching)
              GestureDetector(
                onTap: onClear,
                child: Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: ColorName.surfaceSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
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
  final VoidCallback? onSeeAll;
  const _SectionTitle({required this.title, this.onSeeAll});

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
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                AppLocalizations.of(context).seeAll,
                style: TextStyle(
                  color: ColorName.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
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
    final navItems = _buildNavItems(AppLocalizations.of(context));
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
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
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