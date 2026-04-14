abstract class PostEpisodeEvent {}

class FetchUserMoviesEvent extends PostEpisodeEvent {}

class PickVideoEvent extends PostEpisodeEvent {}

class PickImageEvent extends PostEpisodeEvent {}

class SelectMovieEvent extends PostEpisodeEvent {
  final String movieId;
  SelectMovieEvent({required this.movieId});
}

class CreateEpisodeEvent extends PostEpisodeEvent {
  final int season;
  final int episodeNumber;
  final String title;
  final String description;

  CreateEpisodeEvent({
    required this.season,
    required this.episodeNumber,
    required this.title,
    required this.description,
  });
}
