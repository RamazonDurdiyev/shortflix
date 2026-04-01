import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/ui/pages/play_page/play_bloc.dart';
import 'package:shortflix/src/ui/pages/play_page/play_event.dart';
import 'package:shortflix/src/ui/pages/play_page/play_state.dart';
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
  late String _episodeId;
  late String _movieId;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      _episodeId = (args?['episodeId'] as String?) ?? '';
      _movieId = (args?['movieId'] as String?) ?? '';
      if (_movieId.isNotEmpty) {
        context.read<PlayBloc>().add(FetchEpisodeEvent(movieId: _movieId, episodeId: _episodeId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<PlayBloc, PlayState>(
        builder: (context, state) {
          if (state is FetchEpisodeState &&
              state.state == BaseState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorName.accent),
            );
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            onPageChanged: (index) =>
                context.read<PlayBloc>().add(PlayPageChangedEvent(index: index)),
            itemBuilder: (context, index) => const _PlayCard(),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
//  PLAY CARD
// ─────────────────────────────────────────
class _PlayCard extends StatefulWidget {
  const _PlayCard();

  @override
  State<_PlayCard> createState() => _PlayCardState();
}

class _PlayCardState extends State<_PlayCard> {
  VideoPlayerController? _videoController;
  bool _controllerReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final episode = context.read<PlayBloc>().episode;
    if (episode != null && !_controllerReady) {
      _initVideo(episode.videoUrl ?? "");
    }
  }

  Future<void> _initVideo(String url) async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    _videoController!.play();
    if (mounted) setState(() => _controllerReady = true);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayBloc, PlayState>(
      listenWhen: (_, state) => state is PlayToggleState,
      listener: (context, state) {
        if (state is PlayToggleState) {
          if (state.isPlaying) {
            _videoController?.play();
          } else {
            _videoController?.pause();
          }
        }
      },
      child: SizedBox.expand(
        child: Stack(
          children: [
            // ── Video / black bg ──────────────────
            _controllerReady && _videoController != null
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
                : const ColoredBox(color: Colors.black, child: SizedBox.expand()),

            // ── Top bar ───────────────────────────
            const _TopBar(),

            // ── Center play/pause ─────────────────
            _CenterPlayPause(controller: _videoController),

            // ── Right actions ─────────────────────
            const Positioned(
              right: 12,
              bottom: 120,
              child: _ActionColumn(),
            ),

            // ── Bottom info ───────────────────────
            const Positioned(
              left: 16,
              right: 80,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: _BottomInfo(),
                ),
              ),
            ),

            // ── Progress bar ──────────────────────
            _controllerReady && _videoController != null
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: VideoProgressIndicator(
                      _videoController!,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: ColorName.accent,
                        bufferedColor: Colors.white24,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                  )
                : const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _ProgressBar(),
                  ),
          ],
        ),
      ),
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
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(
                Icons.cast_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  CENTER PLAY / PAUSE
// ─────────────────────────────────────────
class _CenterPlayPause extends StatelessWidget {
  final VideoPlayerController? controller;
  const _CenterPlayPause({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayBloc, PlayState>(
      buildWhen: (_, state) => state is PlayToggleState || state is FetchEpisodeState,
      builder: (context, state) {
        final isPlaying = context.read<PlayBloc>().isPlaying;

        return GestureDetector(
          onTap: () => context
              .read<PlayBloc>()
              .add(PlayTogglePlayPauseEvent()),
          child: Center(
            child: AnimatedOpacity(
              opacity: isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 1.5),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
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
//  ACTION COLUMN
// ─────────────────────────────────────────
class _ActionColumn extends StatelessWidget {
  const _ActionColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _ActionButton(icon: Icons.favorite_border_rounded, label: '0'),
        const SizedBox(height: 20),
        // Comments — opens bottom sheet
        GestureDetector(
          onTap: () => _showCommentsSheet(context),
          child: const Column(
            children: [
              Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 30),
              SizedBox(height: 4),
              Text(
                '0',
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
        const _ActionButton(icon: Icons.reply_rounded, label: 'Share', flipX: true),
        const SizedBox(height: 20),
        const _ActionButton(icon: Icons.more_horiz_rounded, label: 'More'),
      ],
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _CommentsSheet(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool flipX;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.flipX = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform(
          alignment: Alignment.center,
          transform: flipX
              ? (Matrix4.identity()..scale(-1.0, 1.0))
              : Matrix4.identity(),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  COMMENTS BOTTOM SHEET
// ─────────────────────────────────────────
class _CommentsSheet extends StatelessWidget {
  const _CommentsSheet();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Header
          Padding(
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
                  '0',
                  style: TextStyle(
                    color: ColorName.accent,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 24),
          // Empty state
          Expanded(
            child: Center(
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
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  BOTTOM INFO
// ─────────────────────────────────────────
class _BottomInfo extends StatelessWidget {
  const _BottomInfo();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayBloc, PlayState>(
      buildWhen: (_, state) => state is FetchEpisodeState,
      builder: (context, state) {
        final episode = context.read<PlayBloc>().episode;
        final isLoading = state is FetchEpisodeState &&
            state.state == BaseState.loading;

        if (isLoading || episode == null) {
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ColorName.accent.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: ColorName.accent.withValues(alpha: .4)),
              ),
              child: Text(
                "CATEGORY NAME",
                style: TextStyle(
                  color: ColorName.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Title
            Text(
              episode.title ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.4,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            // Season · Episode
            Row(
              children: [
                const Icon(Icons.video_library_outlined, color: Colors.white54, size: 13),
                const SizedBox(width: 5),
                Text(
                  'Season ${episode.season}  ·  Episode ${episode.episodeNumber}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              episode.description ?? "",
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
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