import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/ui/pages/home_page/home_page.dart';
import 'package:shortflix/src/ui/widgets/global/movie_image_placeholder.dart';

// ─────────────────────────────────────────
//  MOVIES GRID
// ─────────────────────────────────────────
class MoviesGrid extends StatelessWidget {
  const MoviesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: kMovies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 10,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) => _MovieCard(movie: kMovies[index]),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final MovieItem movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image / Thumbnail
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: movie.fallbackColor,
              border: Border.all(color: ColorName.surfaceSecondary, width: 0.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: movie.imageUrl != null
                ? Image.network(
                    movie.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => movieImagePlaceholder(),
                  )
                : movieImagePlaceholder(),
          ),
        ),
        const SizedBox(height: 6),
        // Title
        Text(
          movie.title,
          style: const TextStyle(
            color: ColorName.contentPrimary,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        // Year + Rating row
        Row(
          children: [
            Text(
              movie.year,
              style: const TextStyle(color: ColorName.contentSecondary, fontSize: 10),
            ),
            const Spacer(),
            const Icon(Icons.star_rounded, color: ColorName.accent, size: 11),
            const SizedBox(width: 2),
            Text(
              movie.rating,
              style: const TextStyle(color: ColorName.accent, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}