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
  final String title;
  final String description;
  final int releaseYear;

  CreateMovieEvent({
    required this.title,
    required this.description,
    required this.releaseYear,
  });
}
