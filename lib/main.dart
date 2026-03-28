import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shortflix/injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/src/models/login_model/login_model_adapter.dart';
import 'package:shortflix/src/ui/pages/home_page/home_bloc.dart';
import 'package:shortflix/src/ui/pages/post_page/post_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _init();


  runApp(const MyApp());
}

Future<void> _init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(LoginModelAdapter());
  // Hive.registerAdapter(UserModelAdapter());
  // Hive.registerAdapter(UserRoleModelAdapter());

  // Initialize the injection container
  await di.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
            categoryRepo: GetIt.instance.get()
            // movieRepo: GetIt.instance.get(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Shortflix',
        debugShowCheckedModeBanner: false,
        home: const SignInPage()
      ),
    );
  }
}

