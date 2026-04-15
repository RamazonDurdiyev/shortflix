import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/src/ui/pages/library_page/library_bloc.dart';
import 'package:shortflix/src/ui/pages/library_page/library_event.dart';
import 'package:shortflix/src/ui/pages/library_page/library_state.dart';
import 'package:shortflix/src/ui/widgets/global/episodes_grid.dart';
import 'package:shortflix/src/ui/widgets/global/movies_grid.dart';

class ArchivedPage extends StatefulWidget {
  const ArchivedPage({super.key});

  @override
  State<ArchivedPage> createState() => _ArchivedPageState();
}

class _ArchivedPageState extends State<ArchivedPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final bloc = context.read<LibraryBloc>();
    bloc.add(FetchArchivedMoviesEvent());
    bloc.add(FetchArchivedEpisodesEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          'Archived',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: ColorName.accent,
          unselectedLabelColor: ColorName.contentSecondary,
          indicatorColor: ColorName.accent,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: const [
            Tab(text: 'Movies'),
            Tab(text: 'Episodes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _MoviesTab(),
          _EpisodesTab(),
        ],
      ),
    );
  }
}

class _MoviesTab extends StatelessWidget {
  const _MoviesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      buildWhen: (_, state) => state is FetchArchivedMoviesState,
      builder: (context, state) {
        final bloc = context.read<LibraryBloc>();

        if (state is FetchArchivedMoviesState &&
            state.state == BaseState.loading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorName.accent),
          );
        }

        if (state is FetchArchivedMoviesState &&
            state.state == BaseState.error) {
          return _message(Icons.error_outline_rounded,
              'Failed to load archived movies');
        }

        if (bloc.archivedMovies.isEmpty) {
          return _message(Icons.archive_outlined, 'No archived movies');
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: MoviesGrid(movies: bloc.archivedMovies),
        );
      },
    );
  }
}

class _EpisodesTab extends StatelessWidget {
  const _EpisodesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      buildWhen: (_, state) => state is FetchArchivedEpisodesState,
      builder: (context, state) {
        final bloc = context.read<LibraryBloc>();

        if (state is FetchArchivedEpisodesState &&
            state.state == BaseState.loading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorName.accent),
          );
        }

        if (state is FetchArchivedEpisodesState &&
            state.state == BaseState.error) {
          return _message(Icons.error_outline_rounded,
              'Failed to load archived episodes');
        }

        if (bloc.archivedEpisodes.isEmpty) {
          return _message(Icons.archive_outlined, 'No archived episodes');
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: EpisodesGrid(
            episodes: bloc.archivedEpisodes,
            onEpisodeTap: (episode) {
              final id = episode.id;
              if (id == null || id.isEmpty) return;
              Navigator.push(
                context,
                generateRoutes(RouteSettings(
                  name: Navigation.playPage,
                  arguments: {'archivedEpisodeId': id},
                ))!,
              );
            },
          ),
        );
      },
    );
  }
}

Widget _message(IconData icon, String text) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: ColorName.contentSecondary, size: 48),
        const SizedBox(height: 12),
        Text(
          text,
          style: TextStyle(color: ColorName.contentSecondary, fontSize: 14),
        ),
      ],
    ),
  );
}
