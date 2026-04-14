abstract class EditEpisodeEvent {}

class PickVideoEvent extends EditEpisodeEvent {}

class PickImageEvent extends EditEpisodeEvent {}

class RemoveVideoEvent extends EditEpisodeEvent {}

class RemoveImageEvent extends EditEpisodeEvent {}

class UpdateEpisodeEvent extends EditEpisodeEvent {
  final int season;
  final int episodeNumber;
  final String titleUz;
  final String titleRu;
  final String titleEn;
  final String descriptionUz;
  final String descriptionRu;
  final String descriptionEn;

  UpdateEpisodeEvent({
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

class DeleteEpisodeEvent extends EditEpisodeEvent {}

class ArchiveEpisodeEvent extends EditEpisodeEvent {}
