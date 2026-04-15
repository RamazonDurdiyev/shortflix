import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/ui/pages/play_page/play_bloc.dart';
import 'package:shortflix/src/ui/widgets/global/episode_bottom_info.dart';
import 'package:shortflix/src/ui/pages/play_page/play_event.dart';
import 'package:shortflix/src/ui/pages/play_page/play_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

// ─────────────────────────────────────────
//  PLAY PAGE
// ─────────────────────────────────────────
class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlayView();
  }
}

// ─────────────────────────────────────────
//  PLAY VIEW
// ─────────────────────────────────────────
class _PlayView extends StatefulWidget {
  const _PlayView();

  @override
  State<_PlayView> createState() => _PlayViewState();
}

class _PlayViewState extends State<_PlayView> {
  bool _initialized = false;
  VideoPlayerController? _videoController;
  bool _controllerReady = false;
  bool _showPlayIcon = false;
  bool _showHeart = false;
  Offset? _heartPosition;
  final Map<int, GlobalKey> _progressKeys = {};
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final episodeNumber = (args?['episodeNumber'] as int?) ?? 0;
      final movieId = (args?['movieId'] as String?) ?? '';
      if (movieId.isNotEmpty) {
        context.read<PlayBloc>().add(
              FetchEpisodeEvent(movieId: movieId, episodeNumber: episodeNumber),
            );
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final bloc = context.read<PlayBloc>();
    bloc.comments = [];
    if (index < bloc.episodes.length) {
      final ep = bloc.episodes[index];
      bloc.episode = [ep];
      bloc.isLiked = ep.isLiked ?? false;
      bloc.isSaved = ep.isSaved ?? false;
      bloc.likeCount = ep.likeCount ?? 0;
      bloc.commentCount = ep.commentCount ?? 0;
      if (ep.videoUrl != null && ep.videoUrl!.isNotEmpty) {
        _initVideo(ep.videoUrl!);
      }
    } else {
      // Swiped onto a not-yet-loaded page — show black until fetch completes.
      _videoController?.dispose();
      _videoController = null;
      _controllerReady = false;
    }
    if (index >= bloc.episodes.length - 1 &&
        (bloc.totalEpisodes == 0 || bloc.episodes.length < bloc.totalEpisodes)) {
      bloc.add(FetchNextEpisodeEvent());
    }
    setState(() {});
  }

  Future<void> _initVideo(String url) async {
    if (url.isEmpty) return;
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    _videoController!.play();
    if (mounted) setState(() => _controllerReady = true);
  }

  void _togglePlayPause() {
    context.read<PlayBloc>().add(PlayTogglePlayPauseEvent());
  }

  void _onDoubleTapDown(TapDownDetails details) {
    _heartPosition = details.localPosition;
  }

