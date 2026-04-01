import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_event.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_state.dart';

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final MovieRepo movieRepo;

  EpisodesBloc({required this.movieRepo}) : super(EpisodesInitial()) {
    on<EpisodesFetchEvent>((event, emit) async {
      await _fetchEpisodes(emit, event.movieId);
    });

    on<EpisodesSelectSeasonEvent>((event, emit) {
      selectedSeason = event.season;
      emit(EpisodesSelectSeasonState(season: event.season));
    });
  }

  MovieDetailsModel? movie;
  List<EpisodeModel> episodes = [];
  int selectedSeason = 1;

  // ─────────────────────────────────────────
  //  Unique seasons derived from episodes
  // ─────────────────────────────────────────
  List<int?> get seasons {
    final s = episodes.map((e) => e.season).toSet().toList();
    s.sort();
    return s;
  }

  // ─────────────────────────────────────────
  //  Episodes filtered by selected season
  // ─────────────────────────────────────────
  List<EpisodeModel> get filteredEpisodes =>
      episodes.where((e) => e.season == selectedSeason).toList();

  // ─────────────────────────────────────────
  //  FETCH
  // ─────────────────────────────────────────
  Future<void> _fetchEpisodes(Emitter<EpisodesState> emit, String movieId) async {
    try {
      emit(EpisodesFetchState(state: BaseState.loading));
      movie = await movieRepo.fetchMovieDetails(movieId);
      episodes = await movieRepo.fetchEpisodes(movieId);
      if (seasons.isNotEmpty) selectedSeason = seasons.first ?? 0;
      emit(EpisodesFetchState(state: BaseState.loaded));
    } catch (e) {
      emit(EpisodesFetchState(state: BaseState.error));
      printDebug('EpisodesBloc _fetchEpisodes error => $e');
    }
  }
}