import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/src/ui/pages/playlists_page/playlists_event.dart';
import 'package:shortflix/src/ui/pages/playlists_page/playlists_state.dart';

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState>{
  PlaylistsBloc():super(Initial());
}