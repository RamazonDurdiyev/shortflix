import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/ui/pages/all_movies_page/all_movies_bloc.dart';
import 'package:shortflix/src/ui/pages/all_movies_page/all_movies_event.dart';
import 'package:shortflix/src/ui/pages/all_movies_page/all_movies_state.dart';
import 'package:shortflix/src/ui/widgets/global/movies_grid.dart';

class AllMoviesPage extends StatefulWidget {
  const AllMoviesPage({super.key});

  @override
  State<AllMoviesPage> createState() => _AllMoviesPageState();
}

class _AllMoviesPageState extends State<AllMoviesPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<AllMoviesBloc>();
    bloc.add(FetchCategoriesEvent());
    bloc.add(FetchAllMoviesEvent());
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
        title: Text(
          AppLocalizations.of(context).allMovies,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _CategoryFilterBar(),
          Expanded(
            child: BlocBuilder<AllMoviesBloc, AllMoviesState>(
              buildWhen: (_, state) => state is FetchAllMoviesState,
              builder: (context, state) {
                final bloc = context.read<AllMoviesBloc>();

                if (state is FetchAllMoviesState &&
                    state.state == BaseState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: ColorName.accent),
                  );
                }

                if (state is FetchAllMoviesState &&
                    state.state == BaseState.error) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: ColorName.contentSecondary,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context).failedToLoadMovies,
                          style: TextStyle(
                            color: ColorName.contentSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (bloc.movies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.movie_filter_outlined,
                          color: ColorName.contentSecondary,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context).noMoviesFound,
                          style: TextStyle(
                            color: ColorName.contentSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 12, bottom: 32),
                  child: MoviesGrid(movies: bloc.movies),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllMoviesBloc, AllMoviesState>(
      buildWhen: (_, state) =>
          state is FetchCategoriesState || state is FetchAllMoviesState,
      builder: (context, state) {
        final bloc = context.read<AllMoviesBloc>();
        if (bloc.categories.isEmpty) {
          return const SizedBox(height: 48);
        }
        return SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: bloc.categories.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                final active = bloc.selectedCategoryId == null;
                return _CategoryChip(
                  label: AppLocalizations.of(context).allCategory,
                  active: active,
                  onTap: () => bloc.add(SelectCategoryEvent(categoryId: null)),
                );
              }
              final category = bloc.categories[index - 1];
              final active = bloc.selectedCategoryId == category.id;
              return _CategoryChip(
                label: category.name,
                active: active,
                onTap: () =>
                    bloc.add(SelectCategoryEvent(categoryId: category.id)),
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active ? ColorName.accent : ColorName.backgroundSecondary,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: active ? ColorName.accent : ColorName.surfaceSecondary,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : ColorName.contentPrimary,
              fontSize: 13,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
