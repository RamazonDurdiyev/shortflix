import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/library_page/library_event.dart';
import 'package:shortflix/src/ui/pages/library_page/library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final MovieRepo movieRepo;

  LibraryBloc({required this.movieRepo}) : super(Initial()) {
    on<FetchSavedMoviesEvent>((event, emit) async {
      await _fetchSavedMovies(emit);
    });
  }

  List<MovieModel> savedMovies = [];

  Future<void> _fetchSavedMovies(Emitter<LibraryState> emit) async {
    try {
      emit(FetchSavedMoviesState(state: BaseState.loading));
      savedMovies = await movieRepo.fetchSavedMovies();
      emit(FetchSavedMoviesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchSavedMoviesState(state: BaseState.error));
      printDebug('PlaylistsBloc _fetchSavedMovies error => $e');
    }
  }
}
