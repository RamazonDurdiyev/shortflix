import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/user_model/user_model.dart';
import 'package:shortflix/src/repository/user_repo/user_repo.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_event.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepo userRepo;

  ProfileBloc({required this.userRepo}) : super(Initial()) {
    on<FetchUserEvent>((event, emit) async {
      await _fetchUser(emit);
    });
  }

  UserModel? user;

  Future<void> _fetchUser(Emitter<ProfileState> emit) async {
    try {
      emit(FetchUserState(state: BaseState.loading));
      user = await userRepo.fetchCurrentUser();
      emit(FetchUserState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchUserState(state: BaseState.error));
      printDebug("ProfileBloc _fetchUser error => $e");
    }
  }
}
