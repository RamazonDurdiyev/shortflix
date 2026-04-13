import 'package:dio/dio.dart';
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
    on<SignUpGoogleEvent>((event, emit) async {
      await _signUpWithGoogle(emit);
    });
  }

  Future<void> _signUpWithGoogle(Emitter<SignUpState> emit) async {
    try {
      emit(SignUpGoogleState(state: BaseState.loading));
      await authRepo.signInWithGoogle();
      emit(SignUpGoogleState(state: BaseState.loaded));
    } on GoogleSignInCancelledException {
      emit(SignUpGoogleState(state: BaseState.initial));
    } catch (e, st) {
      emit(SignUpGoogleState(
        state: BaseState.error,
        errorMessage: _describeError(e),
      ));
      printDebug('SignUpBloc _signUpWithGoogle error => $e');
      printDebug(st);
    }
  }

  String _describeError(Object e) {
    final s = e.toString();
    if (e is DioException) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      return 'Dio ${status ?? ''} ${e.requestOptions.path}\n$body\n$s';
    }
    return s;
  }

  Future<void> _signUp(
    Emitter<SignUpState> emit,
    SignUpSubmitEvent event,
  ) async {
    try {
      emit(SignUpSubmitState(state: BaseState.loading, email: event.email));

      // register — backend sends OTP automatically
      await authRepo.signUp(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        birthDateIso: event.birthDateIso,
      );

      emit(SignUpSubmitState(state: BaseState.loaded, email: event.email));
    } catch (e) {
      emit(SignUpSubmitState(state: BaseState.error, email: event.email));
      printDebug('SignUpBloc _signUp error => $e');
    }
  }
}