import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/ui/pages/confirmation_page/confirmation_bloc.dart';
import 'package:shortflix/src/ui/pages/confirmation_page/confirmation_page.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_bloc.dart';
import 'package:shortflix/src/ui/pages/episodes_page/episodes_page.dart';
import 'package:shortflix/src/ui/pages/home_page/home_bloc.dart';
import 'package:shortflix/src/ui/pages/home_page/home_page.dart';
import 'package:shortflix/src/ui/pages/notifications_page/notifications_bloc.dart';
import 'package:shortflix/src/ui/pages/notifications_page/notifications_page.dart';
import 'package:shortflix/src/ui/pages/play_page/play_bloc.dart';
import 'package:shortflix/src/ui/pages/play_page/play_page.dart';
import 'package:shortflix/src/ui/pages/library_page/library_bloc.dart';
import 'package:shortflix/src/ui/pages/library_page/library_page.dart';
import 'package:shortflix/src/ui/pages/saved_movies_page/saved_movies_page.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_bloc.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_page.dart';
import 'package:shortflix/src/ui/pages/post_movie_page/post_movie_bloc.dart';
import 'package:shortflix/src/ui/pages/post_movie_page/post_movie_page.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_bloc.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_page.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_bloc.dart';
import 'package:shortflix/src/ui/pages/rec_page/rec_page.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_page.dart';
import 'package:shortflix/src/ui/pages/splash_page/splash_cubit.dart';
import 'package:shortflix/src/ui/pages/splash_page/splash_page.dart';
import 'package:shortflix/src/ui/pages/post_page/post_page.dart';

Route? generateRoutes(RouteSettings settings, [bool fadeTransition = false]) {
  final args = settings.arguments;
  printDebug("arguments -> $args");

  switch (settings.name) {
    case Navigation.signInPage:
      return buildRoute(
        settings,
        BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(authRepo: GetIt.instance.get()),
          child: const SignInPage(),
        ),
      );

    case Navigation.signUpPage:
      return buildRoute(
        settings,
        BlocProvider<SignUpBloc>(
          create: (_) => SignUpBloc(authRepo: GetIt.instance.get()),
          child: const SignUpPage(),
        ),
      );

    case Navigation.confirmationPage:
      return buildRoute(
        settings,
        BlocProvider<ConfirmationBloc>(
          create: (_) => ConfirmationBloc(authRepo: GetIt.instance.get()),
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

    case Navigation.libraryPage:
      return buildRoute(
        settings,
        BlocProvider<LibraryBloc>(
          create: (_) => LibraryBloc(movieRepo: GetIt.instance.get()),
          child: const LibraryPage(),
        ),
      );

    case Navigation.recPage:
      return buildRoute(
        settings,
        BlocProvider<RecBloc>(create: (_) => RecBloc(), child: const RecPage()),
      );

    case Navigation.playPage:
      return buildRoute(
        settings,
        BlocProvider<PlayBloc>(
          create: (_) => PlayBloc(
            movieRepo: GetIt.instance.get()
          ),
          child: const PlayPage(),
        ),
      );
      case Navigation.episodesPage:
      return buildRoute(
        settings,
        BlocProvider<EpisodesBloc>(
          create: (_) => EpisodesBloc(
            movieRepo: GetIt.instance.get()
          ),
          child: const EpisodesPage(),
        ),
      );

    case Navigation.splashPage:
      return buildRoute(
        settings,
        BlocProvider<SplashCubit>(
          create: (_) => SplashCubit(
            localStorage: GetIt.instance.get(),
            networkInfo: GetIt.instance.get(),
          ),
          child: const SplashPage(),
        ),
      );



  case Navigation.postPage:
  return buildRoute(settings, const PostPage());

  case Navigation.postMoviePage:
      return buildRoute(
        settings,
        BlocProvider<PostMovieBloc>(
          create: (_) => PostMovieBloc(
            categoryRepo: GetIt.instance.get(),
            movieRepo: GetIt.instance.get()
          ),
          child: const PostMoviePage(),
        ),
      );

    case Navigation.postEpisodePage:
      return buildRoute(
        settings,
        BlocProvider<PostEpisodeBloc>(
          create: (_) => PostEpisodeBloc(
            movieRepo: GetIt.instance.get(),
          ),
          child: const PostEpisodePage(),
        ),
      );

    case Navigation.savedMoviesPage:
      return buildRoute(
        settings,
        BlocProvider<LibraryBloc>(
          create: (_) => LibraryBloc(movieRepo: GetIt.instance.get()),
          child: const SavedMoviesPage(),
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
