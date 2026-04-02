import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_bloc.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_event.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_state.dart';

class PostEpisodePage extends StatelessWidget {
  const PostEpisodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PostEpisodeView();
  }
}

class _PostEpisodeView extends StatefulWidget {
  const _PostEpisodeView();

  @override
  State<_PostEpisodeView> createState() => _PostEpisodeViewState();
}

class _PostEpisodeViewState extends State<_PostEpisodeView> {
  final _titleUzCtrl = TextEditingController();
  final _titleRuCtrl = TextEditingController();
  final _titleEnCtrl = TextEditingController();
  final _descUzCtrl = TextEditingController();
  final _descRuCtrl = TextEditingController();
  final _descEnCtrl = TextEditingController();
  final _seasonCtrl = TextEditingController();
  final _episodeCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<PostEpisodeBloc>().add(FetchUserMoviesEvent());
  }

  @override
  void dispose() {
    _titleUzCtrl.dispose();
    _titleRuCtrl.dispose();
    _titleEnCtrl.dispose();
    _descUzCtrl.dispose();
    _descRuCtrl.dispose();
    _descEnCtrl.dispose();
    _seasonCtrl.dispose();
    _episodeCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  void _showLoadingDialog(BuildContext context) {
    if (_isDialogOpen) return;
    _isDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: ColorName.accent),
            ),
          ),
        ),
      ),
    );
  }

  void _dismissLoadingDialog(BuildContext context) {
    if (!_isDialogOpen) return;
    _isDialogOpen = false;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PostEpisodeBloc>();

    return BlocListener<PostEpisodeBloc, PostEpisodeState>(
      listener: (context, state) {
        // ── Fetch user movies ─────────────────
        if (state is FetchUserMoviesState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
          } else if (state.state == BaseState.error) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load movies')),
            );
          }
        }

        // ── Pick video ────────────────────────
        if (state is PickVideoState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else {
            _dismissLoadingDialog(context);
            if (state.state == BaseState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to pick video')),
              );
            }
          }
        }

        // ── Pick image ────────────────────────
        if (state is PickImageState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else {
            _dismissLoadingDialog(context);
            if (state.state == BaseState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to pick image')),
              );
            }
          }
        }

        // ── Create episode ────────────────────
        if (state is CreateEpisodeState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Episode posted successfully')),
            );
            Navigator.of(context).pop();
          } else if (state.state == BaseState.error) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something went wrong')),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorName.backgroundPrimary,
        appBar: AppBar(
          title: const Text(
            'Post Episode',
            style: TextStyle(
              color: ColorName.contentPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          backgroundColor: ColorName.backgroundPrimary,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorName.contentPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Movie Selector ──────────────────────
              _buildMovieDropdown(bloc),
              const SizedBox(height: 12),

              // ── Season & Episode ────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      _seasonCtrl,
                      'Season',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      _episodeCtrl,
                      'Episode №',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Title (UZ) ────────────────────────────
              _buildTextField(_titleUzCtrl, 'Title (UZ)'),
              const SizedBox(height: 12),

              // ── Title (RU) ────────────────────────────
              _buildTextField(_titleRuCtrl, 'Title (RU)'),
              const SizedBox(height: 12),

              // ── Title (EN) ────────────────────────────
              _buildTextField(_titleEnCtrl, 'Title (EN)'),
              const SizedBox(height: 12),

              // ── Description (UZ) ───────────────────────
              _buildTextField(_descUzCtrl, 'Description (UZ)', maxLines: 4),
              const SizedBox(height: 12),

              // ── Description (RU) ───────────────────────
              _buildTextField(_descRuCtrl, 'Description (RU)', maxLines: 4),
              const SizedBox(height: 12),

              // ── Description (EN) ───────────────────────
              _buildTextField(_descEnCtrl, 'Description (EN)', maxLines: 4),
              const SizedBox(height: 12),

              // ── Duration ────────────────────────────
              _buildTextField(
                _durationCtrl,
                'Duration (minutes)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // ── Video ───────────────────────────────
              _buildVideoPicker(bloc),
              const SizedBox(height: 16),

              // ── Image ───────────────────────────────
              _buildImagePicker(bloc),
              const SizedBox(height: 24),

              // ── Submit ──────────────────────────────
              _buildSubmitButton(bloc),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  TEXT FIELD
  // ─────────────────────────────────────────
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      cursorColor: ColorName.accent,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: ColorName.contentSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorName.surfaceSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ColorName.accent),
        ),
        filled: true,
        fillColor: ColorName.backgroundSecondary,
      ),
    );
  }

  // ─────────────────────────────────────────
  //  MOVIE DROPDOWN
  // ─────────────────────────────────────────
  Widget _buildMovieDropdown(PostEpisodeBloc bloc) {
    return BlocBuilder<PostEpisodeBloc, PostEpisodeState>(
      buildWhen: (_, state) =>
          state is FetchUserMoviesState || state is SelectMovieState,
      builder: (context, state) {
        final selectedName = bloc.userMovies
            .where((m) => m.id == bloc.selectedMovieId)
            .firstOrNull
            ?.title;

        return GestureDetector(
          onTap: () => _showMoviesSheet(context, bloc),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: bloc.selectedMovieId.isNotEmpty
                    ? ColorName.accent
                    : ColorName.surfaceSecondary,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.movie_outlined,
                    color: ColorName.contentSecondary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedName ?? 'Select movie',
                    style: TextStyle(
                      color: selectedName != null
                          ? Colors.white
                          : ColorName.contentSecondary,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down,
                    color: ColorName.contentSecondary),
                const SizedBox(width: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoviesSheet(BuildContext context, PostEpisodeBloc bloc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorName.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Movie',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (bloc.userMovies.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No movies found. Create a movie first.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bloc.userMovies.length,
                itemBuilder: (ctx, i) {
                  final movie = bloc.userMovies[i];
                  final isSelected = movie.id == bloc.selectedMovieId;
                  return ListTile(
                    title: Text(
                      movie.title ?? '',
                      style: TextStyle(
                        color: isSelected ? ColorName.accent : Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded,
                            color: ColorName.accent, size: 18)
                        : null,
                    onTap: () {
                      bloc.add(SelectMovieEvent(movieId: movie.id ?? ''));
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  VIDEO PICKER
  // ─────────────────────────────────────────
  Widget _buildVideoPicker(PostEpisodeBloc bloc) {
    return BlocBuilder<PostEpisodeBloc, PostEpisodeState>(
      buildWhen: (_, state) => state is PickVideoState,
      builder: (context, state) {
        final hasVideo = bloc.videoPath != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasVideo)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bloc.videoPath!.split('/').last,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => bloc.add(PickVideoEvent()),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorName.accent,
                side: const BorderSide(color: ColorName.surfaceSecondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.videocam),
              label: Text(hasVideo ? 'Change Video' : 'Pick Video'),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  IMAGE PICKER
  // ─────────────────────────────────────────
  Widget _buildImagePicker(PostEpisodeBloc bloc) {
    return BlocBuilder<PostEpisodeBloc, PostEpisodeState>(
      buildWhen: (_, state) => state is PickImageState,
      builder: (context, state) {
        final hasImage = bloc.imagePath != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(bloc.imagePath!),
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => bloc.add(PickImageEvent()),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorName.accent,
                side: const BorderSide(color: ColorName.surfaceSecondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.image),
              label: Text(hasImage ? 'Change Image' : 'Pick Image'),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  SUBMIT BUTTON
  // ─────────────────────────────────────────
  Widget _buildSubmitButton(PostEpisodeBloc bloc) {
    return ElevatedButton(
      onPressed: () {
        bloc.add(CreateEpisodeEvent(
          season: int.tryParse(_seasonCtrl.text) ?? 0,
          episodeNumber: int.tryParse(_episodeCtrl.text) ?? 0,
          titleUz: _titleUzCtrl.text,
          titleRu: _titleRuCtrl.text,
          titleEn: _titleEnCtrl.text,
          descriptionUz: _descUzCtrl.text,
          descriptionRu: _descRuCtrl.text,
          descriptionEn: _descEnCtrl.text,
          duration: int.tryParse(_durationCtrl.text) ?? 0,
        ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorName.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text('Post Episode',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}
