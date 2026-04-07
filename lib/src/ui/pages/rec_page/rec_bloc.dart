import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/comment_model/comment_model.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_event.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_state.dart';

class RecBloc extends Bloc<RecEvent, RecState> {
  final MovieRepo movieRepo;

  RecBloc({required this.movieRepo}) : super(Initial()) {
    on<FetchShortsEvent>((event, emit) async {
      await _fetchShort(emit);
    });
    on<RecTogglePlayPauseEvent>((event, emit) {
      isPlaying = !isPlaying;
      emit(RecToggleState(isPlaying: isPlaying));
    });
    on<RecToggleMuteEvent>((event, emit) {
      isMuted = !isMuted;
      emit(RecMuteState(isMuted: isMuted));
    });
    on<RecLikeEvent>((event, emit) async {
      await _likeEpisode(emit, event.episodeId);
    });
    on<RecSaveEvent>((event, emit) async {
      await _saveEpisode(emit, event.episodeId);
    });
    on<RecPageChangedEvent>((event, emit) async {
      currentIndex = event.index;
      isPlaying = true;
      _syncLikeSave();
      comments = [];
      emit(RecPageChangedState(index: event.index));
      // Preload next
      if (event.index + 1 >= shorts.length) {
        await _fetchShort(emit);
      }
    });
    on<RecFetchCommentsEvent>((event, emit) async {
      await _fetchComments(emit);
    });
    on<RecAddCommentEvent>((event, emit) async {
      await _addComment(emit, event.comment);
    });
  }

  List<EpisodeDetailsModel> shorts = [];
  int currentIndex = 0;
  bool isPlaying = true;
  bool isMuted = false;
  bool isLiked = false;
  bool isSaved = false;
  int likeCount = 0;
  List<CommentModel> comments = [];

  EpisodeDetailsModel? get currentShort =>
      shorts.isNotEmpty && currentIndex < shorts.length
          ? shorts[currentIndex]
          : null;

  void _syncLikeSave() {
    isLiked = currentShort?.isLiked ?? false;
    isSaved = currentShort?.isSaved ?? false;
    likeCount = currentShort?.likeCount ?? 0;
  }

  Future<void> _fetchShort(Emitter<RecState> emit) async {
    try {
      if (shorts.isEmpty) {
        emit(FetchShortsState(state: BaseState.loading));
      }
      final result = await movieRepo.fetchShort();
      final episode = result['episode'] as EpisodeDetailsModel;

      shorts.add(episode);

      if (shorts.length == 1) _syncLikeSave();
      emit(FetchShortsState(state: BaseState.loaded));
    } catch (e) {
      if (shorts.isEmpty) {
        emit(FetchShortsState(state: BaseState.error));
      }
      printDebug('RecBloc _fetchShort error => $e');
    }
  }

  Future<void> _likeEpisode(Emitter<RecState> emit, String episodeId) async {
    try {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      emit(RecLikeState());
      await movieRepo.likeEpisode(episodeId);
    } catch (e) {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      emit(RecLikeState());
      printDebug('RecBloc _likeEpisode error => $e');
    }
  }

  Future<void> _saveEpisode(Emitter<RecState> emit, String episodeId) async {
    try {
      isSaved = !isSaved;
      emit(RecSaveState());
      await movieRepo.saveEpisode(episodeId);
    } catch (e) {
      isSaved = !isSaved;
      emit(RecSaveState());
      printDebug('RecBloc _saveEpisode error => $e');
    }
  }

  Future<void> _fetchComments(Emitter<RecState> emit) async {
    try {
      final short = currentShort;
      if (short == null) return;
      emit(RecFetchCommentsState(state: BaseState.loading));
      comments = await movieRepo.fetchComments(
        movieId: short.movieId ?? '',
        episodeId: short.id ?? '',
      );
      emit(RecFetchCommentsState(state: BaseState.loaded));
    } catch (e) {
      emit(RecFetchCommentsState(state: BaseState.error));
      printDebug('RecBloc _fetchComments error => $e');
    }
  }

  Future<void> _addComment(Emitter<RecState> emit, String comment) async {
    try {
      final short = currentShort;
      if (short == null) return;
      emit(RecAddCommentState(state: BaseState.loading));
      await movieRepo.addComment(
        comment: comment,
        movieId: short.movieId ?? '',
        episodeId: short.id ?? '',
      );
      emit(RecAddCommentState(state: BaseState.loaded));
      await _fetchComments(emit);
    } catch (e) {
      emit(RecAddCommentState(state: BaseState.error));
      printDebug('RecBloc _addComment error => $e');
    }
  }
}
