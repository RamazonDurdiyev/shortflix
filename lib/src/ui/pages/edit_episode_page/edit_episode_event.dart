abstract class EditEpisodeEvent {}

class PickVideoEvent extends EditEpisodeEvent {}

class PickImageEvent extends EditEpisodeEvent {}

class UpdateEpisodeEvent extends EditEpisodeEvent {
  final int season;
  final int episodeNumber;
  final String title;
  final String description;

  UpdateEpisodeEvent({
    required this.season,
    required this.episodeNumber,
    required this.title,
    required this.description,
  });
}

class DeleteEpisodeEvent extends EditEpisodeEvent {}

class ArchiveEpisodeEvent extends EditEpisodeEvent {}
