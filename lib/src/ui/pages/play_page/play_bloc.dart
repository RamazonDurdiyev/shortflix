import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/play_page/play_event.dart';
import 'package:shortflix/src/ui/pages/play_page/play_state.dart';

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  final MovieRepo movieRepo;

  PlayBloc({required this.movieRepo}) : super(Initial()) {
    on<PlayPageChangedEvent>((event, emit) {
      currentPageIndex = event.index;
      emit(PlayPageChangedState(state: BaseState.loaded, index: event.index));
    });

    on<FetchEpisodeEvent>((event, emit) async {
      await _fetchEpisode(emit, event.movieId, event.episodeId);
    });

    on<PlayTogglePlayPauseEvent>((event, emit) {
      isPlaying = !isPlaying;
      emit(PlayToggleState(isPlaying: isPlaying));
    });
  }

  int currentPageIndex = 0;
  bool isPlaying       = false;
  EpisodeDetailsModel? episode;

  // ─────────────────────────────────────────
  //  FETCH MOVIE
  // ─────────────────────────────────────────
  Future<void> _fetchEpisode(Emitter<PlayState> emit, String movieId, String episodeId) async {
    try {
      emit(FetchEpisodeState(state: BaseState.loading));
      episode = await movieRepo.fetchEpisode(movieId);
      isPlaying = true;
      emit(FetchEpisodeState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchEpisodeState(state: BaseState.error));
      printDebug('PlayBloc _fetchMovie error => $e');
    }
  }
}