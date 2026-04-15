import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/ui/pages/edit_movie_page/edit_movie_bloc.dart';
import 'package:shortflix/src/ui/pages/edit_movie_page/edit_movie_event.dart';
import 'package:shortflix/src/ui/pages/edit_movie_page/edit_movie_state.dart';

class EditMoviePage extends StatelessWidget {
  final MovieDetailsModel movie;
  const EditMoviePage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) => _EditMovieView(movie: movie);
}

class _EditMovieView extends StatefulWidget {
  final MovieDetailsModel movie;
  const _EditMovieView({required this.movie});

  @override
  State<_EditMovieView> createState() => _EditMovieViewState();
}

class _EditMovieViewState extends State<_EditMovieView> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _yearCtrl;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    final m = widget.movie;
    _titleCtrl = TextEditingController(text: m.title ?? '');
    _descCtrl = TextEditingController(text: m.description ?? '');
    _yearCtrl = TextEditingController(text: (m.releaseYear ?? '').toString());
    context.read<EditMovieBloc>().add(FetchCategoriesEvent());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _yearCtrl.dispose();
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
    final bloc = context.read<EditMovieBloc>();

    return BlocListener<EditMovieBloc, EditMovieState>(
      listener: (context, state) {
        if (state is FetchCategoriesState || state is PickImageState) {
          final s = state is FetchCategoriesState
              ? state.state
              : (state as PickImageState).state;
          if (s == BaseState.loading) {
            _showLoadingDialog(context);
          } else {
            _dismissLoadingDialog(context);
          }
        }

        if (state is UpdateMovieState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Movie updated')),
            );
            Navigator.of(context).pop(true);
          } else if (state.state == BaseState.error) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update movie')),
            );
          }
        }

        if (state is DeleteMovieState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Movie deleted')),
            );
            Navigator.of(context).pop(true);
          } else if (state.state == BaseState.error) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to delete movie')),
            );
          }
        }

        if (state is ArchiveMovieState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Movie archived')),
            );
            Navigator.of(context).pop(true);
          } else if (state.state == BaseState.error) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to archive movie')),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorName.backgroundPrimary,
        appBar: AppBar(
          title: const Text(
            'Edit Movie',
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
              _buildTextField(_titleCtrl, 'Title'),
              const SizedBox(height: 16),
              _buildTextField(_descCtrl, 'Description', maxLines: 4),
              const SizedBox(height: 16),
              _buildTextField(_yearCtrl, 'Release Year',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildCategoryDropdown(bloc),
              const SizedBox(height: 12),
              _buildAgeLimitDropdown(bloc),
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

  Widget _buildCategoryDropdown(EditMovieBloc bloc) {
    return BlocBuilder<EditMovieBloc, EditMovieState>(
      buildWhen: (_, state) =>
          state is FetchCategoriesState || state is SelectCategoryState,
      builder: (context, state) {
        final selectedName = bloc.categories
            .where((c) => c.id == bloc.selectedCategoryId)
            .firstOrNull
            ?.name;

        return GestureDetector(
          onTap: () => _showCategoriesSheet(context, bloc),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: bloc.selectedCategoryId.isNotEmpty
                    ? ColorName.accent
                    : ColorName.surfaceSecondary,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.category_outlined,
                    color: ColorName.contentSecondary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedName ?? 'Select category',
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

  void _showCategoriesSheet(BuildContext context, EditMovieBloc bloc) {
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
            'Select Category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bloc.categories.length,
              itemBuilder: (ctx, i) {
                final cat = bloc.categories[i];
                final isSelected = cat.id == bloc.selectedCategoryId;
                return ListTile(
                  title: Text(
                    cat.name,
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
                    bloc.add(SelectCategoryEvent(categoryId: cat.id));
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

  Widget _buildAgeLimitDropdown(EditMovieBloc bloc) {
    final ageLimits = ['0+', '6+', '12+', '16+', '18+'];
    return BlocBuilder<EditMovieBloc, EditMovieState>(
      buildWhen: (_, state) => state is SelectAgeLimitState,
      builder: (context, state) {
        final selected = bloc.selectedAgeLimit;
        return GestureDetector(
          onTap: () => _showAgeLimitSheet(context, bloc, ageLimits),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected.isNotEmpty
                    ? ColorName.accent
                    : ColorName.surfaceSecondary,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.shield_outlined,
                    color: ColorName.contentSecondary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selected.isNotEmpty ? selected : 'Select age limit',
                    style: TextStyle(
                      color: selected.isNotEmpty
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

  void _showAgeLimitSheet(
    BuildContext context,
    EditMovieBloc bloc,
    List<String> ageLimits,
  ) {
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
            'Select Age Limit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...ageLimits.map((age) {
            final isSelected = age == bloc.selectedAgeLimit;
            return ListTile(
              title: Text(
                age,
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
                bloc.add(SelectAgeLimitEvent(ageLimit: age));
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildImageSection(EditMovieBloc bloc) {
    return BlocBuilder<EditMovieBloc, EditMovieState>(
      buildWhen: (_, s) => s is PickImageState || s is RemoveImageState,
      builder: (context, state) {
        final newPath = bloc.imagePath;
        final existingUrl = bloc.currentImageUrl;

        Widget preview;
        if (newPath != null) {
          preview = ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(File(newPath), height: 200, fit: BoxFit.cover),
          );
        } else if (existingUrl != null && existingUrl.isNotEmpty) {
          preview = ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              existingUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 200,
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
                          'This will clear the current poster from the movie.',
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

  Widget _buildUpdateButton(EditMovieBloc bloc) {
    return ElevatedButton(
      onPressed: () {
        bloc.add(UpdateMovieEvent(
          title: _titleCtrl.text,
          description: _descCtrl.text,
          releaseYear: int.tryParse(_yearCtrl.text) ?? 0,
        ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorName.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text('Update Movie',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildArchiveButton(EditMovieBloc bloc) {
    return OutlinedButton.icon(
      onPressed: () async {
        final ok = await _confirm(
          context,
          'Archive movie?',
          'This movie will be hidden from viewers. You can restore it later.',
          confirmText: 'Archive',
        );
        if (ok) bloc.add(ArchiveMovieEvent());
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.amber,
        side: const BorderSide(color: Colors.amber),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: const Icon(Icons.archive_outlined),
      label: const Text('Archive Movie',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildDeleteButton(EditMovieBloc bloc) {
    return OutlinedButton.icon(
      onPressed: () async {
        final ok = await _confirm(
          context,
          'Delete movie?',
          'This action cannot be undone.',
          confirmText: 'Delete',
          confirmColor: Colors.redAccent,
        );
        if (ok) bloc.add(DeleteMovieEvent());
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.redAccent,
        side: const BorderSide(color: Colors.redAccent),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: const Icon(Icons.delete_outline),
      label: const Text('Delete Movie',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}
