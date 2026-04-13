import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/repository/auth_repo/auth_repo.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_event.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepo authRepo;

  SignInBloc({required this.authRepo}) : super(SignInInitial()) {
    on<SignInSubmitEvent>((event, emit) async {
      await _signIn(emit, event);
    });
    on<SignInGoogleEvent>((event, emit) async {
      await _signInWithGoogle(emit);
    });
  }

  Future<void> _signInWithGoogle(Emitter<SignInState> emit) async {
    try {
      emit(SignInGoogleState(state: BaseState.loading));
      await authRepo.signInWithGoogle();
      emit(SignInGoogleState(state: BaseState.loaded));
    } on GoogleSignInCancelledException {
      emit(SignInGoogleState(state: BaseState.initial));
    } catch (e, st) {
      emit(SignInGoogleState(
        state: BaseState.error,
        errorMessage: _describeError(e),
      ));
      printDebug('SignInBloc _signInWithGoogle error => $e');
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

  Future<void> _signIn(Emitter<SignInState> emit, SignInSubmitEvent event) async {
    try {
      emit(SignInSubmitState(state: BaseState.loading));

      await authRepo.signIn(
        email: event.email,
        password: event.password,
      );

      emit(SignInSubmitState(state: BaseState.loaded));
    } on NotSignedUpException {
      // backend says this email has no account → go to sign up
      emit(SignInNotSignedUpState(email: event.email));
    } catch (e) {
      emit(SignInSubmitState(state: BaseState.error));
      printDebug('SignInBloc _signIn error => $e');
    }
  }
}