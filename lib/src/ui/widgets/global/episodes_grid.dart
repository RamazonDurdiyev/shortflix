import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';

// ─────────────────────────────────────────
//  EPISODES GRID (reusable)
// ─────────────────────────────────────────
class EpisodesGrid extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final String? movieId;
  const EpisodesGrid({super.key, required this.episodes, this.movieId});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: episodes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => EpisodeCard(
        episode: episodes[index],
        movieId: movieId,
      ),
    );
  }
}

class EpisodeCard extends StatelessWidget {
  final EpisodeModel episode;
  final String? movieId;
  const EpisodeCard({super.key, required this.episode, this.movieId});

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final resolvedMovieId = movieId ?? episode.movieId ?? '';
    return GestureDetector(
      onTap: () {
        if (resolvedMovieId.isEmpty) return;
        Navigator.push(
          context,
          generateRoutes(RouteSettings(
            name: Navigation.playPage,
            arguments: {
              "movieId": resolvedMovieId,
              "episodeNumber": episode.episodeNumber,
            },
          ))!,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorName.backgroundSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: (episode.watched ?? false)
                ? ColorName.accent.withValues(alpha: .3)
                : ColorName.surfaceSecondary,
          ),
        ),
        child: Row(
          children: [
            // ── Thumbnail ──────────────────────
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: ColorName.surfaceSecondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (episode.imageUrl != null && episode.imageUrl!.isNotEmpty)
                    Image.network(
                      episode.imageUrl!,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.play_circle_outline_rounded,
                        color: Colors.white38,
                        size: 32,
                      ),
                    )
                  else
                    Icon(
                      Icons.play_circle_outline_rounded,
                      color: Colors.white38,
                      size: 32,
                    ),
                  if (episode.watched ?? false)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorName.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '✓',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info ───────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Episode ${episode.episodeNumber}',
                      style: TextStyle(
                        color: ColorName.contentSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      episode.title ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: ColorName.contentSecondary,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(episode.duration ?? 0),
                          style: TextStyle(
                            color: ColorName.contentSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Play arrow ─────────────────────
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.play_arrow_rounded,
                color: (episode.watched ?? false)
                    ? ColorName.accent
                    : ColorName.contentSecondary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
