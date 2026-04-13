import 'package:shortflix/core/utils/base_state.dart';

abstract class PostEpisodeState {}

class PostEpisodeInitial extends PostEpisodeState {}

class FetchUserMoviesState extends PostEpisodeState {
  final BaseState state;
  FetchUserMoviesState({required this.state});
}

class PickVideoState extends PostEpisodeState {
  final BaseState state;
  PickVideoState({required this.state});
}

class PickImageState extends PostEpisodeState {
  final BaseState state;
  PickImageState({required this.state});
}

class SelectMovieState extends PostEpisodeState {
  final String movieId;
  SelectMovieState({required this.movieId});
}

class CreateEpisodeState extends PostEpisodeState {
  final BaseState state;
  CreateEpisodeState({required this.state});
}

class UploadVideoProgressState extends PostEpisodeState {
  final double progress; // 0.0 .. 1.0
  UploadVideoProgressState({required this.progress});
}