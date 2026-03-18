

// ─────────────────────────────────────────
//  COLORS
// ─────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:shortflix/src/ui/widgets/global/movies_grid.dart';

class NetflixColors {
  static const Color red = Color(0xFFE50914);
  static const Color darkRed = Color(0xFF8B0000);
  static const Color bg = Color(0xFF000000);
  static const Color surface = Color(0xFF141414);
  static const Color cardBg = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color border = Color(0xFF2A2A2A);
}

// ─────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────
class CarouselItem {
  final int id;
  final String title;
  final String tag;
  final List<Color> gradientColors;
  const CarouselItem({
    required this.id,
    required this.title,
    required this.tag,
    required this.gradientColors,
  });
}

class MovieItem {
  final int id;
  final String title;
  final String year;
  final String rating;
  final String? imageUrl;
  final Color fallbackColor;
  const MovieItem({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    this.imageUrl,
    required this.fallbackColor,
  });
}

class CategoryItem {
  final String label;
  final IconData icon;
  const CategoryItem({required this.label, required this.icon});
}

// ─────────────────────────────────────────
//  SAMPLE DATA
// ─────────────────────────────────────────
const List<CarouselItem> kCarouselItems = [
  CarouselItem(
    id: 1,
    title: 'Oppenheimer',
    tag: 'TRENDING #1',
    gradientColors: [Color(0xFF7C2900), Color(0xFF3D0000), Colors.black],
  ),
  CarouselItem(
    id: 2,
    title: 'Dune: Part Two',
    tag: 'NEW RELEASE',
    gradientColors: [Color(0xFF6B4A00), Color(0xFF2D1A00), Colors.black],
  ),
  CarouselItem(
    id: 3,
    title: 'Poor Things',
    tag: 'AWARD WINNER',
    gradientColors: [Color(0xFF005555), Color(0xFF001A1A), Colors.black],
  ),
  CarouselItem(
    id: 4,
    title: 'The Bear',
    tag: 'HOT SERIES',
    gradientColors: [Color(0xFF3A3A3A), Color(0xFF1A1A1A), Colors.black],
  ),
  CarouselItem(
    id: 5,
    title: 'Killers of the Flower Moon',
    tag: 'EPIC DRAMA',
    gradientColors: [Color(0xFF7C0000), Color(0xFF2D0000), Colors.black],
  ),
  CarouselItem(
    id: 6,
    title: 'Past Lives',
    tag: 'MUST WATCH',
    gradientColors: [Color(0xFF002080), Color(0xFF000A33), Colors.black],
  ),
  CarouselItem(
    id: 7,
    title: 'Maestro',
    tag: 'BIOGRAPHY',
    gradientColors: [Color(0xFF444444), Color(0xFF1A1A1A), Colors.black],
  ),
  CarouselItem(
    id: 8,
    title: 'Saltburn',
    tag: 'THRILLER',
    gradientColors: [Color(0xFF004400), Color(0xFF001100), Colors.black],
  ),
  CarouselItem(
    id: 9,
    title: 'Zone of Interest',
    tag: 'ACCLAIMED',
    gradientColors: [Color(0xFF2A3A3A), Color(0xFF0A1010), Colors.black],
  ),
  CarouselItem(
    id: 10,
    title: 'Priscilla',
    tag: 'BIOGRAPHY',
    gradientColors: [Color(0xFF6B0050), Color(0xFF2A0020), Colors.black],
  ),
  CarouselItem(
    id: 11,
    title: 'All of Us Strangers',
    tag: 'EMOTIONAL',
    gradientColors: [Color(0xFF330066), Color(0xFF110022), Colors.black],
  ),
  CarouselItem(
    id: 12,
    title: 'American Fiction',
    tag: 'COMEDY DRAMA',
    gradientColors: [Color(0xFF6B2A00), Color(0xFF2A0A00), Colors.black],
  ),
];

