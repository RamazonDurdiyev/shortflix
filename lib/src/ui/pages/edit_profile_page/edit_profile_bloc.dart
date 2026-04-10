import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/user_model/user_model.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/repository/user_repo/user_repo.dart';
import 'package:shortflix/src/ui/pages/edit_profile_page/edit_profile_event.dart';
import 'package:shortflix/src/ui/pages/edit_profile_page/edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UserRepo userRepo;
  final MovieRepo movieRepo;

  EditProfileBloc({required this.userRepo, required this.movieRepo})
    : super(Initial()) {
    on<PickImageEvent>((event, emit) async {
      await _pickImage(emit);
    });

    on<UpdateUserEvent>((event, emit) async {
      await _updateUser(emit, event);
    });
  }

  String? imagePath;
  UserModel? updatedUser;

  // ─────────────────────────────────────────
  //  PICK IMAGE
  // ─────────────────────────────────────────
  Future<void> _pickImage(Emitter<EditProfileState> emit) async {
    try {
      emit(PickImageState(state: BaseState.loading));
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked != null) {
        imagePath = picked.path;
        emit(PickImageState(state: BaseState.loaded));
      } else {
        emit(PickImageState(state: BaseState.initial));
      }
    } catch (e) {
      emit(PickImageState(state: BaseState.error));
      printDebug('EditProfileBloc _pickImage error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  UPDATE USER
  // ─────────────────────────────────────────
  Future<void> _updateUser(
    Emitter<EditProfileState> emit,
    UpdateUserEvent event,
  ) async {
    try {
      emit(UpdateUserState(state: BaseState.loading));

      // 1. If a new image was picked, upload it first and use its URL.
      //    Otherwise keep the current avatar URL.
      String avatarUrl = event.currentAvatar;
      if (imagePath != null) {
        avatarUrl = await movieRepo.uploadImage(imagePath!);
      }

      // 2. Patch the user with the resolved avatar URL.
      updatedUser = await userRepo.updateUser(
        fullName: event.fullName,
        phone: event.phone,
        avatar: avatarUrl,
        dateOfBirth: event.dateOfBirth,
      );

      emit(UpdateUserState(state: BaseState.loaded));
    } catch (e) {
      emit(UpdateUserState(state: BaseState.error));
      printDebug('EditProfileBloc _updateUser error => $e');
    }
  }
}
