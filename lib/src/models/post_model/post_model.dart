class PostModel {
  final String movieId;
  final int season;
  final int episode;
  final String titleUz;
  final String titleRu;
  final String titleEn;
  final String descriptionUz;
  final String descriptionRu;
  final String descriptionEn;
  final int releaseYear;
  final String categoryId;
  final String ageLimit;
  final String videoPath;
  final String imagePath;

  const PostModel({
    required this.movieId,
    required this.season,
    required this.episode,
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.releaseYear,
    required this.categoryId,
    required this.ageLimit,
    required this.videoPath,
    required this.imagePath,
  });
}