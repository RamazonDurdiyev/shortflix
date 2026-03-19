import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/featured_carousel_model/featured_carousel_model.dart';

class FeaturedCarousel extends StatefulWidget {
  const FeaturedCarousel({super.key});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.80);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // ─────────────────────────────────────────
//  SAMPLE DATA
// ─────────────────────────────────────────
 List<FeaturedCarouselModel> kCarouselItems = [
  FeaturedCarouselModel(
    id: 1,
    title: 'Oppenheimer',
    tag: 'TRENDING #1',
  ),
  FeaturedCarouselModel(
    id: 2,
    title: 'Dune: Part Two',
    tag: 'NEW RELEASE',
  ),
  FeaturedCarouselModel(
    id: 3,
    title: 'Poor Things',
    tag: 'AWARD WINNER',
  ),
  FeaturedCarouselModel(
    id: 4,
    title: 'The Bear',
    tag: 'HOT SERIES',
  ),
  FeaturedCarouselModel(
    id: 5,
    title: 'Killers of the Flower Moon',
    tag: 'EPIC DRAMA',
  ),
  FeaturedCarouselModel(
    id: 6,
    title: 'Past Lives',
    tag: 'MUST WATCH',
  ),
  FeaturedCarouselModel(
    id: 7,
    title: 'Maestro',
    tag: 'BIOGRAPHY',
  ),
  FeaturedCarouselModel(
    id: 8,
    title: 'Saltburn',
    tag: 'THRILLER',
  ),
  FeaturedCarouselModel(
    id: 9,
    title: 'Zone of Interest',
    tag: 'ACCLAIMED',
  ),
  FeaturedCarouselModel(
    id: 10,
    title: 'Priscilla',
    tag: 'BIOGRAPHY',
  ),
  FeaturedCarouselModel(
    id: 11,
    title: 'All of Us Strangers',
    tag: 'EMOTIONAL',
  ),
  FeaturedCarouselModel(
    id: 12,
    title: 'American Fiction',
    tag: 'COMEDY DRAMA',
  ),
];

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
                ),
                child: Stack(
                  children: [
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
                              color: ColorName.accent,
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
                color: active ? ColorName.accent : Colors.white24,
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
        color: filled ? Colors.white : Colors.white.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(8),
        border: filled ? null : Border.all(color: Colors.white.withValues(alpha: .3)),
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