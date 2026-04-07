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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    generateRoutes(
                      RouteSettings(
                        name: Navigation.episodesPage,
                        arguments: item.id,
                      ),
                    )!,
                  );
                },
                child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: isActive ? 0 : 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Background image
                    if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                      Positioned.fill(
                        child: Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: ColorName.backgroundSecondary,
                          ),
                        ),
                      ),
                    // Gradient overlay for text readability
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: .7),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                          if (item.averageRating != null && item.averageRating! > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  ...List.generate(5, (i) {
                                    final rating = item.averageRating!;
                                    return Icon(
                                      i < rating.floor()
                                          ? Icons.star_rounded
                                          : (i < rating
                                              ? Icons.star_half_rounded
                                              : Icons.star_border_rounded),
                                      color: Colors.amber,
                                      size: 16,
                                    );
                                  }),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.averageRating!.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: .8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
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