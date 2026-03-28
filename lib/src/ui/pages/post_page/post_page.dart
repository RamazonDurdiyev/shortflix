import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/ui/pages/post_page/post_bloc.dart';
import 'package:shortflix/src/ui/pages/post_page/post_event.dart';
import 'package:shortflix/src/ui/pages/post_page/post_state.dart';

// ─────────────────────────────────────────
//  POST PAGE
// ─────────────────────────────────────────
class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PostView();
  }
}

// ─────────────────────────────────────────
//  POST VIEW
// ─────────────────────────────────────────
class _PostView extends StatefulWidget {
  const _PostView();

  @override
  State<_PostView> createState() => _PostViewState();
}

class _PostViewState extends State<_PostView> {
  final _seasonCtrl      = TextEditingController();
  final _episodeCtrl     = TextEditingController();
  final _yearCtrl        = TextEditingController();
  final _titleUzCtrl     = TextEditingController();
  final _titleRuCtrl     = TextEditingController();
  final _titleEnCtrl     = TextEditingController();
  final _descUzCtrl      = TextEditingController();
  final _descRuCtrl      = TextEditingController();
  final _descEnCtrl      = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchCategoriesEvent());
  }

  @override
  void dispose() {
    _seasonCtrl.dispose();
    _episodeCtrl.dispose();
    _yearCtrl.dispose();
    _titleUzCtrl.dispose();
    _titleRuCtrl.dispose();
    _titleEnCtrl.dispose();
    _descUzCtrl.dispose();
    _descRuCtrl.dispose();
    _descEnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PostBloc>();

    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is CreatePostState && state.state == BaseState.loaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Published successfully!'),
              backgroundColor: ColorName.accent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.of(context).pop();
        }
        if (state is CreatePostState && state.state == BaseState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to publish. Try again.'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorName.backgroundPrimary,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      _buildSectionLabel('Film'),
                      const SizedBox(height: 12),
                      _buildVideoUpload(bloc),
                      const SizedBox(height: 20),

                      _buildSectionLabel('Thumbnail'),
                      const SizedBox(height: 12),
                      _buildThumbnailUpload(bloc),
                      const SizedBox(height: 24),

                      _buildSectionLabel('Episode Info'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildNumberField(label: 'Season', hint: '1', icon: Icons.layers_outlined, ctrl: _seasonCtrl)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildNumberField(label: 'Episode', hint: '1', icon: Icons.play_circle_outline_rounded, ctrl: _episodeCtrl)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildNumberField(label: 'Release Year', hint: '2024', icon: Icons.calendar_today_outlined, ctrl: _yearCtrl)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _buildSectionLabel('Category'),
                      const SizedBox(height: 12),
                      _buildCategoryDropdown(bloc),
                      const SizedBox(height: 24),

                      _buildSectionLabel('Title'),
                      const SizedBox(height: 12),
                      _buildLangField(flag: '🇺🇿', label: 'Uzbek', hint: 'Uzbekcha nomi', ctrl: _titleUzCtrl),
                      const SizedBox(height: 12),
                      _buildLangField(flag: '🇷🇺', label: 'Russian', hint: 'Название на русском', ctrl: _titleRuCtrl),
                      const SizedBox(height: 12),
                      _buildLangField(flag: '🇬🇧', label: 'English', hint: 'Title in English', ctrl: _titleEnCtrl),
                      const SizedBox(height: 24),

                      _buildSectionLabel('Description'),
                      const SizedBox(height: 12),
                      _buildLangField(flag: '🇺🇿', label: 'Uzbek', hint: 'Uzbekcha tavsif...', ctrl: _descUzCtrl, multiline: true),
                      const SizedBox(height: 12),
                      _buildLangField(flag: '🇷🇺', label: 'Russian', hint: 'Описание на русском...', ctrl: _descRuCtrl, multiline: true),
                      const SizedBox(height: 12),
                      _buildLangField(flag: '🇬🇧', label: 'English', hint: 'Description in English...', ctrl: _descEnCtrl, multiline: true),
                      const SizedBox(height: 32),

                      _buildSubmitButton(context, bloc),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  TOP BAR
  // ─────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Upload Content',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.3),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorName.surfaceSecondary),
            ),
            child: Text('Save draft', style: TextStyle(color: ColorName.contentSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  VIDEO UPLOAD
  // ─────────────────────────────────────────
  Widget _buildVideoUpload(PostBloc bloc) {
    return BlocBuilder<PostBloc, PostState>(
      buildWhen: (_, state) => state is PickVideoState,
      builder: (context, state) {
        final isLoading = state is PickVideoState && state.state == BaseState.loading;
        final isPicked  = bloc.videoPath != null;

        return GestureDetector(
          onTap: isLoading ? null : () => bloc.add(PickVideoEvent()),
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPicked ? ColorName.accent : ColorName.accent.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: ColorName.accent))
                : isPicked
                    ? _buildPickedVideoContent(bloc.videoPath!)
                    : _buildEmptyVideoContent(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyVideoContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: ColorName.accent.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(Icons.cloud_upload_outlined, color: ColorName.accent, size: 26),
        ),
        const SizedBox(height: 12),
        const Text('Tap to upload film', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('MP4, MKV, MOV — max 4GB', style: TextStyle(color: ColorName.contentSecondary, fontSize: 12)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: ColorName.accent, borderRadius: BorderRadius.circular(20)),
          child: const Text('Browse files', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildPickedVideoContent(String path) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_rounded, color: ColorName.accent, size: 36),
        const SizedBox(height: 10),
        const Text('Video selected', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            path.split('/').last,
            style: TextStyle(color: ColorName.contentSecondary, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Text('Tap to change', style: TextStyle(color: ColorName.accent, fontSize: 12)),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  THUMBNAIL UPLOAD
  // ─────────────────────────────────────────
  Widget _buildThumbnailUpload(PostBloc bloc) {
    return BlocBuilder<PostBloc, PostState>(
      buildWhen: (_, state) => state is PickThumbnailState,
      builder: (context, state) {
        final isLoading = state is PickThumbnailState && state.state == BaseState.loading;
        final isPicked  = bloc.thumbnailPath != null;

        return GestureDetector(
          onTap: isLoading ? null : () => bloc.add(PickThumbnailEvent()),
          child: Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPicked ? ColorName.accent : ColorName.surfaceSecondary,
                width: 1.5,
              ),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: ColorName.accent))
                : Row(
                    children: [
                      // Preview
                      Container(
                        width: 100,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorName.surfaceSecondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: isPicked
                            ? Image.asset(bloc.thumbnailPath!, fit: BoxFit.cover)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined, color: ColorName.contentSecondary, size: 30),
                                  const SizedBox(height: 6),
                                  Text('Preview', style: TextStyle(color: ColorName.contentSecondary, fontSize: 11)),
                                ],
                              ),
                      ),
                      // Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isPicked ? 'Thumbnail selected' : 'Upload Thumbnail',
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isPicked ? bloc.thumbnailPath!.split('/').last : 'JPG, PNG — recommended 1280×720',
                                style: TextStyle(color: ColorName.contentSecondary, fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: ColorName.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: ColorName.accent.withOpacity(0.5)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPicked ? Icons.edit_outlined : Icons.add_photo_alternate_outlined,
                                      color: ColorName.accent,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isPicked ? 'Change image' : 'Choose image',
                                      style: TextStyle(color: ColorName.accent, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  NUMBER FIELD
  // ─────────────────────────────────────────
  Widget _buildNumberField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController ctrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: ColorName.contentSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: ColorName.backgroundSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorName.surfaceSecondary),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Icon(icon, color: ColorName.contentSecondary, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  CATEGORY DROPDOWN
  // ─────────────────────────────────────────
Widget _buildCategoryDropdown(PostBloc bloc) {
  return BlocBuilder<PostBloc, PostState>(
    buildWhen: (_, state) => state is FetchCategoriesState || state is SelectCategoryState,
    builder: (context, state) {
      final isLoading = state is FetchCategoriesState && state.state == BaseState.loading;
      final selectedName = bloc.categories
          .where((c) => c.id == bloc.selectedCategoryId)
          .firstOrNull?.name;

      return GestureDetector(
        onTap: isLoading
            ? null
            : () => _showCategoriesSheet(context, bloc),
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
              Icon(Icons.category_outlined, color: ColorName.contentSecondary, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: isLoading
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: ColorName.accent,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        selectedName ?? 'Select category',
                        style: TextStyle(
                          color: selectedName != null
                              ? Colors.white
                              : ColorName.contentSecondary,
                          fontSize: 14,
                        ),
                      ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: ColorName.contentSecondary, size: 20),
              const SizedBox(width: 14),
            ],
          ),
        ),
      );
    },
  );
}

void _showCategoriesSheet(BuildContext context, PostBloc bloc) {
  showModalBottomSheet(
    context: context,
    backgroundColor: ColorName.backgroundSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: ColorName.surfaceSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: bloc.categories.length,
              itemBuilder: (_, index) {
                final cat = bloc.categories[index];
                final isSelected = cat.id == bloc.selectedCategoryId;
                return ListTile(
                  title: Text(
                    cat.name,
                    style: TextStyle(
                      color: isSelected ? ColorName.accent : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: ColorName.accent, size: 18)
                      : null,
                  onTap: () {
                    bloc.add(SelectCategoryEvent(categoryId: cat.id));
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    },
  );
}

  // ─────────────────────────────────────────
  //  LANGUAGE FIELD
  // ─────────────────────────────────────────
  Widget _buildLangField({
    required String flag,
    required String label,
    required String hint,
    required TextEditingController ctrl,
    bool multiline = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorName.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorName.surfaceSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: ColorName.surfaceSecondary))),
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Text(label, style: TextStyle(color: ColorName.contentSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: TextField(
              controller: ctrl,
              maxLines: multiline ? 4 : 1,
              minLines: 1,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  SUBMIT BUTTON
  // ─────────────────────────────────────────
  Widget _buildSubmitButton(BuildContext context, PostBloc bloc) {
    return BlocBuilder<PostBloc, PostState>(
      buildWhen: (_, state) => state is CreatePostState,
      builder: (context, state) {
        final isLoading = state is CreatePostState && state.state == BaseState.loading;

        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  bloc.add(CreatePostEvent(
                    season:        int.tryParse(_seasonCtrl.text)  ?? 1,
                    episode:       int.tryParse(_episodeCtrl.text) ?? 1,
                    releaseYear:   int.tryParse(_yearCtrl.text)    ?? 2024,
                    titleUz:       _titleUzCtrl.text,
                    titleRu:       _titleRuCtrl.text,
                    titleEn:       _titleEnCtrl.text,
                    descriptionUz: _descUzCtrl.text,
                    descriptionRu: _descRuCtrl.text,
                    descriptionEn: _descEnCtrl.text,
                    categoryId:    bloc.selectedCategoryId,
                  ));
                },
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: isLoading ? ColorName.accent.withOpacity(0.5) : ColorName.accent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Publish', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.2)),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
//  SECTION LABEL
// ─────────────────────────────────────────
Widget _buildSectionLabel(String label) {
  return Row(
    children: [
      Container(
        width: 4,
        height: 16,
        decoration: BoxDecoration(color: ColorName.accent, borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.2)),
    ],
  );
}