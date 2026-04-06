import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/ui/pages/library_page/library_bloc.dart';
import 'package:shortflix/src/ui/pages/library_page/library_event.dart';
import 'package:shortflix/src/ui/pages/library_page/library_state.dart';
import 'package:shortflix/src/ui/widgets/global/episodes_grid.dart';

class LikedEpisodesPage extends StatefulWidget {
  const LikedEpisodesPage({super.key});

  @override
  State<LikedEpisodesPage> createState() => _LikedEpisodesPageState();
}

class _LikedEpisodesPageState extends State<LikedEpisodesPage> {
  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(FetchLikedEpisodesEvent());
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
          'Liked Episodes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        buildWhen: (_, state) => state is FetchLikedEpisodesState,
        builder: (context, state) {
          final bloc = context.read<LibraryBloc>();

          if (state is FetchLikedEpisodesState &&
              state.state == BaseState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorName.accent),
            );
          }

          if (state is FetchLikedEpisodesState &&
              state.state == BaseState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded,
                      color: ColorName.contentSecondary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load liked episodes',
                    style: TextStyle(
                        color: ColorName.contentSecondary, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          if (bloc.likedEpisodes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      color: ColorName.contentSecondary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'No liked episodes yet',
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
            child: EpisodesGrid(episodes: bloc.likedEpisodes),
          );
        },
      ),
    );
  }
}
