import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/ui/pages/post_movie_page/post_movie_bloc.dart';
import 'package:shortflix/src/ui/pages/post_movie_page/post_movie_event.dart';
import 'package:shortflix/src/ui/pages/post_movie_page/post_movie_state.dart';

class PostMoviePage extends StatelessWidget {
  const PostMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PostMovieView();
  }
}

class _PostMovieView extends StatefulWidget {
  const _PostMovieView();

  @override
  State<_PostMovieView> createState() => _PostMovieViewState();
}

class _PostMovieViewState extends State<_PostMovieView> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<PostMovieBloc>().add(FetchCategoriesEvent());
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

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PostMovieBloc>();

    return BlocListener<PostMovieBloc, PostMovieState>(
      listener: (context, state) {
        // ── Fetch categories ──────────────────
        if (state is FetchCategoriesState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
          } else if (state.state == BaseState.error) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load categories')),
            );
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

        // ── Create movie ─────────────────────
        if (state is CreateMovieState) {
          if (state.state == BaseState.loading) {
            _showLoadingDialog(context);
          } else if (state.state == BaseState.loaded) {
            _dismissLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Movie posted successfully')),
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
            'Post Movie',
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
              // _buildSectionLabel('Title'),
              // const SizedBox(height: 8),
              _buildTextField(
                _titleCtrl,
                'Title',
                hint: 'ex: The Dark Knight',
              ),

              const SizedBox(height: 20),

              // _buildSectionLabel('Description'),
              // const SizedBox(height: 8),
              _buildTextField(
                _descCtrl,
                'Description',
                maxLines: 3,
                hint:
                    'ex: Crime in Gotham is at its peak. Bruce Wayne becomes a dark vigilante to protect the city',
              ),

              const SizedBox(height: 20),

              // ── Release Year ────────────────────────
              _buildTextField(
                _yearCtrl,
                'Release Year',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 12),

              // ── Category ────────────────────────────
              _buildCategoryDropdown(bloc),

              const SizedBox(height: 12),

              // ── Age Limit ───────────────────────────
              _buildAgeLimitDropdown(bloc),

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
  //  SECTION LABEL
  // ─────────────────────────────────────────
  // Widget _buildSectionLabel(String label) {
  //   return Text(
  //     label,
  //     style: const TextStyle(
  //       color: Colors.white,
  //       fontSize: 15,
  //       fontWeight: FontWeight.w600,
  //     ),
  //   );
  // }

  // ─────────────────────────────────────────
  //  TEXT FIELD
  // ─────────────────────────────────────────
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
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
            hintText: hint,
            hintStyle: TextStyle(
              color: ColorName.contentSecondary.withValues(alpha: 0.5),
            ),
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
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  CATEGORY DROPDOWN
  // ─────────────────────────────────────────
  Widget _buildCategoryDropdown(PostMovieBloc bloc) {
    return BlocBuilder<PostMovieBloc, PostMovieState>(
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
                Icon(
                  Icons.category_outlined,
                  color: ColorName.contentSecondary,
                  size: 18,
                ),
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
                Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorName.contentSecondary,
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCategoriesSheet(BuildContext context, PostMovieBloc bloc) {
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
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          color: ColorName.accent,
                          size: 18,
                        )
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

  // ─────────────────────────────────────────
  //  AGE LIMIT DROPDOWN
  // ─────────────────────────────────────────
  Widget _buildAgeLimitDropdown(PostMovieBloc bloc) {
    final ageLimits = ['0+', '6+', '12+', '16+', '18+'];

    return BlocBuilder<PostMovieBloc, PostMovieState>(
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
                Icon(
                  Icons.shield_outlined,
                  color: ColorName.contentSecondary,
                  size: 18,
                ),
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
                Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorName.contentSecondary,
                ),
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
    PostMovieBloc bloc,
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
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_rounded, color: ColorName.accent, size: 18)
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

  // ─────────────────────────────────────────
  //  IMAGE PICKER
  // ─────────────────────────────────────────
  Widget _buildImagePicker(PostMovieBloc bloc) {
    return BlocBuilder<PostMovieBloc, PostMovieState>(
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
                  height: 200,
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
  Widget _buildSubmitButton(PostMovieBloc bloc) {
    return ElevatedButton(
      onPressed: () {
        bloc.add(
          CreateMovieEvent(
            title: _titleCtrl.text,
            description: _descCtrl.text,
            releaseYear: int.tryParse(_yearCtrl.text) ?? 0,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorName.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        'Post Movie',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
