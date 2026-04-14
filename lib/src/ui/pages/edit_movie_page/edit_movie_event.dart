abstract class EditMovieEvent {}

class FetchCategoriesEvent extends EditMovieEvent {}

class PickImageEvent extends EditMovieEvent {}

class RemoveImageEvent extends EditMovieEvent {}

class SelectCategoryEvent extends EditMovieEvent {
  final String categoryId;
  SelectCategoryEvent({required this.categoryId});
}

class SelectAgeLimitEvent extends EditMovieEvent {
  final String ageLimit;
  SelectAgeLimitEvent({required this.ageLimit});
}

class UpdateMovieEvent extends EditMovieEvent {
  final String title;
  final String description;
  final int releaseYear;

  UpdateMovieEvent({
    required this.title,
    required this.description,
    required this.releaseYear,
  });
}

class DeleteMovieEvent extends EditMovieEvent {}

class ArchiveMovieEvent extends EditMovieEvent {}