final List<MovieItem> kMovies = [
  const MovieItem(id: 1, title: 'Interstellar', year: '2014', rating: '8.7', fallbackColor: Color(0xFF0A1628)),
  const MovieItem(id: 2, title: 'Parasite', year: '2019', rating: '8.6', fallbackColor: Color(0xFF1A0A00)),
  const MovieItem(id: 3, title: 'The Godfather', year: '1972', rating: '9.2', fallbackColor: Color(0xFF1A0A0A)),
  const MovieItem(id: 4, title: 'Inception', year: '2010', rating: '8.8', fallbackColor: Color(0xFF0A0A2A)),
  const MovieItem(id: 5, title: 'Joker', year: '2019', rating: '8.4', fallbackColor: Color(0xFF2A0A00)),
  const MovieItem(id: 6, title: 'Tenet', year: '2020', rating: '7.4', fallbackColor: Color(0xFF001A1A)),
  const MovieItem(id: 7, title: 'The Dark Knight', year: '2008', rating: '9.0', fallbackColor: Color(0xFF0A0A0A)),
  const MovieItem(id: 8, title: 'Shutter Island', year: '2010', rating: '8.2', fallbackColor: Color(0xFF1A1A00)),
  const MovieItem(id: 9, title: 'Prestige', year: '2006', rating: '8.5', fallbackColor: Color(0xFF0A0A1A)),
  const MovieItem(id: 10, title: 'Hereditary', year: '2018', rating: '7.3', fallbackColor: Color(0xFF1A0000)),
  const MovieItem(id: 11, title: 'Midsommar', year: '2019', rating: '7.1', fallbackColor: Color(0xFF1A1500)),
  const MovieItem(id: 12, title: 'Get Out', year: '2017', rating: '7.7', fallbackColor: Color(0xFF001A00)),
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
      backgroundColor: NetflixColors.bg,
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
            const SliverToBoxAdapter(child: _FeaturedCarousel()),

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
              color: NetflixColors.red,
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
                  'Hello, Someone 👋',
                  style: TextStyle(
                    color: NetflixColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'What are you watching today?',
                  style: TextStyle(
                    color: NetflixColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: NetflixColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NetflixColors.border),
            ),
            child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [NetflixColors.red, NetflixColors.darkRed],
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
          color: NetflixColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: NetflixColors.border, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search_rounded, color: NetflixColors.textSecondary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                style: const TextStyle(
                  color: NetflixColors.textPrimary,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Search movies, series, genres…',
                  hintStyle: TextStyle(
                    color: NetflixColors.textSecondary,
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
                color: NetflixColors.red,
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
                  color: NetflixColors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: NetflixColors.textPrimary,
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
              color: NetflixColors.red,
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
//  FEATURED CAROUSEL
// ─────────────────────────────────────────
class _FeaturedCarousel extends StatefulWidget {
  const _FeaturedCarousel();

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.80);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: kCarouselItems.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final item = kCarouselItems[index];
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: isActive ? 0 : 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: item.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: item.gradientColors.first.withOpacity(0.6),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          )
                        ]
                      : [],
                ),
                child: Stack(
                  children: [
                    // Grid pattern overlay
                    Positioned.fill(
                      child: CustomPaint(painter: _GridPainter()),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: NetflixColors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _CarouselButton(
                                icon: Icons.play_arrow_rounded,
                                label: 'Play',
                                filled: true,
                              ),
                              const SizedBox(width: 8),
                              _CarouselButton(
                                icon: Icons.add_rounded,
                                label: 'Watchlist',
                                filled: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Index badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: Text(
                          '${index + 1} / ${kCarouselItems.length}',
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(kCarouselItems.length, (i) {
            final active = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: active ? 20 : 5,
              height: 5,
              decoration: BoxDecoration(
                color: active ? NetflixColors.red : Colors.white24,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _CarouselButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  const _CarouselButton({required this.icon, required this.label, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: filled ? Colors.white : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: filled ? null : Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: filled ? Colors.black : Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: filled ? Colors.black : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Grid painter for texture on cards
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;
    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
                color: isActive ? NetflixColors.red : NetflixColors.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isActive ? NetflixColors.red : NetflixColors.border,
                  width: 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: NetflixColors.red.withOpacity(0.35),
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
                    color: isActive ? Colors.white : NetflixColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: TextStyle(
                      color: isActive ? Colors.white : NetflixColors.textSecondary,
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