  void _onDoubleTap() {
    final bloc = context.read<PlayBloc>();
    final episodeId = bloc.episode?[0].id ?? '';
    if (episodeId.isEmpty) return;
    // Only fire like if not already liked — double tap never unlikes.
    if (!bloc.isLiked) {
      bloc.add(PlayLikeMovieEvent(movieId: episodeId));
    }
    setState(() => _showHeart = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  void _onPlayToggle(bool isPlaying) {
    if (_videoController == null) return;
    if (isPlaying) {
      _videoController!.play();
    } else {
      _videoController!.pause();
    }
    // Show icon briefly then fade out
    setState(() => _showPlayIcon = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showPlayIcon = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MultiBlocListener(
        listeners: [
          BlocListener<PlayBloc, PlayState>(
            listenWhen: (_, state) =>
                state is FetchEpisodeState && state.state == BaseState.loaded,
            listener: (context, state) {
              final bloc = context.read<PlayBloc>();
              final pageIdx = _pageController.hasClients
                  ? (_pageController.page?.round() ?? 0)
                  : 0;
              if (pageIdx < bloc.episodes.length) {
                final ep = bloc.episodes[pageIdx];
                bloc.episode = [ep];
                bloc.isLiked = ep.isLiked ?? false;
                bloc.isSaved = ep.isSaved ?? false;
                bloc.likeCount = ep.likeCount ?? 0;
                bloc.commentCount = ep.commentCount ?? 0;
                if (ep.videoUrl != null && ep.videoUrl!.isNotEmpty) {
                  _initVideo(ep.videoUrl!);
                }
              }
              if (mounted) setState(() {});
            },
          ),
          BlocListener<PlayBloc, PlayState>(
            listenWhen: (_, state) => state is PlayToggleState,
            listener: (context, state) {
              if (state is PlayToggleState) {
                _onPlayToggle(state.isPlaying);
              }
            },
          ),
          BlocListener<PlayBloc, PlayState>(
            listenWhen: (_, state) => state is PlayMuteState,
            listener: (context, state) {
              if (state is PlayMuteState) {
                _videoController?.setVolume(state.isMuted ? 0.0 : 1.0);
              }
            },
          ),
        ],
        child: BlocBuilder<PlayBloc, PlayState>(
          buildWhen: (_, state) => state is FetchEpisodeState,
          builder: (context, state) {
            if (state is FetchEpisodeState &&
                state.state == BaseState.loading) {
              return const Center(
                child: CircularProgressIndicator(color: ColorName.accent),
              );
            }

            if (state is FetchEpisodeState &&
                state.state == BaseState.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: ColorName.contentSecondary, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load episode',
                      style: TextStyle(
                          color: ColorName.contentSecondary, fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            final bloc = context.read<PlayBloc>();
            final pageCount = bloc.totalEpisodes > 0
                ? bloc.totalEpisodes
                : (bloc.episodes.isEmpty ? 1 : bloc.episodes.length);
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: pageCount <= 1
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
              itemCount: pageCount,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final progressKey =
                    _progressKeys.putIfAbsent(index, () => GlobalKey());
                final pageEpisode = index < bloc.episodes.length
                    ? bloc.episodes[index]
                    : null;
                return SizedBox.expand(
                child: Stack(
                  children: [
                    // ── Video / black bg ──────────────────
                    GestureDetector(
                      onTap: _togglePlayPause,
                      onDoubleTapDown: _onDoubleTapDown,
                      onDoubleTap: _onDoubleTap,
                      child: _controllerReady && _videoController != null
                          ? SizedBox.expand(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _videoController!.value.size.width,
                                  height: _videoController!.value.size.height,
                                  child: VideoPlayer(_videoController!),
                                ),
                              ),
                            )
                          : const ColoredBox(
                              color: Colors.black, child: SizedBox.expand()),
                    ),

                    // ── Double-tap heart animation ───────
                    _buildDoubleTapHeart(),

                    // ── Top bar ───────────────────────────
                    const _TopBar(),

                    // ── Center play/pause icon ───────────
                    _buildCenterIcon(),

                    // ── Right actions ─────────────────────
                    Positioned(
                      right: 12,
                      bottom: 120,
                      child: _ActionColumn(pageEpisode: pageEpisode),
                    ),

                    // ── Bottom info ───────────────────────
                    Positioned(
                      left: 16,
                      right: 80,
                      bottom: MediaQuery.of(context).padding.bottom + 24,
                      child: _PlayBottomInfo(
                        pageEpisode: pageEpisode,
                        onMoviePressed: () => _videoController?.pause(),
                      ),
                    ),

                    // ── Mute button ──────────────────────
                    Positioned(
                      right: 16,
                      bottom: 28,
                      child: SafeArea(
                        child: BlocBuilder<PlayBloc, PlayState>(
                          buildWhen: (_, state) => state is PlayMuteState,
                          builder: (context, state) {
                            final isMuted = context.read<PlayBloc>().isMuted;
                            return GestureDetector(
                              onTap: () => context.read<PlayBloc>().add(PlayToggleMuteEvent()),
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

                    // ── Progress bar ──────────────────────
                    _controllerReady && _videoController != null
                        ? Positioned(
                            bottom: MediaQuery.of(context).padding.bottom / 2,
                            left: 0,
                            right: 0,
                            height: 24,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onHorizontalDragStart: (details) {
                                final box = progressKey.currentContext!.findRenderObject() as RenderBox;
                                final local = box.globalToLocal(details.globalPosition);
                                final position = (local.dx / box.size.width).clamp(0.0, 1.0);
                                final duration = _videoController!.value.duration;
                                _videoController!.seekTo(duration * position);
                              },
                              onHorizontalDragUpdate: (details) {
                                final box = progressKey.currentContext!.findRenderObject() as RenderBox;
                                final local = box.globalToLocal(details.globalPosition);
                                final position = (local.dx / box.size.width).clamp(0.0, 1.0);
                                final duration = _videoController!.value.duration;
                                _videoController!.seekTo(duration * position);
                              },
                              onTapDown: (details) {
                                final box = progressKey.currentContext!.findRenderObject() as RenderBox;
                                final local = box.globalToLocal(details.globalPosition);
                                final position = (local.dx / box.size.width).clamp(0.0, 1.0);
                                final duration = _videoController!.value.duration;
                                _videoController!.seekTo(duration * position);
                              },
                              child: SizedBox(
                                key: progressKey,
                                height: 24,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: VideoProgressIndicator(
                                    _videoController!,
                                    allowScrubbing: false,
                                    colors: VideoProgressColors(
                                      playedColor: ColorName.accent,
                                      bufferedColor: Colors.white24,
                                      backgroundColor: Colors.white12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 2,
                            child: _ProgressBar(),
                          ),
                  ],
                ),
              );
              },
            );
          },
        ),
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
    return BlocBuilder<PlayBloc, PlayState>(
      buildWhen: (_, state) =>
          state is PlayToggleState || state is FetchEpisodeState,
      builder: (context, state) {
        final isPlaying = context.read<PlayBloc>().isPlaying;

        return IgnorePointer(
          child: Center(
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
                isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
//  TOP BAR
// ─────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  ACTION COLUMN
// ─────────────────────────────────────────
class _ActionColumn extends StatelessWidget {
  final EpisodeDetailsModel? pageEpisode;
  const _ActionColumn({this.pageEpisode});

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayBloc>();
    final episodeId = pageEpisode?.id ?? bloc.episode?[0].id ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Like ─────────────────────────────
        BlocBuilder<PlayBloc, PlayState>(
          buildWhen: (_, state) => state is PlayLikeState,
          builder: (context, state) {
            final isLiked = bloc.isLiked;
            return GestureDetector(
              onTap: () => bloc.add(PlayLikeMovieEvent(movieId: episodeId)),
              child: Column(
                children: [
                  Icon(
                    isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
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
        BlocBuilder<PlayBloc, PlayState>(
          buildWhen: (_, state) =>
              state is FetchCommentsState || state is FetchEpisodeState,
          builder: (context, state) {
            final count = bloc.comments.isNotEmpty
                ? bloc.comments.length
                : bloc.commentCount;
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
            final episode = pageEpisode ?? bloc.episode?[0];
            if (episode == null) return;
            final text = '${episode.title ?? ''}\n${episode.description ?? ''}\n${episode.videoUrl ?? ''}';
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
              const Text(
                'Share',
                style: TextStyle(
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
          child: const Column(
            children: [
              Icon(Icons.more_horiz_rounded, color: Colors.white, size: 30),
              SizedBox(height: 4),
              Text(
                'More',
                style: TextStyle(
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
    final bloc = context.read<PlayBloc>();
    final episodeId = bloc.episode?[0].id ?? '';
    final canEdit = bloc.episode?[0].canEdit ?? false;
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
              BlocBuilder<PlayBloc, PlayState>(
                buildWhen: (_, state) => state is PlaySaveState,
                builder: (context, state) {
                  final isSaved = context.read<PlayBloc>().isSaved;
                  return ListTile(
                    leading: Icon(
                      isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isSaved ? ColorName.accent : Colors.white,
                    ),
                    title: Text(
                      isSaved ? 'Saved' : 'Save',
                      style: TextStyle(
                        color: isSaved ? ColorName.accent : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      bloc.add(PlaySaveMovieEvent(movieId: episodeId));
                    },
                  );
                },
              ),
              if (canEdit)
                ListTile(
                  leading: const Icon(Icons.edit_rounded, color: Colors.white),
                  title: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    final episode = bloc.episode?[0];
                    if (episode == null) return;
                    Navigator.of(context).pushNamed(
                      Navigation.editEpisodePage,
                      arguments: episode,
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
    final bloc = context.read<PlayBloc>();
    bloc.add(FetchCommentsEvent());
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

  String _formatTime(String isoString) {
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

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<PlayBloc>().add(AddCommentEvent(comment: text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayBloc>();

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
          // ── Header ──────────────────────────
          BlocBuilder<PlayBloc, PlayState>(
            buildWhen: (_, state) => state is FetchCommentsState,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Comments',
                      style: TextStyle(
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
          // ── Comments list ───────────────────
          Expanded(
            child: BlocBuilder<PlayBloc, PlayState>(
              buildWhen: (_, state) =>
                  state is FetchCommentsState || state is AddCommentState,
              builder: (context, state) {
                final isLoading = state is FetchCommentsState &&
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
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white24,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No comments yet',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Be the first to comment',
                          style:
                              TextStyle(color: Colors.white24, fontSize: 12),
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
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white12,
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white54,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    c.userName ?? 'User',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (c.createdTime != null) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatTime(c.createdTime!),
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
                  },
                );
              },
            ),
          ),
          // ── Input ───────────────────────────
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
                      hintText: 'Add a comment...',
                      hintStyle:
                          TextStyle(color: Colors.white38, fontSize: 14),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _submitComment(),
                  ),
                ),
                BlocBuilder<PlayBloc, PlayState>(
                  buildWhen: (_, state) => state is AddCommentState,
                  builder: (context, state) {
                    final isSending = state is AddCommentState &&
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
}

// ─────────────────────────────────────────
//  BOTTOM INFO
// ─────────────────────────────────────────
class _PlayBottomInfo extends StatelessWidget {
  final EpisodeDetailsModel? pageEpisode;
  final VoidCallback? onMoviePressed;
  const _PlayBottomInfo({this.pageEpisode, this.onMoviePressed});

  @override
  Widget build(BuildContext context) {
    final ep = pageEpisode;
    if (ep == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 160,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      );
    }
    return EpisodeBottomInfo(
      key: ValueKey('bottom-${ep.id}'),
      episode: ep,
      onMoviePressed: onMoviePressed,
    );
  }
}

// ─────────────────────────────────────────
//  PROGRESS BAR (fallback)
// ─────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: 0,
      minHeight: 2,
      backgroundColor: Colors.white12,
      valueColor: AlwaysStoppedAnimation<Color>(ColorName.accent),
    );
  }
}
