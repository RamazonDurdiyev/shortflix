import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shortflix/injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/src/models/auth_model/auth_model_adapter.dart';
import 'package:shortflix/src/ui/pages/home_page/home_bloc.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_bloc.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_bloc.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('[FlutterError] ${details.exception}');
      debugPrint('${details.stack}');
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('[PlatformDispatcher] $error');
      debugPrint('$stack');
      return true;
    };

    await _init();
    runApp(const MyApp());
  }, (error, stack) {
    debugPrint('[runZonedGuarded] $error');
    debugPrint('$stack');
  });
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
        BlocProvider<PostEpisodeBloc>(
          create: (context) => PostEpisodeBloc(
            movieRepo: GetIt.instance.get(),
          ),
        ),
        BlocProvider<RecBloc>(
          create: (context) => RecBloc(
            movieRepo: GetIt.instance.get(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Shortflix',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoutes,
        initialRoute: Navigation.splashPage,  // ← router handles SignInPage + its BlocProvider
      ),
    );
  }
}