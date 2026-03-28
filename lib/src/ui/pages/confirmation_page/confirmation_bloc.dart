import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/repository/auth_repo/auth_repo.dart';
import 'package:shortflix/src/ui/pages/confirmation_page/confirmation_event.dart';
import 'package:shortflix/src/ui/pages/confirmation_page/confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepo authRepo;

  ConfirmationBloc({required this.authRepo}) : super(ConfirmationInitial()) {
    on<ConfirmationSubmitEvent>((event, emit) async {
      await _verifyCode(emit, event);
    });

    on<ConfirmationResendEvent>((event, emit) async {
      await _resendCode(emit, event);
    });
  }

  Future<void> _verifyCode(
    Emitter<ConfirmationState> emit,
    ConfirmationSubmitEvent event,
  ) async {
    try {
      emit(ConfirmationSubmitState(state: BaseState.loading));
      await authRepo.verifyCode(email: event.email, code: event.code);
      emit(ConfirmationSubmitState(state: BaseState.loaded));
    } catch (e) {
      emit(ConfirmationSubmitState(state: BaseState.error));
      printDebug('ConfirmationBloc _verifyCode error => $e');
    }
  }

  Future<void> _resendCode(
    Emitter<ConfirmationState> emit,
    ConfirmationResendEvent event,
  ) async {
    try {
      emit(ConfirmationResendState(state: BaseState.loading));
      await authRepo.sendConfirmationCode(email: event.email);
      emit(ConfirmationResendState(state: BaseState.loaded));
    } catch (e) {
      emit(ConfirmationResendState(state: BaseState.error));
      printDebug('ConfirmationBloc _resendCode error => $e');
    }
  }
}