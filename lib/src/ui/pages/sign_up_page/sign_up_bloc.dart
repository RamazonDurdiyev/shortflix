import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_event.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState>{
  SignUpBloc():super(Initial());
}