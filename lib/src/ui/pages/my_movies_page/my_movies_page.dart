import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/ui/pages/library_page/library_bloc.dart';
import 'package:shortflix/src/ui/pages/library_page/library_event.dart';
import 'package:shortflix/src/ui/pages/library_page/library_state.dart';
import 'package:shortflix/src/ui/widgets/global/movies_grid.dart';

class MyMoviesPage extends StatefulWidget {
  const MyMoviesPage({super.key, this.userId, this.displayName});

  final String? userId;
  final String? displayName;

  @override
  State<MyMoviesPage> createState() => _MyMoviesPageState();
}

class _MyMoviesPageState extends State<MyMoviesPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<LibraryBloc>()
        .add(FetchMyMoviesEvent(userId: widget.userId));
  }

  String _title(AppLocalizations l) {
    final name = widget.displayName?.trim();
    if (name != null && name.isNotEmpty) return l.moviesBy(name);
    return l.myMovies;
  }

  String _emptyLabel(AppLocalizations l) {
    final name = widget.displayName?.trim();
    if (name != null && name.isNotEmpty) return l.noMoviesYet;
    return l.noMoviesCreatedYet;
  }

  String _errorLabel(AppLocalizations l) {
    final name = widget.displayName?.trim();
    if (name != null && name.isNotEmpty) return l.failedToLoadMovies;
    return l.failedToLoadYourMovies;
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
          _title(l),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        buildWhen: (_, state) => state is FetchMyMoviesState,
        builder: (context, state) {
          final bloc = context.read<LibraryBloc>();

          if (state is FetchMyMoviesState &&
              state.state == BaseState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorName.accent),
            );
          }

          if (state is FetchMyMoviesState &&
              state.state == BaseState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded,
                      color: ColorName.contentSecondary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    _errorLabel(l),
                    style: TextStyle(
                        color: ColorName.contentSecondary, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          if (bloc.myMovies.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.movie_creation_outlined,
                      color: ColorName.contentSecondary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    _emptyLabel(l),
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
            child: MoviesGrid(movies: bloc.myMovies),
          );
        },
      ),
    );
  }
}
