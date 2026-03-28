import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/ui/pages/confirmation_page/confirmation_bloc.dart';
import 'package:shortflix/src/ui/pages/confirmation_page/confirmation_page.dart';
import 'package:shortflix/src/ui/pages/home_page/home_bloc.dart';
import 'package:shortflix/src/ui/pages/home_page/home_page.dart';
import 'package:shortflix/src/ui/pages/notifications_page/notifications_bloc.dart';
import 'package:shortflix/src/ui/pages/notifications_page/notifications_page.dart';
import 'package:shortflix/src/ui/pages/play_page/play_bloc.dart';
import 'package:shortflix/src/ui/pages/play_page/play_page.dart';
import 'package:shortflix/src/ui/pages/playlists_page/playlists_bloc.dart';
import 'package:shortflix/src/ui/pages/playlists_page/playlists_page.dart';
import 'package:shortflix/src/ui/pages/post_page/post_bloc.dart';
import 'package:shortflix/src/ui/pages/post_page/post_page.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_bloc.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_page.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_bloc.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_page.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_page.dart';

Route? generateRoutes(RouteSettings settings, [bool fadeTransition = false]) {
  final args = settings.arguments;
  printDebug("arguments -> $args");

  switch (settings.name) {

    // ── '/' and signInPage both go to SignIn ──────────────────
    case '/':
    case Navigation.signInPage:
      return buildRoute(
        settings,
        BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(
            authRepo: GetIt.instance.get(),
          ),
          child: const SignInPage(),
        ),
      );

    case Navigation.signUpPage:
      return buildRoute(
        settings,
        BlocProvider<SignUpBloc>(
          create: (_) => SignUpBloc(
            authRepo: GetIt.instance.get(),
          ),
          child: const SignUpPage(),
        ),
      );

    case Navigation.confirmationPage:
      return buildRoute(
        settings,
        BlocProvider<ConfirmationBloc>(
          create: (_) => ConfirmationBloc(
            authRepo: GetIt.instance.get(),
          ),
          child: const ConfirmationPage(),
        ),
      );

    case Navigation.homePage:
      return buildRoute(
        settings,
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            categoryRepo: GetIt.instance.get(),
            movieRepo: GetIt.instance.get(),
          ),
          child: const HomePage(),
        ),
      );

    case Navigation.notificationsPage:
      return buildRoute(
        settings,
        BlocProvider<NotificationsBloc>(
          create: (_) => NotificationsBloc(),
          child: const NotificationsPage(),
        ),
      );

    case Navigation.profilePage:
      return buildRoute(
        settings,
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(),
          child: const ProfilePage(),
        ),
      );

    case Navigation.playlistsPage:
      return buildRoute(
        settings,
        BlocProvider<PlaylistsBloc>(
          create: (_) => PlaylistsBloc(),
          child: const PlaylistsPage(),
        ),
      );

    case Navigation.recPage:
      return buildRoute(
        settings,
        BlocProvider<RecBloc>(
          create: (_) => RecBloc(),
          child: const RecPage(),
        ),
      );

    case Navigation.playPage:
      return buildRoute(
        settings,
        BlocProvider<PlayBloc>(
          create: (_) => PlayBloc(),
          child: const PlayPage(),
        ),
      );

    case Navigation.postPage:
      return buildRoute(
        settings,
        BlocProvider<PostBloc>(
          create: (_) => PostBloc(
            postRepo: GetIt.instance.get(),
            categoryRepo: GetIt.instance.get(),
          ),
          child: const PostPage(),
        ),
      );

    default:
      return null;
  }
}

Route buildRoute(
  RouteSettings settings,
  Widget builder, [
  bool fadeTransition = false,
]) {
  if (fadeTransition) {
    return PageRouteBuilder(
      settings: settings,
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => builder,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
  return CupertinoPageRoute(
    settings: settings,
    builder: (BuildContext context) => builder,
  );
}