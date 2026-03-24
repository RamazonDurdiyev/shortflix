import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/ui/pages/play_page/play_bloc.dart';
import 'package:shortflix/src/ui/pages/play_page/play_event.dart';
import 'package:shortflix/src/ui/pages/play_page/play_state.dart';

// ─────────────────────────────────────────
//  PLAY PAGE
// ─────────────────────────────────────────
class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => PlayBloc(), child: const _PlayView());
  }
}

// ─────────────────────────────────────────
//  PLAY VIEW
// ─────────────────────────────────────────
class _PlayView extends StatelessWidget {
  const _PlayView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<PlayBloc, PlayState>(
        builder: (context, state) {
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            onPageChanged: (index) => context.read<PlayBloc>().add(
              PlayPageChangedEvent(index: index),
            ),
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
class _PlayCard extends StatelessWidget {
  const _PlayCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayBloc, PlayState>(
      builder: (context, state) {

        return SizedBox.expand(
          child: Stack(
            children: [
              const ColoredBox(color: Colors.black, child: SizedBox.expand()),
              const _TopBar(),
              const _CenterPlayIcon(),
              const Positioned(right: 12, bottom: 120, child: _ActionColumn()),
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
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _ProgressBar(),
              ),
            ],
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
//  CENTER PLAY ICON
// ─────────────────────────────────────────
class _CenterPlayIcon extends StatelessWidget {
  const _CenterPlayIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .08),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1.5),
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
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
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionButton(icon: Icons.favorite_border_rounded, label: '0'),
        SizedBox(height: 20),
        _ActionButton(icon: Icons.chat_bubble_outline_rounded, label: '0'),
        SizedBox(height: 20),
        _ActionButton(icon: Icons.reply_rounded, label: 'Share', flipX: true),
        SizedBox(height: 20),
        _ActionButton(icon: Icons.more_horiz_rounded, label: 'More'),
      ],
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
//  BOTTOM INFO
// ─────────────────────────────────────────
class _BottomInfo extends StatelessWidget {
  const _BottomInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: ColorName.accent.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: ColorName.accent.withValues(alpha: .4)),
          ),
          child: Text(
            'Category',
            style: TextStyle(
              color: ColorName.accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Title',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.4,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        const Row(
          children: [
            Icon(Icons.video_library_outlined, color: Colors.white54, size: 13),
            SizedBox(width: 5),
            Text(
              'Season 1  ·  Episode 1',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Description',
          style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 14),
       
      ],
    );
  }
}

// ─────────────────────────────────────────
//  PROGRESS BAR
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
