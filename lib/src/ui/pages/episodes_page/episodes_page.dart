import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_bloc.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_event.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_state.dart';

// ─────────────────────────────────────────
//  EPISODES PAGE
// ─────────────────────────────────────────
class EpisodesPage extends StatefulWidget {
  const EpisodesPage({super.key});

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final movieId = (args?['movieId'] as String?) ?? '';
      if (movieId.isNotEmpty) {
        context.read<EpisodesBloc>().add(EpisodesFetchEvent(movieId: movieId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.backgroundPrimary,
      body: BlocBuilder<EpisodesBloc, EpisodesState>(
        buildWhen: (_, state) => state is EpisodesFetchState,
        builder: (context, state) {
          // ── Loading ────────────────────────────
          if (state is EpisodesFetchState && state.state == BaseState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorName.accent),
            );
          }

          // ── Error ──────────────────────────────
          if (state is EpisodesFetchState && state.state == BaseState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: ColorName.contentSecondary,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load episodes',
                    style: TextStyle(
                      color: ColorName.contentSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return const _EpisodesContent();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
//  CONTENT
// ─────────────────────────────────────────
class _EpisodesContent extends StatelessWidget {
  const _EpisodesContent();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EpisodesBloc>();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Top bar (back + title) ──────────────
        SliverAppBar(
          backgroundColor: ColorName.backgroundPrimary,
          elevation: 0,
          pinned: true,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorName.backgroundSecondary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorName.surfaceSecondary),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          title: const Text(
            'Episodes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // ── Movie info ──────────────────────────
        SliverToBoxAdapter(child: _buildMovieInfo(bloc)),

        // ── Season selector + Episodes label ───
        SliverToBoxAdapter(child: _buildEpisodesHeader(context, bloc)),

        // ── Episode list ────────────────────────
        BlocBuilder<EpisodesBloc, EpisodesState>(
          buildWhen: (_, state) =>
              state is EpisodesSelectSeasonState || state is EpisodesFetchState,
          builder: (context, state) {
            final filtered = bloc.filteredEpisodes;

            if (filtered.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No episodes for this season',
                      style: TextStyle(
                        color: ColorName.contentSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _EpisodeItem(episode: filtered[index], movieId: bloc.movie?.id ?? "",),
                childCount: filtered.length,
              ),
            );
          },
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  MOVIE INFO
  // ─────────────────────────────────────────
  Widget _buildMovieInfo(EpisodesBloc bloc) {
    final movie = bloc.movie;
    if (movie == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail placeholder ─────────────
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorName.surfaceSecondary),
            ),
            child: Center(
              child: Icon(
                Icons.movie_creation_outlined,
                color: ColorName.accent.withValues(alpha: .5),
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Category chip ─────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ColorName.accent.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: ColorName.accent.withValues(alpha: .4)),
            ),
            child: Text(
              movie.category?.name ?? "",
              style: TextStyle(
                color: ColorName.accent,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Title ─────────────────────────────
          Text(
            movie.title ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // ── Meta row ──────────────────────────
          Row(
            children: [
              Icon(Icons.star_rounded, color: ColorName.accent, size: 14),
              const SizedBox(width: 4),
              Text(
                movie.rating?.toStringAsFixed(1) ?? "",
                style: TextStyle(
                  color: ColorName.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.calendar_today_outlined,
                color: ColorName.contentSecondary,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                '${movie.releaseYear}',
                style: TextStyle(
                  color: ColorName.contentSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ColorName.backgroundSecondary,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: ColorName.surfaceSecondary),
                ),
                child: Text(
                  movie.ageLimit ?? "",
                  style: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Description ───────────────────────
          Text(
            movie.description ?? "",
            style: TextStyle(
              color: ColorName.contentSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  EPISODES HEADER + SEASON SELECTOR
  // ─────────────────────────────────────────
  Widget _buildEpisodesHeader(BuildContext context, EpisodesBloc bloc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          Container(height: 1, color: ColorName.surfaceSecondary),
          const SizedBox(height: 16),

          // Label + season pills
          Row(
            children: [
              // Red bar + label
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: ColorName.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Episodes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              // Season pills
              BlocBuilder<EpisodesBloc, EpisodesState>(
                buildWhen: (_, state) =>
                    state is EpisodesSelectSeasonState ||
                    state is EpisodesFetchState,
                builder: (context, state) {
                  final seasons = bloc.seasons;
                  final selected = bloc.selectedSeason;

                  return Row(
                    children: seasons.map((s) {
                      final isActive = s == selected;
                      return GestureDetector(
                        onTap: () =>
                            bloc.add(EpisodesSelectSeasonEvent(season: s ?? 0)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? ColorName.accent
                                : ColorName.backgroundSecondary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive
                                  ? ColorName.accent
                                  : ColorName.surfaceSecondary,
                            ),
                          ),
                          child: Text(
                            'S$s',
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : ColorName.contentSecondary,
                              fontSize: 12,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  EPISODE ITEM
// ─────────────────────────────────────────
class _EpisodeItem extends StatelessWidget {
  final EpisodeModel episode;
  final String movieId;
  const _EpisodeItem({required this.episode, required this.movieId});

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          generateRoutes(RouteSettings(name: Navigation.playPage, arguments: {"movieId": movieId}))!,
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      color: Colors.white38,
                      size: 32,
                    ),
                    // Watched badge
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
                      // Episode number
                      Text(
                        'Episode ${episode.episodeNumber}',
                        style: TextStyle(
                          color: ColorName.contentSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Title
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
                      // Duration
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
      ),
    );
  }
}
