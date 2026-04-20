import 'package:flutter/material.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/services/navigation.dart';

class EpisodeBottomInfo extends StatelessWidget {
  final EpisodeDetailsModel episode;
  final VoidCallback? onMoviePressed;
  const EpisodeBottomInfo({
    super.key,
    required this.episode,
    this.onMoviePressed,
  });

  void _openMovie(BuildContext context) {
    final movieId = episode.movieId;
    if (movieId == null || movieId.isEmpty) return;
    onMoviePressed?.call();
    Navigator.of(context).pushNamed(
      Navigation.episodesPage,
      arguments: {'movieId': movieId},
    );
  }

  String _formatDate(AppLocalizations l, String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 1) return l.justNow;
      if (diff.inMinutes < 60) return l.minutesAgoShort(diff.inMinutes);
      if (diff.inHours < 24) return l.hoursAgoShort(diff.inHours);
      if (diff.inDays < 7) return l.daysAgoShort(diff.inDays);
      return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasMovieHeader = (episode.movieTitle != null &&
            episode.movieTitle!.isNotEmpty) ||
        (episode.movieImageUrl != null && episode.movieImageUrl!.isNotEmpty) ||
        (episode.movieCategoryName != null &&
            episode.movieCategoryName!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          episode.title ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.4,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.video_library_outlined,
                color: Colors.white54, size: 13),
            const SizedBox(width: 5),
            Text(
              l.seasonEpisodeLabel(
                episode.season ?? 0,
                episode.episodeNumber ?? 0,
              ),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (episode.createdAt != null) ...[
              const SizedBox(width: 8),
              Text(
                '·  ${_formatDate(l, episode.createdAt!)}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        if (episode.description != null &&
            episode.description!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            episode.description!,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (hasMovieHeader) ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _openMovie(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 36,
                    height: 48,
                    color: Colors.white12,
                    child: (episode.movieImageUrl != null &&
                            episode.movieImageUrl!.isNotEmpty)
                        ? Image.network(
                            episode.movieImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.movie_outlined,
                              color: Colors.white38,
                              size: 18,
                            ),
                          )
                        : const Icon(
                            Icons.movie_outlined,
                            color: Colors.white38,
                            size: 18,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (episode.movieTitle != null &&
                        episode.movieTitle!.isNotEmpty)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _openMovie(context),
                        child: Text(
                          episode.movieTitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    if (episode.movieCategoryName != null &&
                        episode.movieCategoryName!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white24,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          episode.movieCategoryName!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
