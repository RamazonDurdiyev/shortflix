import 'package:shortflix/core/utils/base_state.dart';

abstract class EditEpisodeState {}

class EditEpisodeInitial extends EditEpisodeState {}

class PickVideoState extends EditEpisodeState {
  final BaseState state;
  PickVideoState({required this.state});
}

class PickImageState extends EditEpisodeState {
  final BaseState state;
  PickImageState({required this.state});
}

class UpdateEpisodeState extends EditEpisodeState {
  final BaseState state;
  UpdateEpisodeState({required this.state});
}

class DeleteEpisodeState extends EditEpisodeState {
  final BaseState state;
  DeleteEpisodeState({required this.state});
}

class ArchiveEpisodeState extends EditEpisodeState {
  final BaseState state;
  ArchiveEpisodeState({required this.state});
}

class UploadVideoProgressState extends EditEpisodeState {
  final double progress;
  UploadVideoProgressState({required this.progress});
}
