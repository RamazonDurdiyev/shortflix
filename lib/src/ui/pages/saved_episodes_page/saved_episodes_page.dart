import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/ui/pages/library_page/library_bloc.dart';
import 'package:shortflix/src/ui/pages/library_page/library_event.dart';
import 'package:shortflix/src/ui/pages/library_page/library_state.dart';
import 'package:shortflix/src/ui/widgets/global/episodes_grid.dart';

class SavedEpisodesPage extends StatefulWidget {
  const SavedEpisodesPage({super.key});

  @override
  State<SavedEpisodesPage> createState() => _SavedEpisodesPageState();
}

class _SavedEpisodesPageState extends State<SavedEpisodesPage> {
  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(FetchSavedEpisodesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: ColorName.backgroundPrimary,
        elevation: 0,
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
          'Saved Episodes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        buildWhen: (_, state) => state is FetchSavedEpisodesState,
        builder: (context, state) {
          final bloc = context.read<LibraryBloc>();

          if (state is FetchSavedEpisodesState &&
              state.state == BaseState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorName.accent),
            );
          }

          if (state is FetchSavedEpisodesState &&
              state.state == BaseState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded,
                      color: ColorName.contentSecondary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load saved episodes',
                    style: TextStyle(
                        color: ColorName.contentSecondary, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          if (bloc.savedEpisodes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.video_library_outlined,
                      color: ColorName.contentSecondary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'No saved episodes yet',
                    style: TextStyle(
                        color: ColorName.contentSecondary, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 16, bottom: 32),
            child: EpisodesGrid(episodes: bloc.savedEpisodes),
          );
        },
      ),
    );
  }
}
