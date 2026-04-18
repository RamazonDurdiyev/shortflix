import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_bloc.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_event.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_state.dart';
import 'package:shortflix/src/ui/widgets/global/episodes_grid.dart';

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
      final args = ModalRoute.of(context)?.settings.arguments;
      final movieId = switch (args) {
        String s => s,
        Map m => (m['movieId'] as String?) ?? '',
        _ => '',
      };
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
          actions: [
            BlocBuilder<EpisodesBloc, EpisodesState>(
              buildWhen: (_, state) => state is EpisodesFetchState,
              builder: (context, state) {
                final movie = bloc.movie;
                if (movie?.canEdit != true) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () => _showMoreSheet(context, bloc),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: ColorName.backgroundSecondary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorName.surfaceSecondary),
                    ),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ],
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

            return SliverToBoxAdapter(
              child: EpisodesGrid(
                episodes: filtered,
                movieId: bloc.movie?.id ?? '',
              ),
            );
          },
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  void _showMoreSheet(BuildContext context, EpisodesBloc bloc) {
    final movie = bloc.movie;
    if (movie == null) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: Colors.white),
              title: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.of(context).pushNamed(
                  Navigation.editMoviePage,
                  arguments: movie,
                );
                if (result == true && context.mounted) {
                  bloc.add(EpisodesFetchEvent(movieId: movie.id ?? ''));
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
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
          // ── Thumbnail ───────────────────────
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorName.surfaceSecondary),
            ),
            clipBehavior: Clip.antiAlias,
            child: movie.media != null && movie.media!.isNotEmpty
                ? Image.network(
                    movie.media!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorName.accent,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (_, _, _) => Center(
                      child: Icon(
                        Icons.movie_creation_outlined,
                        color: ColorName.accent.withValues(alpha: .5),
                        size: 48,
                      ),
                    ),
                  )
                : Center(
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
              BlocBuilder<EpisodesBloc, EpisodesState>(
                buildWhen: (_, state) =>
                    state is EpisodesRateMovieState || state is EpisodesFetchState,
                builder: (context, state) {
                  return Row(
                    children: [
                      Icon(Icons.star_rounded, color: ColorName.accent, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        bloc.avgRating.toStringAsFixed(1),
                        style: TextStyle(
                          color: ColorName.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
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
          if ((movie.creator?.fullName ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            _CreatorChip(creator: movie.creator!),
          ],
          const SizedBox(height: 16),

          // ── Save button ──────────────────────
          BlocBuilder<EpisodesBloc, EpisodesState>(
            buildWhen: (_, state) =>
                state is EpisodesSaveMovieState || state is EpisodesFetchState,
            builder: (context, state) {
              final isSaved = bloc.isSaved;
              return GestureDetector(
                onTap: () => bloc.add(
                    EpisodesSaveMovieEvent(movieId: movie.id ?? '')),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSaved
                        ? ColorName.accent.withValues(alpha: .15)
                        : ColorName.backgroundSecondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSaved
                          ? ColorName.accent.withValues(alpha: .4)
                          : ColorName.surfaceSecondary,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: isSaved ? ColorName.accent : Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isSaved ? 'Saved' : 'Save',
                        style: TextStyle(
                          color: isSaved ? ColorName.accent : Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // ── Rate movie ──────────────────────
          BlocBuilder<EpisodesBloc, EpisodesState>(
            buildWhen: (_, state) =>
                state is EpisodesRateMovieState || state is EpisodesFetchState,
            builder: (context, state) {
              final userRating = bloc.userRating;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userRating > 0 ? 'Your rating' : 'Rate this movie',
                    style: TextStyle(
                      color: ColorName.contentSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return GestureDetector(
                        onTap: () => bloc.add(EpisodesRateMovieEvent(
                          movieId: movie.id ?? '',
                          rating: starIndex,
                        )),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            starIndex <= userRating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: starIndex <= userRating
                                ? ColorName.accent
                                : ColorName.contentSecondary,
                            size: 32,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
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
//  CREATOR CHIP (clickable)
// ─────────────────────────────────────────
class _CreatorChip extends StatelessWidget {
  const _CreatorChip({required this.creator});

  final CreatorModel creator;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleTap(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_outline_rounded,
                color: ColorName.contentSecondary,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                'Creator: ',
                style: TextStyle(
                  color: ColorName.contentSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                creator.fullName ?? '',
                style: TextStyle(
                  color: ColorName.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: ColorName.accent.withValues(alpha: .6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    final userId = creator.id;
    if (userId == null || userId.isEmpty) return;
    Navigator.of(context).pushNamed(
      Navigation.myMoviesPage,
      arguments: {
        'userId': userId,
        'displayName': creator.fullName,
      },
    );
  }
}

