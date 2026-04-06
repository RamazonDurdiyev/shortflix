import 'package:flutter/material.dart';

class Navigation {
  static final navKey = GlobalKey<NavigatorState>();


  // Auth
  static const String splashPage = "/splash_page";
  static const String signInPage = "/sign_in_page";
  static const String signUpPage = "/sign_up_page";
  static const String confirmationPage = "/confirmation_page";

  // 
  static const String homePage = "/home_page";
  static const String episodesPage = "/episodes";
  static const String notificationsPage = "/notifications_page";
  static const String profilePage = "/profile_page";
  static const String playPage = "/play_page";
  static const String libraryPage = "/playlists_page";
  static const String recPage = "/rec_page";

  // library pages
  static const String savedMoviesPage = "/saved_movies_page";

  // post pages
  static const String postPage = "/post_page";
  static const String postEpisodePage = "/post_episode_page";
  static const String postMoviePage = "post_movie_page";
}