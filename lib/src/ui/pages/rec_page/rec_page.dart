import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/models/comment_model/comment_model.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/ui/widgets/global/episode_bottom_info.dart';
import 'package:shortflix/src/ui/pages/home_page/home_bloc.dart';
import 'package:shortflix/src/ui/pages/home_page/home_state.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_bloc.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_event.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

// ─────────────────────────────────────────
//  REC PAGE (Shorts)
// ─────────────────────────────────────────
class RecPage extends StatefulWidget {
  const RecPage({super.key});

  @override
  State<RecPage> createState() => _RecPageState();
}

class _RecPageState extends State<RecPage> {
  bool _fetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      _fetched = true;
      context.read<RecBloc>().add(FetchShortsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<RecBloc, RecState>(
        buildWhen: (_, state) => state is FetchShortsState,
        builder: (context, state) {
          if (state is FetchShortsState && state.state == BaseState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorName.accent),
            );
          }

          if (state is FetchShortsState && state.state == BaseState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded,
                      color: ColorName.contentSecondary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    l.failedToLoadShorts,
                    style: TextStyle(
                        color: ColorName.contentSecondary, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          final shorts = context.read<RecBloc>().shorts;
          if (shorts.isEmpty) {
            return Center(
              child: Text(
                l.noShortsAvailable,
                style: TextStyle(
                    color: ColorName.contentSecondary, fontSize: 14),
              ),
            );
          }

          return const _ShortsPageView();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SHORTS PAGE VIEW (vertical swipe)
// ─────────────────────────────────────────
class _ShortsPageView extends StatefulWidget {
  const _ShortsPageView();

  @override
  State<_ShortsPageView> createState() => _ShortsPageViewState();
}

class _ShortsPageViewState extends State<_ShortsPageView> {
  late PageController _pageController;
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentPage = 0;
  bool _showPlayIcon = false;
  bool _showHeart = false;
  Offset? _heartPosition;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _initVideoAt(int index) async {
    if (_controllers.containsKey(index)) return;
    final shorts = context.read<RecBloc>().shorts;
    if (index >= shorts.length) return;
    final url = shorts[index].videoUrl;
    if (url == null || url.isEmpty) return;

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controllers[index] = controller;
    await controller.initialize();
    controller.setLooping(true);
    if (index == _currentPage) {
      final bloc = context.read<RecBloc>();
      final homeBloc = context.read<HomeBloc>();
      if (homeBloc.currentNavBarIndex == 1 && bloc.isPlaying) {
        controller.setVolume(bloc.isMuted ? 0.0 : 1.0);
        controller.play();
      }
    }
    if (mounted) setState(() {});
  }

  void _onPageChanged(int index) {
    // Pause old
    _controllers[_currentPage]?.pause();

    _currentPage = index;
    context.read<RecBloc>().add(RecPageChangedEvent(index: index));

    // Play new
    final controller = _controllers[index];
    if (controller != null && controller.value.isInitialized) {
      final bloc = context.read<RecBloc>();
      controller.setVolume(bloc.isMuted ? 0.0 : 1.0);
      controller.play();
    }

    // Init current if not ready, preload next
    _initVideoAt(index);
    final bloc = context.read<RecBloc>();
    if (index + 1 < bloc.shorts.length) {
      _initVideoAt(index + 1);
    }
  }

  void _togglePlayPause() {
    context.read<RecBloc>().add(RecTogglePlayPauseEvent());
  }

  void _onDoubleTapDown(TapDownDetails details) {
    _heartPosition = details.localPosition;
  }

  void _onDoubleTap(String episodeId) {
    if (episodeId.isEmpty) return;
    final bloc = context.read<RecBloc>();
    // Only fire like if not already liked — double tap never unlikes.
    if (!bloc.isLiked) {
      bloc.add(RecLikeEvent(episodeId: episodeId));
    }
    setState(() => _showHeart = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (_, state) => state is ChangeNavBarIndexState,
          listener: (context, state) {
            final homeBloc = context.read<HomeBloc>();
            final controller = _controllers[_currentPage];
            if (homeBloc.currentNavBarIndex == 1) {
              context.read<RecBloc>().isPlaying = true;
              if (controller != null && controller.value.isInitialized) {
                controller.play();
              } else {
                // Controller not ready yet — kick off init; it will auto-play.
                _initVideoAt(_currentPage);
              }
            } else {
              controller?.pause();
            }
          },
        ),
        BlocListener<RecBloc, RecState>(
          listenWhen: (_, state) => state is FetchShortsState,
          listener: (context, state) {
            if (state is FetchShortsState && state.state == BaseState.loaded) {
              // Init video for current page if not yet initialized
              _initVideoAt(_currentPage);
            }
          },
        ),
        BlocListener<RecBloc, RecState>(
          listenWhen: (_, state) => state is RecToggleState,
          listener: (context, state) {
            if (state is RecToggleState) {
              final controller = _controllers[_currentPage];
              if (controller == null) return;
              if (state.isPlaying) {
                controller.play();
              } else {
                controller.pause();
              }
              setState(() => _showPlayIcon = true);
              Future.delayed(const Duration(milliseconds: 600), () {
                if (mounted) setState(() => _showPlayIcon = false);
              });
            }
          },
        ),
        BlocListener<RecBloc, RecState>(
          listenWhen: (_, state) => state is RecMuteState,
          listener: (context, state) {
            if (state is RecMuteState) {
              _controllers[_currentPage]
                  ?.setVolume(state.isMuted ? 0.0 : 1.0);
            }
          },
        ),
      ],
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: null, // infinite scroll
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return BlocBuilder<RecBloc, RecState>(
            buildWhen: (_, state) => state is FetchShortsState,
            builder: (context, state) {
              final shorts = context.read<RecBloc>().shorts;
              if (index >= shorts.length) {
                return const Center(
                  child: CircularProgressIndicator(color: ColorName.accent),
                );
              }
              final short = shorts[index];
              final controller = _controllers[index];
              final isReady =
                  controller != null && controller.value.isInitialized;

          return GestureDetector(
            onTap: _togglePlayPause,
            onDoubleTapDown: _onDoubleTapDown,
            onDoubleTap: () => _onDoubleTap(short.id ?? ''),
            child: SizedBox.expand(
              child: Stack(
                children: [
                  // ── Video ──────────────────────
                  isReady
                      ? SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),
                        )
                      : const ColoredBox(
                          color: Colors.black, child: SizedBox.expand()),

                  // ── Double-tap heart animation ─
                  _buildDoubleTapHeart(),

                  // ── Top bar ────────────────────
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context).shorts,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  // ── Center play/pause icon ────
                  _buildCenterIcon(),

                  // ── Right actions ──────────────
                  Positioned(
                    right: 12,
                    bottom: 120,
                    child: _ActionColumn(short: short),
                  ),

                  // ── Bottom info ────────────────
                  Positioned(
                    left: 16,
                    right: 80,
                    bottom: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: EpisodeBottomInfo(
                          episode: short,
                          onMoviePressed: () {
                            final bloc = context.read<RecBloc>();
                            if (bloc.isPlaying) {
                              bloc.add(RecTogglePlayPauseEvent());
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  // ── Mute button ─────────────────
                  Positioned(
                    right: 16,
                    bottom: 28,
                    child: SafeArea(
                      child: BlocBuilder<RecBloc, RecState>(
                        buildWhen: (_, state) => state is RecMuteState,
                        builder: (context, state) {
                          final isMuted = context.read<RecBloc>().isMuted;
                          return GestureDetector(
                            onTap: () => context.read<RecBloc>().add(RecToggleMuteEvent()),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ── Progress bar ───────────────
                  if (isReady)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: ColorName.accent,
                          bufferedColor: Colors.white24,
                          backgroundColor: Colors.white12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
            },
          );
        },
      ),
    );
  }

  Widget _buildDoubleTapHeart() {
    if (_heartPosition == null) return const SizedBox.shrink();
    return Positioned(
      left: _heartPosition!.dx - 60,
      top: _heartPosition!.dy - 60,
      child: IgnorePointer(
        child: AnimatedScale(
          scale: _showHeart ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.elasticOut,
          child: AnimatedOpacity(
            opacity: _showHeart ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: Icon(
              Icons.favorite_rounded,
              color: ColorName.accent,
              size: 120,
              shadows: const [
                Shadow(color: Colors.black54, blurRadius: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterIcon() {
    return BlocBuilder<RecBloc, RecState>(
      buildWhen: (_, state) =>
          state is RecToggleState || state is RecPageChangedState,
      builder: (context, state) {
        final isPlaying = context.read<RecBloc>().isPlaying;

        return Center(
          child: AnimatedOpacity(
            opacity: _showPlayIcon || !isPlaying ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .5),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
//  ACTION COLUMN
// ─────────────────────────────────────────
class _ActionColumn extends StatelessWidget {
  final EpisodeDetailsModel short;
  const _ActionColumn({required this.short});

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RecBloc>();
    final episodeId = short.id ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Like ─────────────────────────────
        BlocBuilder<RecBloc, RecState>(
          buildWhen: (_, state) =>
              state is RecLikeState || state is RecPageChangedState,
          builder: (context, state) {
            final isLiked = bloc.isLiked;
            return GestureDetector(
              onTap: () => bloc.add(RecLikeEvent(episodeId: episodeId)),
              child: Column(
                children: [
                  Icon(
                    isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isLiked ? ColorName.accent : Colors.white,
                    size: 30,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bloc.likeCount > 0 ? _formatCount(bloc.likeCount) : '0',
                    style: TextStyle(
                      color: isLiked ? ColorName.accent : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        // ── Comments ─────────────────────────
        BlocBuilder<RecBloc, RecState>(
          buildWhen: (_, state) =>
              state is RecFetchCommentsState || state is RecPageChangedState,
          builder: (context, state) {
            final count = bloc.comments.isNotEmpty
                ? bloc.comments.length
                : bloc.currentShort?.commentCount ?? 0;
            return GestureDetector(
              onTap: () => _showCommentsSheet(context),
              child: Column(
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded,
                      color: Colors.white, size: 30),
                  const SizedBox(height: 4),
                  Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        // ── Share ────────────────────────────
        GestureDetector(
          onTap: () {
            final text = '${short.title ?? ''}\n${short.description ?? ''}\n${short.videoUrl ?? ''}';
            SharePlus.instance.share(ShareParams(text: text));
          },
          child: Column(
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                child: const Icon(Icons.reply_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context).share,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // ── More ──────────────────────────────
        GestureDetector(
          onTap: () => _showMoreSheet(context),
          child: Column(
            children: [
              const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 30),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context).more,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMoreSheet(BuildContext context) {
    final bloc = context.read<RecBloc>();
    final episodeId = short.id ?? '';
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: Padding(
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
              BlocBuilder<RecBloc, RecState>(
                buildWhen: (_, state) => state is RecSaveState,
                builder: (context, state) {
                  final l = AppLocalizations.of(context);
                  final isSaved = context.read<RecBloc>().isSaved;
                  return ListTile(
                    leading: Icon(
                      isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isSaved ? ColorName.accent : Colors.white,
                    ),
                    title: Text(
                      isSaved ? l.saved : l.save,
                      style: TextStyle(
                        color: isSaved ? ColorName.accent : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      bloc.add(RecSaveEvent(episodeId: episodeId));
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    final bloc = context.read<RecBloc>();
    bloc.add(RecFetchCommentsEvent());
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const _CommentsSheet(),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  COMMENTS BOTTOM SHEET
// ─────────────────────────────────────────
class _CommentsSheet extends StatefulWidget {
  const _CommentsSheet();

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(AppLocalizations l, String isoString) {
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

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<RecBloc>().add(RecAddCommentEvent(comment: text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RecBloc>();
    final l = AppLocalizations.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<RecBloc, RecState>(
            buildWhen: (_, state) => state is RecFetchCommentsState,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      l.comments,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${bloc.comments.length}',
                      style: TextStyle(color: ColorName.accent, fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(color: Colors.white12, height: 24),
          Expanded(
            child: BlocBuilder<RecBloc, RecState>(
              buildWhen: (_, state) =>
                  state is RecFetchCommentsState || state is RecAddCommentState,
              builder: (context, state) {
                final isLoading = state is RecFetchCommentsState &&
                    state.state == BaseState.loading;
                final comments = bloc.comments;

                if (isLoading && comments.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: ColorName.accent),
                  );
                }

                if (comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            color: Colors.white24, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          l.noCommentsYet,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l.beFirstToComment,
                          style: const TextStyle(
                              color: Colors.white24, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: comments.length,
                  separatorBuilder: (_, _) =>
                      const Divider(color: Colors.white12, height: 24),
                  itemBuilder: (_, i) {
                    final c = comments[i];
                    return _buildCommentItem(l, c);
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: l.addAComment,
                      hintStyle: const TextStyle(
                          color: Colors.white38, fontSize: 14),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _submitComment(),
                  ),
                ),
                BlocBuilder<RecBloc, RecState>(
                  buildWhen: (_, state) => state is RecAddCommentState,
                  builder: (context, state) {
                    final isSending = state is RecAddCommentState &&
                        state.state == BaseState.loading;
                    return IconButton(
                      onPressed: isSending ? null : _submitComment,
                      icon: isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorName.accent,
                              ),
                            )
                          : Icon(Icons.send_rounded, color: ColorName.accent),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(AppLocalizations l, CommentModel c) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white12,
          child: Icon(Icons.person_rounded, color: Colors.white54, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    c.userName ?? l.user,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (c.createdTime != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(l, c.createdTime!),
                      style: const TextStyle(
                        color: Colors.white30,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                c.comment ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  BOTTOM INFO
// ─────────────────────────────────────────
