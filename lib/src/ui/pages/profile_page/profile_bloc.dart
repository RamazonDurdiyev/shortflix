import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/user_model/user_model.dart';
import 'package:shortflix/src/repository/auth_repo/auth_repo.dart';
import 'package:shortflix/src/repository/user_repo/user_repo.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_event.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepo userRepo;
  final AuthRepo authRepo;

  ProfileBloc({required this.userRepo, required this.authRepo})
      : super(Initial()) {
    on<FetchUserEvent>((event, emit) async {
      await _fetchUser(emit);
    });
    on<LogoutEvent>((event, emit) async {
      await _logout(emit);
    });
    on<DeleteAccountEvent>((event, emit) async {
      await _deleteAccount(emit);
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

  Future<void> _logout(Emitter<ProfileState> emit) async {
    try {
      emit(LogoutState(state: BaseState.loading));
      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        printDebug("ProfileBloc _logout google signOut error => $e");
      }
      await authRepo.clearAuth();
      user = null;
      emit(LogoutState(state: BaseState.loaded));
    } catch (e) {
      emit(LogoutState(state: BaseState.error));
      printDebug("ProfileBloc _logout error => $e");
    }
  }

  Future<void> _deleteAccount(Emitter<ProfileState> emit) async {
    try {
      emit(DeleteAccountState(state: BaseState.loading));
      await authRepo.deleteAccount();
      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        printDebug("ProfileBloc _deleteAccount google signOut error => $e");
      }
      user = null;
      emit(DeleteAccountState(state: BaseState.loaded));
    } catch (e) {
      emit(DeleteAccountState(state: BaseState.error));
      printDebug("ProfileBloc _deleteAccount error => $e");
    }
  }
}
