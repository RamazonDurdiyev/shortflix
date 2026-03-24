import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/src/ui/pages/play_page/play_event.dart';
import 'package:shortflix/src/ui/pages/play_page/play_state.dart';

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  PlayBloc() : super(Initial()) {
    on<PlayPageChangedEvent>((event, emit) {
      _changePage(emit, event.index);
    });
  }


  int currentPageIndex = 0;

  void _changePage(Emitter<PlayState> emit, int index) {
    try {
      emit(PlayPageChangedState(state: BaseState.loading));
      currentPageIndex = index;
      emit(PlayPageChangedState(state: BaseState.loaded));
    } catch (e) {
      emit(PlayPageChangedState(state: BaseState.error));
    }
  }
}
