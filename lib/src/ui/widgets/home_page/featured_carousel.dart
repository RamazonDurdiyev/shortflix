import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/banner_model/banner_model.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';

class FeaturedCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  const FeaturedCarousel({super.key, required this.banners});

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
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final item = widget.banners[index];
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: ColorName.accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.category.name,
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    generateRoutes(
                                      RouteSettings(name: Navigation.playPage),
                                    )!,
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              _CarouselButton(
                                icon: Icons.add_rounded,
                                label: 'Watchlist',
                                filled: false,
                                onTap: () {},
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
          children: List.generate(widget.banners.length, (i) {
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
  final Function()? onTap;
  const _CarouselButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: filled ? Colors.white : Colors.white.withValues(alpha: .15),
          borderRadius: BorderRadius.circular(8),
          border: filled
              ? null
              : Border.all(color: Colors.white.withValues(alpha: .3)),
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
      ),
    );
  }
}
