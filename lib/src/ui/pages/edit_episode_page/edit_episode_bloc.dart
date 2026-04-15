import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/edit_episode_page/edit_episode_event.dart';
import 'package:shortflix/src/ui/pages/edit_episode_page/edit_episode_state.dart';
import 'package:video_compress/video_compress.dart';

class EditEpisodeBloc extends Bloc<EditEpisodeEvent, EditEpisodeState> {
  final MovieRepo movieRepo;
  final String episodeId;
  final String? initialVideoUrl;
  final String? initialImageUrl;

  EditEpisodeBloc({
    required this.movieRepo,
    required this.episodeId,
    this.initialVideoUrl,
    this.initialImageUrl,
  }) : super(EditEpisodeInitial()) {
    on<PickVideoEvent>((event, emit) async => _pickVideo(emit));
    on<PickImageEvent>((event, emit) async => _pickImage(emit));
    on<RemoveVideoEvent>((event, emit) {
      videoPath = null;
      videoRemoved = true;
      emit(RemoveVideoState());
    });
    on<RemoveImageEvent>((event, emit) {
      imagePath = null;
      imageRemoved = true;
      emit(RemoveImageState());
    });
    on<UpdateEpisodeEvent>(_updateEpisode);
    on<DeleteEpisodeEvent>((event, emit) async => _deleteEpisode(emit));
    on<ArchiveEpisodeEvent>((event, emit) async => _archiveEpisode(emit));
  }

  String? videoPath;
  String? imagePath;
  bool videoRemoved = false;
  bool imageRemoved = false;
  double uploadProgress = 0;

  Future<void> _pickVideo(Emitter<EditEpisodeState> emit) async {
    try {
      emit(PickVideoState(state: BaseState.loading));
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        videoPath = result.files.single.path!;
        videoRemoved = false;
        emit(PickVideoState(state: BaseState.loaded));
      } else {
        emit(PickVideoState(state: BaseState.initial));
      }
    } catch (e) {
      emit(PickVideoState(state: BaseState.error));
      printDebug('EditEpisodeBloc _pickVideo error => $e');
    }
  }

  Future<void> _pickImage(Emitter<EditEpisodeState> emit) async {
    try {
      emit(PickImageState(state: BaseState.loading));
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked != null) {
        imagePath = picked.path;
        imageRemoved = false;
        emit(PickImageState(state: BaseState.loaded));
      } else {
        emit(PickImageState(state: BaseState.initial));
      }
    } catch (e) {
      emit(PickImageState(state: BaseState.error));
      printDebug('EditEpisodeBloc _pickImage error => $e');
    }
  }

  Future<void> _updateEpisode(
    UpdateEpisodeEvent event,
    Emitter<EditEpisodeState> emit,
  ) async {
    try {
      uploadProgress = 0;
      emit(UpdateEpisodeState(state: BaseState.loading));

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
      } else if (videoRemoved) {
        videoUrl = '';
      }

      String? imageUrl;
      if (imagePath != null) {
        imageUrl = await movieRepo.uploadImage(imagePath!);
      } else if (imageRemoved) {
        imageUrl = '';
      }

      await movieRepo.updateEpisode(
        episodeId: episodeId,
        season: event.season,
        episodeNumber: event.episodeNumber,
        title: event.title,
        description: event.description,
        videoUrl: videoUrl,
        imageUrl: imageUrl,
        duration: durationSeconds,
      );

      emit(UpdateEpisodeState(state: BaseState.loaded));
    } catch (e) {
      emit(UpdateEpisodeState(state: BaseState.error));
      printDebug('EditEpisodeBloc _updateEpisode error => $e');
    }
  }

  Future<void> _deleteEpisode(Emitter<EditEpisodeState> emit) async {
    try {
      emit(DeleteEpisodeState(state: BaseState.loading));
      await movieRepo.deleteEpisode(episodeId);
      emit(DeleteEpisodeState(state: BaseState.loaded));
    } catch (e) {
      emit(DeleteEpisodeState(state: BaseState.error));
      printDebug('EditEpisodeBloc _deleteEpisode error => $e');
    }
  }

  Future<void> _archiveEpisode(Emitter<EditEpisodeState> emit) async {
    try {
      emit(ArchiveEpisodeState(state: BaseState.loading));
      await movieRepo.archiveEpisode(episodeId);
      emit(ArchiveEpisodeState(state: BaseState.loaded));
    } catch (e) {
      emit(ArchiveEpisodeState(state: BaseState.error));
      printDebug('EditEpisodeBloc _archiveEpisode error => $e');
    }
  }

  String? get currentVideoUrl =>
      videoRemoved ? null : (videoPath == null ? initialVideoUrl : null);
  String? get currentImageUrl =>
      imageRemoved ? null : (imagePath == null ? initialImageUrl : null);
}
