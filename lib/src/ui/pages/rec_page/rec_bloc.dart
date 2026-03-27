import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_event.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_state.dart';

class RecBloc extends Bloc<RecEvent, RecState>{
  RecBloc():super(Initial());
}