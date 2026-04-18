import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/repository/user_repo/user_repo.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_event.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_state.dart';
import 'package:video_compress/video_compress.dart';

class PostEpisodeBloc extends Bloc<PostEpisodeEvent, PostEpisodeState> {
  final MovieRepo movieRepo;
  final UserRepo userRepo;

  PostEpisodeBloc({required this.movieRepo, required this.userRepo})
      : super(PostEpisodeInitial()) {
    on<FetchUserMoviesEvent>((event, emit) async {
      await _fetchUserMovies(emit);
    });

    on<PickVideoEvent>((event, emit) async {
      await _pickVideo(emit);
    });

    on<PickImageEvent>((event, emit) async {
      await _pickImage(emit);
    });

    on<SelectMovieEvent>((event, emit) {
      selectedMovieId = event.movieId;
      emit(SelectMovieState(movieId: event.movieId));
    });

    on<CreateEpisodeEvent>((event, emit) async {
      await _createEpisode(emit, event);
    });
  }

  String? videoPath;
  String? imagePath;
  String selectedMovieId = '';
  List<MovieModel> userMovies = [];
  double uploadProgress = 0;

  // ─────────────────────────────────────────
  //  FETCH USER MOVIES
  // ─────────────────────────────────────────
  Future<void> _fetchUserMovies(Emitter<PostEpisodeState> emit) async {
    try {
      emit(FetchUserMoviesState(state: BaseState.loading));
      final currentUser = await userRepo.fetchCurrentUser();
      userMovies = await movieRepo.fetchMoviesOfUser(currentUser.id ?? '');
      emit(FetchUserMoviesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchUserMoviesState(state: BaseState.error));
      printDebug('PostEpisodeBloc _fetchUserMovies error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  PICK VIDEO
  // ─────────────────────────────────────────
  Future<void> _pickVideo(Emitter<PostEpisodeState> emit) async {
    try {
      emit(PickVideoState(state: BaseState.loading));
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        videoPath = result.files.single.path!;
        emit(PickVideoState(state: BaseState.loaded));
      } else {
        emit(PickVideoState(state: BaseState.initial));
      }
    } catch (e) {
      emit(PickVideoState(state: BaseState.error));
      printDebug('PostEpisodeBloc _pickVideo error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  PICK IMAGE
  // ─────────────────────────────────────────
  Future<void> _pickImage(Emitter<PostEpisodeState> emit) async {
    try {
      emit(PickImageState(state: BaseState.loading));
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked != null) {
        imagePath = picked.path;
        emit(PickImageState(state: BaseState.loaded));
      } else {
        emit(PickImageState(state: BaseState.initial));
      }
    } catch (e) {
      emit(PickImageState(state: BaseState.error));
      printDebug('PostEpisodeBloc _pickImage error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  CREATE EPISODE
  // ─────────────────────────────────────────
  Future<void> _createEpisode(
    Emitter<PostEpisodeState> emit,
    CreateEpisodeEvent event,
  ) async {
    try {
      uploadProgress = 0;
      emit(CreateEpisodeState(state: BaseState.loading));

      // 1. Compress video (fixes moov atom for trimmed videos) & upload
      String? videoUrl;
      int? durationSeconds;
      if (videoPath != null) {
        final compressed = await VideoCompress.compressVideo(
          videoPath!,
          quality: VideoQuality.MediumQuality,
        );
        final uploadPath = compressed?.file?.path ?? videoPath!;
        final durationMs = compressed?.duration ??
            (await VideoCompress.getMediaInfo(videoPath!)).duration;
        if (durationMs != null && durationMs > 0) {
          durationSeconds = (durationMs / 1000).round();
        }
        emit(UploadVideoProgressState(progress: 0));
        videoUrl = await movieRepo.uploadVideo(
          uploadPath,
          onProgress: (p) {
            uploadProgress = p;
            if (!emit.isDone) emit(UploadVideoProgressState(progress: p));
          },
        );
      }

      // 2. Upload image, get real URL
      String? imageUrl;
      if (imagePath != null) {
        imageUrl = await movieRepo.uploadImage(imagePath!);
      }

      // 3. Create episode with uploaded URLs
      await movieRepo.postEpisode(
        season: event.season,
        episodeNumber: event.episodeNumber,
        movieId: selectedMovieId,
        title: event.title,
        description: event.description,
        videoUrl: videoUrl,
        imageUrl: imageUrl,
        duration: durationSeconds,
      );

      emit(CreateEpisodeState(state: BaseState.loaded));
    } catch (e) {
      emit(CreateEpisodeState(state: BaseState.error));
      printDebug('PostEpisodeBloc _createEpisode error => $e');
    }
  }
}