import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/ui/pages/edit_episode_page/edit_episode_bloc.dart';
import 'package:shortflix/src/ui/pages/edit_episode_page/edit_episode_event.dart';
import 'package:shortflix/src/ui/pages/edit_episode_page/edit_episode_state.dart';

class EditEpisodePage extends StatelessWidget {
  final EpisodeDetailsModel episode;
  const EditEpisodePage({super.key, required this.episode});

  @override
  Widget build(BuildContext context) => _EditEpisodeView(episode: episode);
}

class _EditEpisodeView extends StatefulWidget {
  final EpisodeDetailsModel episode;
  const _EditEpisodeView({required this.episode});

  @override
  State<_EditEpisodeView> createState() => _EditEpisodeViewState();
}

class _EditEpisodeViewState extends State<_EditEpisodeView> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _seasonCtrl;
  late final TextEditingController _episodeCtrl;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    final e = widget.episode;
    _titleCtrl = TextEditingController(text: e.title ?? '');
    _descCtrl = TextEditingController(text: e.description ?? '');
    _seasonCtrl = TextEditingController(text: (e.season ?? 1).toString());
    _episodeCtrl =
        TextEditingController(text: (e.episodeNumber ?? 1).toString());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _seasonCtrl.dispose();
    _episodeCtrl.dispose();
    super.dispose();
  }

  void _showLoadingDialog(BuildContext context) {
    if (_isDialogOpen) return;
    _isDialogOpen = true;
    final bloc = context.read<EditEpisodeBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: BlocBuilder<EditEpisodeBloc, EditEpisodeState>(
            bloc: bloc,
            buildWhen: (_, s) =>
                s is UploadVideoProgressState || s is UpdateEpisodeState,
            builder: (_, state) {
              final isUploading = state is UploadVideoProgressState ||
                  bloc.uploadProgress > 0 && bloc.uploadProgress < 1;
              final progress = bloc.uploadProgress;
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorName.backgroundSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        color: ColorName.accent,
                        value: isUploading ? progress.clamp(0.0, 1.0) : null,
                        strokeWidth: 4,
                      ),
                    ),
                    if (isUploading) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Uploading ${(progress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: ColorName.contentPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
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

  Future<bool> _confirm(
    BuildContext context,
    String title,
    String message, {
    String confirmText = 'Confirm',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorName.backgroundSecondary,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message,
            style: TextStyle(color: ColorName.contentSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: ColorName.contentSecondary,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: confirmColor ?? ColorName.accent,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditEpisodeBloc>();

    return BlocListener<EditEpisodeBloc, EditEpisodeState>(
      listener: (context, state) {
        if (state is PickVideoState || state is PickImageState) {
          final s = state is PickVideoState
              ? state.state
              : (state as PickImageState).state;
          if (s == BaseState.loading) {
            _showLoadingDialog(context);
          } else {
            _dismissLoadingDialog(context);
          }
        }

        if (state is UploadVideoProgressState) {
          _showLoadingDialog(context);
        }

        if (state is UpdateEpisodeState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Episode updated')),
            );
            Navigator.of(context).pop(true);
          } else if (state.state == BaseState.error) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update episode')),
            );
          }
        }

        if (state is DeleteEpisodeState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Episode deleted')),
            );
            Navigator.of(context).pop(true);
          } else if (state.state == BaseState.error) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to delete episode')),
            );
          }
        }

        if (state is ArchiveEpisodeState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Episode archived')),
            );
            Navigator.of(context).pop(true);
          } else if (state.state == BaseState.error) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to archive episode')),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorName.backgroundPrimary,
        appBar: AppBar(
          title: const Text(
            'Edit Episode',
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
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_seasonCtrl, 'Season',
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(_episodeCtrl, 'Episode №',
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(_titleCtrl, 'Title'),
              const SizedBox(height: 16),
              _buildTextField(_descCtrl, 'Description', maxLines: 4),
              const SizedBox(height: 16),
              _buildVideoSection(bloc),
              const SizedBox(height: 16),
              _buildImageSection(bloc),
              const SizedBox(height: 24),
              _buildUpdateButton(bloc),
              const SizedBox(height: 12),
              _buildArchiveButton(bloc),
              const SizedBox(height: 12),
              _buildDeleteButton(bloc),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ColorName.contentSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          cursorColor: ColorName.accent,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
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
        ),
      ],
    );
  }

  Widget _buildVideoSection(EditEpisodeBloc bloc) {
    return BlocBuilder<EditEpisodeBloc, EditEpisodeState>(
      buildWhen: (_, s) => s is PickVideoState || s is RemoveVideoState,
      builder: (context, state) {
        final newPath = bloc.videoPath;
        final existingUrl = bloc.currentVideoUrl;

        Widget preview;
        if (newPath != null) {
          preview = Container(
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
                    newPath.split('/').last,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        } else if (existingUrl != null && existingUrl.isNotEmpty) {
          preview = Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.movie, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    existingUrl.split('/').last,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        } else {
          preview = Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'No video',
              style: TextStyle(color: ColorName.contentSecondary),
            ),
          );
        }

        final hasAny = newPath != null ||
            (existingUrl != null && existingUrl.isNotEmpty);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            preview,
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => bloc.add(PickVideoEvent()),
                    style: _outlineBtnStyle(),
                    icon: const Icon(Icons.videocam),
                    label: Text(hasAny ? 'Change Video' : 'Pick Video'),
                  ),
                ),
                if (hasAny) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final ok = await _confirm(
                          context,
                          'Remove video?',
                          'This will clear the current video from the episode.',
                          confirmText: 'Remove',
                          confirmColor: Colors.redAccent,
                        );
                        if (ok) bloc.add(RemoveVideoEvent());
                      },
                      style: _outlineBtnStyle(color: Colors.redAccent),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Remove'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageSection(EditEpisodeBloc bloc) {
    return BlocBuilder<EditEpisodeBloc, EditEpisodeState>(
      buildWhen: (_, s) => s is PickImageState || s is RemoveImageState,
      builder: (context, state) {
        final newPath = bloc.imagePath;
        final existingUrl = bloc.currentImageUrl;

        Widget preview;
        if (newPath != null) {
          preview = ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(newPath),
              height: 180,
              fit: BoxFit.cover,
            ),
          );
        } else if (existingUrl != null && existingUrl.isNotEmpty) {
          preview = ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              existingUrl,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 180,
                color: ColorName.backgroundSecondary,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.white54),
              ),
            ),
          );
        } else {
          preview = Container(
            height: 120,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              'No image',
              style: TextStyle(color: ColorName.contentSecondary),
            ),
          );
        }

        final hasAny = newPath != null ||
            (existingUrl != null && existingUrl.isNotEmpty);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            preview,
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => bloc.add(PickImageEvent()),
                    style: _outlineBtnStyle(),
                    icon: const Icon(Icons.image),
                    label: Text(hasAny ? 'Change Image' : 'Pick Image'),
                  ),
                ),
                if (hasAny) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final ok = await _confirm(
                          context,
                          'Remove image?',
                          'This will clear the current image from the episode.',
                          confirmText: 'Remove',
                          confirmColor: Colors.redAccent,
                        );
                        if (ok) bloc.add(RemoveImageEvent());
                      },
                      style: _outlineBtnStyle(color: Colors.redAccent),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Remove'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  ButtonStyle _outlineBtnStyle({Color? color}) {
    return OutlinedButton.styleFrom(
      foregroundColor: color ?? ColorName.accent,
      side: BorderSide(color: color ?? ColorName.surfaceSecondary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  Widget _buildUpdateButton(EditEpisodeBloc bloc) {
    return ElevatedButton(
      onPressed: () {
        bloc.add(UpdateEpisodeEvent(
          season: int.tryParse(_seasonCtrl.text) ?? 1,
          episodeNumber: int.tryParse(_episodeCtrl.text) ?? 1,
          title: _titleCtrl.text,
          description: _descCtrl.text,
        ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorName.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text('Update Episode',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildArchiveButton(EditEpisodeBloc bloc) {
    return OutlinedButton.icon(
      onPressed: () async {
        final ok = await _confirm(
          context,
          'Archive episode?',
          'This episode will be hidden from viewers. You can restore it later.',
          confirmText: 'Archive',
        );
        if (ok) bloc.add(ArchiveEpisodeEvent());
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.amber,
        side: const BorderSide(color: Colors.amber),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: const Icon(Icons.archive_outlined),
      label: const Text('Archive Episode',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildDeleteButton(EditEpisodeBloc bloc) {
    return OutlinedButton.icon(
      onPressed: () async {
        final ok = await _confirm(
          context,
          'Delete episode?',
          'This action cannot be undone.',
          confirmText: 'Delete',
          confirmColor: Colors.redAccent,
        );
        if (ok) bloc.add(DeleteEpisodeEvent());
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.redAccent,
        side: const BorderSide(color: Colors.redAccent),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: const Icon(Icons.delete_outline),
      label: const Text('Delete Episode',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}
