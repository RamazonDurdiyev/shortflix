import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/repository/user_repo/user_repo.dart';
import 'package:shortflix/src/ui/pages/library_page/library_event.dart';
import 'package:shortflix/src/ui/pages/library_page/library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final MovieRepo movieRepo;
  final UserRepo userRepo;

  LibraryBloc({required this.movieRepo, required this.userRepo})
      : super(Initial()) {
    on<FetchSavedMoviesEvent>((event, emit) async {
      await _fetchSavedMovies(emit);
    });
    on<FetchSavedEpisodesEvent>((event, emit) async {
      await _fetchSavedEpisodes(emit);
    });
    on<FetchLikedEpisodesEvent>((event, emit) async {
      await _fetchLikedEpisodes(emit);
    });
    on<FetchMyMoviesEvent>((event, emit) async {
      await _fetchMyMovies(emit, event.userId);
    });
    on<FetchArchivedMoviesEvent>((event, emit) async {
      await _fetchArchivedMovies(emit);
    });
    on<FetchArchivedEpisodesEvent>((event, emit) async {
      await _fetchArchivedEpisodes(emit);
    });
  }

  List<MovieModel> savedMovies = [];
  List<EpisodeModel> savedEpisodes = [];
  List<EpisodeModel> likedEpisodes = [];
  List<MovieModel> myMovies = [];
  List<MovieModel> archivedMovies = [];
  List<EpisodeModel> archivedEpisodes = [];

  Future<void> _fetchSavedMovies(Emitter<LibraryState> emit) async {
    try {
      emit(FetchSavedMoviesState(state: BaseState.loading));
      savedMovies = await movieRepo.fetchSavedMovies();
      emit(FetchSavedMoviesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchSavedMoviesState(state: BaseState.error));
      printDebug('LibraryBloc _fetchSavedMovies error => $e');
    }
  }

  Future<void> _fetchSavedEpisodes(Emitter<LibraryState> emit) async {
    try {
      emit(FetchSavedEpisodesState(state: BaseState.loading));
      savedEpisodes = await movieRepo.fetchSavedEpisodes();
      emit(FetchSavedEpisodesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchSavedEpisodesState(state: BaseState.error));
      printDebug('LibraryBloc _fetchSavedEpisodes error => $e');
    }
  }

  Future<void> _fetchLikedEpisodes(Emitter<LibraryState> emit) async {
    try {
      emit(FetchLikedEpisodesState(state: BaseState.loading));
      likedEpisodes = await movieRepo.fetchLikedEpisodes();
      emit(FetchLikedEpisodesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchLikedEpisodesState(state: BaseState.error));
      printDebug('LibraryBloc _fetchLikedEpisodes error => $e');
    }
  }

  Future<void> _fetchMyMovies(Emitter<LibraryState> emit, String? userId) async {
    try {
      emit(FetchMyMoviesState(state: BaseState.loading));
      final id = userId ?? (await userRepo.fetchCurrentUser()).id ?? '';
      myMovies = await movieRepo.fetchMoviesOfUser(id);
      emit(FetchMyMoviesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchMyMoviesState(state: BaseState.error));
      printDebug('LibraryBloc _fetchMyMovies error => $e');
    }
  }

  Future<void> _fetchArchivedMovies(Emitter<LibraryState> emit) async {
    try {
      emit(FetchArchivedMoviesState(state: BaseState.loading));
      archivedMovies = await movieRepo.fetchArchivedMovies();
      emit(FetchArchivedMoviesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchArchivedMoviesState(state: BaseState.error));
      printDebug('LibraryBloc _fetchArchivedMovies error => $e');
    }
  }

  Future<void> _fetchArchivedEpisodes(Emitter<LibraryState> emit) async {
    try {
      emit(FetchArchivedEpisodesState(state: BaseState.loading));
      archivedEpisodes = await movieRepo.fetchArchivedEpisodes();
      emit(FetchArchivedEpisodesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchArchivedEpisodesState(state: BaseState.error));
      printDebug('LibraryBloc _fetchArchivedEpisodes error => $e');
    }
  }
}
