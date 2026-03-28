import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shortflix/injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/src/models/auth_model/auth_model_adapter.dart';
import 'package:shortflix/src/ui/pages/home_page/home_bloc.dart';
import 'package:shortflix/src/ui/pages/post_page/post_bloc.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();
  runApp(const MyApp());
}

Future<void> _init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AuthModelAdapter());
  await di.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            categoryRepo: GetIt.instance.get(),
            movieRepo: GetIt.instance.get(),
          ),
        ),
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(
            postRepo: GetIt.instance.get(),
            categoryRepo: GetIt.instance.get(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Shortflix',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoutes,
        initialRoute: Navigation.signInPage,  // ← router handles SignInPage + its BlocProvider
      ),
    );
  }
}