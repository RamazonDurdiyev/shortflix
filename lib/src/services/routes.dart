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
import 'package:shortflix/src/ui/pages/saved_page/saved_page.dart';
import 'package:shortflix/src/ui/pages/liked_episodes_page/liked_episodes_page.dart';
import 'package:shortflix/src/ui/pages/my_movies_page/my_movies_page.dart';
import 'package:shortflix/src/ui/pages/all_movies_page/all_movies_bloc.dart';
import 'package:shortflix/src/ui/pages/all_movies_page/all_movies_page.dart';
import 'package:shortflix/src/ui/pages/archived_page/archived_page.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_bloc.dart';
import 'package:shortflix/src/ui/pages/post_episode_page/post_episode_page.dart';
import 'package:shortflix/src/ui/pages/edit_episode_page/edit_episode_bloc.dart';
import 'package:shortflix/src/ui/pages/edit_episode_page/edit_episode_page.dart';
import 'package:shortflix/src/ui/pages/edit_movie_page/edit_movie_bloc.dart';
import 'package:shortflix/src/ui/pages/edit_movie_page/edit_movie_page.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/ui/pages/post_movie_page/post_movie_bloc.dart';
import 'package:shortflix/src/ui/pages/post_movie_page/post_movie_page.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_page.dart';
import 'package:shortflix/src/ui/pages/edit_profile_page/edit_profile_bloc.dart';
import 'package:shortflix/src/ui/pages/edit_profile_page/edit_profile_page.dart';
import 'package:shortflix/src/ui/pages/language_page/language_page.dart';
import 'package:shortflix/src/ui/pages/privacy_policy_page/privacy_policy_page.dart';
import 'package:shortflix/src/models/user_model/user_model.dart';
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
            userRepo: GetIt.instance.get(),
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
      return buildRoute(settings, const ProfilePage());

    case Navigation.editProfilePage:
      return buildRoute(
        settings,
        BlocProvider<EditProfileBloc>(
          create: (_) => EditProfileBloc(
            userRepo: GetIt.instance.get(),
            movieRepo: GetIt.instance.get(),
          ),
          child: EditProfilePage(user: args as UserModel?),
        ),
      );

    case Navigation.languagePage:
      return buildRoute(settings, const LanguagePage());

    case Navigation.privacyPolicyPage:
      return buildRoute(settings, const PrivacyPolicyPage());

    case Navigation.libraryPage:
      return buildRoute(
        settings,
        BlocProvider<LibraryBloc>(
          create: (_) => LibraryBloc(
            movieRepo: GetIt.instance.get(),
            userRepo: GetIt.instance.get(),
          ),
          child: const LibraryPage(),
        ),
      );

    case Navigation.recPage:
      return buildRoute(
        settings,
        BlocProvider<RecBloc>(create: (_) => RecBloc(
          movieRepo: GetIt.instance.get()
        ), child: const RecPage()),
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
            userRepo: GetIt.instance.get(),
          ),
          child: const PostEpisodePage(),
        ),
      );

    case Navigation.editEpisodePage:
      final episode = args as EpisodeDetailsModel;
      return buildRoute(
        settings,
        BlocProvider<EditEpisodeBloc>(
          create: (_) => EditEpisodeBloc(
            movieRepo: GetIt.instance.get(),
            episodeId: episode.id ?? '',
            initialVideoUrl: episode.videoUrl,
            initialImageUrl: episode.imageUrl ?? episode.movieImageUrl,
          ),
          child: EditEpisodePage(episode: episode),
        ),
      );

    case Navigation.editMoviePage:
      final movie = args as MovieDetailsModel;
      return buildRoute(
        settings,
        BlocProvider<EditMovieBloc>(
          create: (_) => EditMovieBloc(
            movieRepo: GetIt.instance.get(),
            categoryRepo: GetIt.instance.get(),
            movieId: movie.id ?? '',
            initialCategoryId: movie.category?.id ?? '',
            initialAgeLimit: movie.ageLimit ?? '',
            initialImageUrl: movie.media,
          ),
          child: EditMoviePage(movie: movie),
        ),
      );

    case Navigation.savedPage:
      return buildRoute(
        settings,
        BlocProvider<LibraryBloc>(
          create: (_) => LibraryBloc(
            movieRepo: GetIt.instance.get(),
            userRepo: GetIt.instance.get(),
          ),
          child: const SavedPage(),
        ),
      );

    case Navigation.likedEpisodesPage:
      return buildRoute(
        settings,
        BlocProvider<LibraryBloc>(
          create: (_) => LibraryBloc(
            movieRepo: GetIt.instance.get(),
            userRepo: GetIt.instance.get(),
          ),
          child: const LikedEpisodesPage(),
        ),
      );

    case Navigation.myMoviesPage:
      final userId = args is Map ? args['userId'] as String? : null;
      final displayName = args is Map ? args['displayName'] as String? : null;
      return buildRoute(
        settings,
        BlocProvider<LibraryBloc>(
          create: (_) => LibraryBloc(
            movieRepo: GetIt.instance.get(),
            userRepo: GetIt.instance.get(),
          ),
          child: MyMoviesPage(userId: userId, displayName: displayName),
        ),
      );

    case Navigation.archivedPage:
      return buildRoute(
        settings,
        BlocProvider<LibraryBloc>(
          create: (_) => LibraryBloc(
            movieRepo: GetIt.instance.get(),
            userRepo: GetIt.instance.get(),
          ),
          child: const ArchivedPage(),
        ),
      );

    case Navigation.allMoviesPage:
      final initialCategoryId = args is String ? args : null;
      return buildRoute(
        settings,
        BlocProvider<AllMoviesBloc>(
          create: (_) => AllMoviesBloc(
            movieRepo: GetIt.instance.get(),
            categoryRepo: GetIt.instance.get(),
            initialCategoryId: initialCategoryId,
          ),
          child: const AllMoviesPage(),
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
