import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/playlists_page/playlists_event.dart';
import 'package:shortflix/src/ui/pages/playlists_page/playlists_state.dart';

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState> {
  final MovieRepo movieRepo;

  PlaylistsBloc({required this.movieRepo}) : super(Initial()) {
    on<FetchSavedMoviesEvent>((event, emit) async {
      await _fetchSavedMovies(emit);
    });
  }

  List<MovieModel> savedMovies = [];

  Future<void> _fetchSavedMovies(Emitter<PlaylistsState> emit) async {
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
