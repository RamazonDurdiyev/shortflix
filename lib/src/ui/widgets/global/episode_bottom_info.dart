import 'package:flutter/material.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';

class EpisodeBottomInfo extends StatelessWidget {
  final EpisodeDetailsModel episode;
  const EpisodeBottomInfo({super.key, required this.episode});

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Season ${episode.season}  ·  Episode ${episode.episodeNumber}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (episode.createdAt != null) ...[
              const SizedBox(width: 8),
              Text(
                '·  ${_formatDate(episode.createdAt!)}',
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
      ],
    );
  }
}
