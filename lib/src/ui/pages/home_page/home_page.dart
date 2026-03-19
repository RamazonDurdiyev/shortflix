import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/ui/widgets/global/movies_grid.dart';
import 'package:shortflix/src/ui/widgets/home_page/featured_carousel.dart';

// ─────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────

class CategoryItem {
  final String label;
  final IconData icon;
  const CategoryItem({required this.label, required this.icon});
}



final List<MovieModel> kMovies = [
  const MovieModel(id: 1, title: 'Interstellar', year: 2014, rating: '8.6', imageUrl: 'imageUrl'),
  const MovieModel(id: 2, title: 'Parasite', year: 2019, rating: '8.6', imageUrl: 'imageUrl'),
  const MovieModel(id: 3, title: 'The Godfather', year: 1972, rating: '9.2', imageUrl: 'imageUrl'),
  const MovieModel(id: 4, title: 'Inception', year: 2010, rating: '8.8', imageUrl: 'imageUrl'),
  const MovieModel(id: 5, title: 'Joker', year: 2019, rating: '8.4', imageUrl: 'imageUrl'),
  const MovieModel(id: 6, title: 'Tenet', year: 2020, rating: '7.4', imageUrl: 'imageUrl'),
  const MovieModel(id: 7, title: 'The Dark Knight', year: 2008, rating: '9.0', imageUrl: 'imageUrl'),
  const MovieModel(id: 8, title: 'Shutter Island', year: 2010, rating: '8.2', imageUrl: 'imageUrl'),
  const MovieModel(id: 9, title: 'Prestige', year: 2006, rating: '8.5', imageUrl: 'imageUrl'),
  const MovieModel(id: 10, title: 'Hereditary', year: 2018, rating: '7.3', imageUrl: 'imageUrl'),
  const MovieModel(id: 11, title: 'Midsommar', year: 2019, rating: '7.1', imageUrl: 'imageUrl'),
  const MovieModel(id: 12, title: 'Get Out', year: 2017, rating: '7.7', imageUrl: 'imageUrl'),
];

const List<CategoryItem> kCategories = [
  CategoryItem(label: 'Action', icon: Icons.local_fire_department_rounded),
  CategoryItem(label: 'Drama', icon: Icons.theater_comedy_rounded),
  CategoryItem(label: 'Sci-Fi', icon: Icons.rocket_launch_rounded),
  CategoryItem(label: 'Horror', icon: Icons.nightlight_round),
  CategoryItem(label: 'Comedy', icon: Icons.sentiment_very_satisfied_rounded),
  CategoryItem(label: 'Thriller', icon: Icons.visibility_rounded),
  CategoryItem(label: 'Romance', icon: Icons.favorite_rounded),
  CategoryItem(label: 'Animation', icon: Icons.animation_rounded),
  CategoryItem(label: 'Documentary', icon: Icons.camera_outlined),
  CategoryItem(label: 'Crime', icon: Icons.gavel_rounded),
  CategoryItem(label: 'Fantasy', icon: Icons.auto_awesome_rounded),
  CategoryItem(label: 'History', icon: Icons.account_balance_rounded),
  CategoryItem(label: 'Mystery', icon: Icons.psychology_rounded),
  CategoryItem(label: 'Adventure', icon: Icons.explore_rounded),
  CategoryItem(label: 'Western', icon: Icons.landscape_rounded),
];

// ─────────────────────────────────────────
//  HOME PAGE
// ─────────────────────────────────────────
class NetflixHomePage extends StatelessWidget {
  const NetflixHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SliverToBoxAdapter(child: FeaturedCarousel()),

            // ── Section: Popular ──────────────────────
            const SliverToBoxAdapter(
              child: _SectionTitle(title: 'Popular on Netflix'),
            ),

            // ── Movies Grid ───────────────────────────
            const SliverToBoxAdapter(child: MoviesGrid()),

            // ── Section: Categories ───────────────────
            const SliverToBoxAdapter(
              child: _SectionTitle(title: 'Browse by Genre'),
            ),

            // ── Categories Wrap ───────────────────────
            const SliverToBoxAdapter(child: _CategoriesWrap()),

            // ── Bottom padding ────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
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
            onTap: () {
              
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ColorName.backgroundSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorName.surfaceSecondary),
              ),
              child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
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
//  CATEGORIES WRAP
// ─────────────────────────────────────────
class _CategoriesWrap extends StatefulWidget {
  const _CategoriesWrap();

  @override
  State<_CategoriesWrap> createState() => _CategoriesWrapState();
}

class _CategoriesWrapState extends State<_CategoriesWrap> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(kCategories.length, (index) {
          final cat = kCategories[index];
          final isActive = _selected == index;
          return GestureDetector(
            onTap: () => setState(() => _selected = isActive ? null : index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? ColorName.accent : ColorName.backgroundSecondary,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isActive ? ColorName.accent : ColorName.surfaceSecondary,
                  width: 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: ColorName.accent.withValues(alpha: .35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat.icon,
                    size: 14,
                    color: isActive ? Colors.white : ColorName.contentSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: TextStyle(
                      color: isActive ? Colors.white : ColorName.contentSecondary,
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}