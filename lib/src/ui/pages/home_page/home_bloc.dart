import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/src/ui/pages/home_page/home_event.dart';
import 'package:shortflix/src/ui/pages/home_page/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  HomeBloc() : super(Initial());
}