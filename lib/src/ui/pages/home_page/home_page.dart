import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/ui/pages/home_page/home_bloc.dart';
import 'package:shortflix/src/ui/pages/home_page/home_event.dart';
import 'package:shortflix/src/ui/pages/home_page/home_state.dart';
import 'package:shortflix/src/ui/widgets/global/movies_grid.dart';
import 'package:shortflix/src/ui/widgets/home_page/featured_carousel.dart';

// ─────────────────────────────────────────
//  HOME PAGE
// ─────────────────────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(FetchCategoriesEvent());
    homeBloc.add(FetchMoviesEvent());
    homeBloc.add(FetchBannersEvent());
    return Scaffold(
      backgroundColor: ColorName.backgroundPrimary,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ────────────────────────────────
            const SliverToBoxAdapter(child: _Header()),

            // ── Search ────────────────────────────────
            const SliverToBoxAdapter(child: _SearchBar()),

            // ── Section: Featured ─────────────────────
            const SliverToBoxAdapter(
              child: _SectionTitle(title: 'Featured Today'),
            ),

            // ── Carousel ──────────────────────────────
            SliverToBoxAdapter(
              child: BlocBuilder<HomeBloc, HomeState>(
                bloc: homeBloc,
                buildWhen: (_, state) => state is FetchBannersState,
                builder: (context, state) {
                  return FeaturedCarousel(
                    banners: context.read<HomeBloc>().banners,
                  );
                },
              ),
            ),

            // ── Section: Popular ──────────────────────
            const SliverToBoxAdapter(
              child: _SectionTitle(title: 'Popular on Netflix'),
            ),

            // ── Movies Grid ───────────────────────────
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

            // ── Section: Categories ───────────────────
            const SliverToBoxAdapter(
              child: _SectionTitle(title: 'Browse by Genre'),
            ),

            // ── Categories Wrap ───────────────────────
            SliverToBoxAdapter(child: _buildCategoriesWrap(homeBloc)),

            // ── Bottom padding ────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  CATEGORIES WRAP
  // ─────────────────────────────────────────

  Widget _buildCategoriesWrap(HomeBloc bloc) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon(
                      //   cat.icon,
                      //   size: 14,
                      //   color: Colors.white ,
                      // ),
                      // const SizedBox(width: 6),
                      Text(
                        bloc.categories[index].name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
          // Netflix "N" logo
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
          // Notification bell
          GestureDetector(
            onTap: () {},
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
          Container(
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
            Icon(
              Icons.search_rounded,
              color: ColorName.contentSecondary,
              size: 20,
            ),
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
