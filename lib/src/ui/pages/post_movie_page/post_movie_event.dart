abstract class PostMovieEvent {}

class PickImageEvent extends PostMovieEvent {}

class FetchCategoriesEvent extends PostMovieEvent {}

class SelectCategoryEvent extends PostMovieEvent {
  final String categoryId;
  SelectCategoryEvent({required this.categoryId});
}

class SelectAgeLimitEvent extends PostMovieEvent {
  final String ageLimit;
  SelectAgeLimitEvent({required this.ageLimit});
}

class CreateMovieEvent extends PostMovieEvent {
  final String titleUz;
  final String titleRu;
  final String titleEn;
  final String descriptionUz;
  final String descriptionRu;
  final String descriptionEn;
  final int releaseYear;

  CreateMovieEvent({
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.releaseYear,
  });
}