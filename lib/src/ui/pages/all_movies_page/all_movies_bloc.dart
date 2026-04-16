import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/repository/category_repo/category_repo.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/all_movies_page/all_movies_event.dart';
import 'package:shortflix/src/ui/pages/all_movies_page/all_movies_state.dart';

class AllMoviesBloc extends Bloc<AllMoviesEvent, AllMoviesState> {
  final MovieRepo movieRepo;
  final CategoryRepo categoryRepo;

  AllMoviesBloc({
    required this.movieRepo,
    required this.categoryRepo,
    String? initialCategoryId,
  }) : super(Initial()) {
    selectedCategoryId = initialCategoryId;

    on<FetchCategoriesEvent>((event, emit) async {
      await _fetchCategories(emit);
    });
    on<FetchAllMoviesEvent>((event, emit) async {
      await _fetchMovies(emit);
    });
    on<SelectCategoryEvent>((event, emit) async {
      selectedCategoryId = event.categoryId;
      await _fetchMovies(emit);
    });
  }

  List<CategoryModel> categories = [];
  List<MovieModel> movies = [];
  String? selectedCategoryId;

  Future<void> _fetchCategories(Emitter<AllMoviesState> emit) async {
    try {
      emit(FetchCategoriesState(state: BaseState.loading));
      categories = await categoryRepo.fetchCategories();
      emit(FetchCategoriesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchCategoriesState(state: BaseState.error));
      printDebug('AllMoviesBloc _fetchCategories error => $e');
    }
  }

  Future<void> _fetchMovies(Emitter<AllMoviesState> emit) async {
    try {
      emit(FetchAllMoviesState(state: BaseState.loading));
      final id = selectedCategoryId;
      movies = id == null
          ? await movieRepo.fetchMovies()
          : await movieRepo.fetchMoviesByCategory(id);
      emit(FetchAllMoviesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchAllMoviesState(state: BaseState.error));
      printDebug('AllMoviesBloc _fetchMovies error => $e');
    }
  }
}
