import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/repository/auth_repo/auth_repo.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_event.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepo authRepo;

  SignUpBloc({required this.authRepo}) : super(SignUpInitial()) {
    on<SignUpSubmitEvent>((event, emit) async {
      await _signUp(emit, event);
    });
  }

  Future<void> _signUp(
    Emitter<SignUpState> emit,
    SignUpSubmitEvent event,
  ) async {
    try {
      emit(SignUpSubmitState(state: BaseState.loading));

      await authRepo.signUp(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        birthDateIso: event.birthDateIso,
      );

      emit(SignUpSubmitState(state: BaseState.loaded));
    } catch (e) {
      emit(SignUpSubmitState(state: BaseState.error));
      printDebug('SignUpBloc _signUp error => $e');
    }
  }
}