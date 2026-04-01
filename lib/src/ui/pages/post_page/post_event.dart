import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {}

class PickVideoEvent extends PostEvent {
  @override
  List<Object?> get props => [];
}

class PickThumbnailEvent extends PostEvent {
  @override
  List<Object?> get props => [];
}

class FetchCategoriesEvent extends PostEvent {
  @override
  List<Object?> get props => [];
}

class SelectCategoryEvent extends PostEvent {
  final String categoryId;
  SelectCategoryEvent({required this.categoryId});
  @override
  List<Object?> get props => [categoryId];
}

class SelectAgeLimitEvent extends PostEvent {
  final String ageLimit;
  SelectAgeLimitEvent({required this.ageLimit});
  @override
  List<Object?> get props => [ageLimit];
}

class CreatePostEvent extends PostEvent {
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

  CreatePostEvent({
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
  });

  @override
  List<Object?> get props => [
        season,
        episode,
        titleUz,
        titleRu,
        titleEn,
        descriptionUz,
        descriptionRu,
        descriptionEn,
        releaseYear,
        categoryId,
        ageLimit,
      ];
}