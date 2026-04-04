import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/src/ui/widgets/global/movie_image_placeholder.dart';

// ─────────────────────────────────────────
//  MOVIES GRID
// ─────────────────────────────────────────
class MoviesGrid extends StatelessWidget {
  final List<MovieModel> movies;
  const MoviesGrid({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 10,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) => _MovieCard(movie: movies[index]),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final MovieModel movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
              context,
              generateRoutes(
                RouteSettings(
                  name: Navigation.episodesPage,
                  arguments: {"movieId": movie.id}
                ),
              )!,
            );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / Thumbnail
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorName.surfaceSecondary, width: 0.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: movie.media != null && movie.media!.isNotEmpty
                  ? Image.network(
                      movie.media!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorName.accent,
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (_, _, _) => movieImagePlaceholder(),
                    )
                  : movieImagePlaceholder(),
            ),
          ),
          const SizedBox(height: 6),
          // Title
          Text(
            movie.title ?? "",
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
                movie.releaseYear.toString(),
                style: const TextStyle(color: ColorName.contentSecondary, fontSize: 10),
              ),
              const Spacer(),
              const Icon(Icons.star_rounded, color: ColorName.accent, size: 11),
              const SizedBox(width: 2),
              Text(
                movie.rating.toString(),
                style: const TextStyle(color: ColorName.accent, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}