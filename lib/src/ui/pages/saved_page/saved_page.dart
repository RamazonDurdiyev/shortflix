import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/ui/pages/library_page/library_bloc.dart';
import 'package:shortflix/src/ui/pages/library_page/library_event.dart';
import 'package:shortflix/src/ui/pages/library_page/library_state.dart';
import 'package:shortflix/src/ui/widgets/global/episodes_grid.dart';
import 'package:shortflix/src/ui/widgets/global/movies_grid.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final bloc = context.read<LibraryBloc>();
    bloc.add(FetchSavedMoviesEvent());
    bloc.add(FetchSavedEpisodesEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
        title: Text(
          l.saved,
          style: const TextStyle(
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
          tabs: [
            Tab(text: l.tabMovies),
            Tab(text: l.tabEpisodes),
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
    final l = AppLocalizations.of(context);
    return BlocBuilder<LibraryBloc, LibraryState>(
      buildWhen: (_, state) => state is FetchSavedMoviesState,
      builder: (context, state) {
        final bloc = context.read<LibraryBloc>();

        if (state is FetchSavedMoviesState &&
            state.state == BaseState.loading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorName.accent),
          );
        }

        if (state is FetchSavedMoviesState &&
            state.state == BaseState.error) {
          return _message(
              Icons.error_outline_rounded, l.failedToLoadSavedMovies);
        }

        if (bloc.savedMovies.isEmpty) {
          return _message(Icons.bookmark_border_rounded, l.noSavedMoviesYet);
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: MoviesGrid(movies: bloc.savedMovies),
        );
      },
    );
  }
}

class _EpisodesTab extends StatelessWidget {
  const _EpisodesTab();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocBuilder<LibraryBloc, LibraryState>(
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
          return _message(
              Icons.error_outline_rounded, l.failedToLoadSavedEpisodes);
        }

        if (bloc.savedEpisodes.isEmpty) {
          return _message(
              Icons.video_library_outlined, l.noSavedEpisodesYet);
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: EpisodesGrid(episodes: bloc.savedEpisodes),
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
