import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/comment_model/comment_model.dart';
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
      await _fetchEpisode(emit, event.movieId, event.episodeNumber);
    });

    on<FetchNextEpisodeEvent>((event, emit) async {
      await _fetchNextEpisode(emit);
    });

    on<FetchArchivedEpisodeEvent>((event, emit) async {
      await _fetchArchivedEpisode(emit, event.episodeId);
    });

    on<PlayTogglePlayPauseEvent>((event, emit) {
      isPlaying = !isPlaying;
      emit(PlayToggleState(isPlaying: isPlaying));
    });

    on<PlayToggleMuteEvent>((event, emit) {
      isMuted = !isMuted;
      emit(PlayMuteState(isMuted: isMuted));
    });

    on<PlayLikeMovieEvent>((event, emit) async {
      await _likeEpisode(emit, event.movieId);
    });

    on<PlaySaveMovieEvent>((event, emit) async {
      await _saveEpisode(emit, event.movieId);
    });

    on<FetchCommentsEvent>((event, emit) async {
      await _fetchComments(emit);
    });

    on<AddCommentEvent>((event, emit) async {
      await _addComment(emit, event.comment);
    });
  }

  int currentPageIndex = 0;
  bool isPlaying       = false;
  bool isMuted         = false;
  bool isLiked         = false;
  bool isSaved         = false;
  String movieId       = '';
  List<EpisodeDetailsModel>? episode;
  final List<EpisodeDetailsModel> episodes = [];
  int totalEpisodes = 0;
  bool isFetchingNext = false;
  int commentCount = 0;
  int likeCount = 0;
  List<CommentModel> comments = [];

  // ─────────────────────────────────────────
  //  FETCH MOVIE
  // ─────────────────────────────────────────
  Future<void> _fetchEpisode(Emitter<PlayState> emit, String movieId, int episodeNumber) async {
    try {
      emit(FetchEpisodeState(state: BaseState.loading));
      this.movieId = movieId;
      final result = await movieRepo.fetchEpisode(movieId, episodeNumber);
      episode = result.episodes;
      totalEpisodes = result.totalEpisodes;
      episodes
        ..clear()
        ..addAll(result.episodes);
      printDebug("episode data => ${episode?[0].toJson().toString()}");
      isLiked = episode?[0].isLiked ?? false;
      isSaved = episode?[0].isSaved ?? false;
      commentCount = episode?[0].commentCount ?? 0;
      likeCount = episode?[0].likeCount ?? 0;
      isPlaying = true;
      emit(FetchEpisodeState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchEpisodeState(state: BaseState.error));
      printDebug('PlayBloc _fetchEpisode error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  FETCH NEXT EPISODE (append)
  // ─────────────────────────────────────────
  Future<void> _fetchNextEpisode(Emitter<PlayState> emit) async {
    if (isFetchingNext) return;
    if (totalEpisodes > 0 && episodes.length >= totalEpisodes) return;
    if (movieId.isEmpty) return;
    isFetchingNext = true;
    try {
      final nextNumber = episodes.isNotEmpty
          ? (episodes.last.episodeNumber ?? episodes.length) + 1
          : 1;
      final result = await movieRepo.fetchEpisode(movieId, nextNumber);
      if (result.episodes.isNotEmpty) {
        episodes.addAll(result.episodes);
        totalEpisodes = result.totalEpisodes;
        emit(FetchEpisodeState(state: BaseState.loaded));
      }
    } catch (e) {
      printDebug('PlayBloc _fetchNextEpisode error => $e');
    } finally {
      isFetchingNext = false;
    }
  }

  // ─────────────────────────────────────────
  //  FETCH ARCHIVED EPISODE (single, by id)
  // ─────────────────────────────────────────
  Future<void> _fetchArchivedEpisode(
    Emitter<PlayState> emit,
    String episodeId,
  ) async {
    try {
      emit(FetchEpisodeState(state: BaseState.loading));
      final details = await movieRepo.fetchArchivedEpisodeDetails(episodeId);
      movieId = details.movieId ?? '';
      episode = [details];
      episodes
        ..clear()
        ..add(details);
      totalEpisodes = 1;
      isLiked = details.isLiked ?? false;
      isSaved = details.isSaved ?? false;
      commentCount = details.commentCount ?? 0;
      likeCount = details.likeCount ?? 0;
      isPlaying = true;
      emit(FetchEpisodeState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchEpisodeState(state: BaseState.error));
      printDebug('PlayBloc _fetchArchivedEpisode error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  LIKE EPISODE
  // ─────────────────────────────────────────
  Future<void> _likeEpisode(Emitter<PlayState> emit, String episodeId) async {
    try {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      emit(PlayLikeState(state: BaseState.loaded, isLiked: isLiked));
      await movieRepo.likeEpisode(episodeId);
    } catch (e) {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      emit(PlayLikeState(state: BaseState.error, isLiked: isLiked));
      printDebug('PlayBloc _likeEpisode error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  SAVE EPISODE
  // ─────────────────────────────────────────
  Future<void> _saveEpisode(Emitter<PlayState> emit, String episodeId) async {
    try {
      isSaved = !isSaved;
      emit(PlaySaveState(state: BaseState.loaded, isSaved: isSaved));
      await movieRepo.saveEpisode(episodeId);
    } catch (e) {
      isSaved = !isSaved;
      emit(PlaySaveState(state: BaseState.error, isSaved: isSaved));
      printDebug('PlayBloc _saveEpisode error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  FETCH COMMENTS
  // ─────────────────────────────────────────
  Future<void> _fetchComments(Emitter<PlayState> emit) async {
    try {
      emit(FetchCommentsState(state: BaseState.loading));
      final episodeId = episode?[0].id ?? '';
      comments = await movieRepo.fetchComments(
        movieId: movieId,
        episodeId: episodeId,
      );
      emit(FetchCommentsState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchCommentsState(state: BaseState.error));
      printDebug('PlayBloc _fetchComments error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  ADD COMMENT
  // ─────────────────────────────────────────
  Future<void> _addComment(Emitter<PlayState> emit, String comment) async {
    try {
      emit(AddCommentState(state: BaseState.loading));
      final episodeId = episode?[0].id ?? '';
      await movieRepo.addComment(
        comment: comment,
        movieId: movieId,
        episodeId: episodeId,
      );
      emit(AddCommentState(state: BaseState.loaded));
      // Refresh comments after adding
      await _fetchComments(emit);
    } catch (e) {
      emit(AddCommentState(state: BaseState.error));
      printDebug('PlayBloc _addComment error => $e');
    }
  }
}