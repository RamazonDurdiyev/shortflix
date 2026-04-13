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
  final String titleUz;
  final String titleRu;
  final String titleEn;
  final String descriptionUz;
  final String descriptionRu;
  final String descriptionEn;

  CreateEpisodeEvent({
    required this.season,
    required this.episodeNumber,
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
  });
}