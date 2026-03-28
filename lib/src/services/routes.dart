import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/services/navigation.dart';
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
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_page.dart';

Route? generateRoutes(RouteSettings settings, [bool fadeTransition = false]) {
  final args = settings.arguments;
  printDebug("arguments -> $args");

  switch (settings.name) {
    // case Navigation.onBoardingPage:
    //   return buildRoute(settings, const OnboardingPage());

    // case Navigation.signInPage:
    //   return buildRoute(
    //     settings,
    //     BlocProvider<SignInCubit>(
    //       create: (context) => SignInCubit(
    //         repo: GetIt.instance.get(),
    //         localStorage: GetIt.instance.get(),
    //       ),
    //       child: const SignInPage(),
    //     ),
    //   );

    // case Navigation.confirmation:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ConfirmationCubit>(
    //           create: (context) =>
    //               ConfirmationCubit(repo: GetIt.instance.get()),
    //         ),
    //         BlocProvider<TimerCubit>(create: (context) => TimerCubit()),
    //         BlocProvider<SignInCubit>(
    //           create: (context) => SignInCubit(
    //             repo: GetIt.instance.get(),
    //             localStorage: GetIt.instance.get(),
    //           ),
    //         ),
    //       ],
    //       child: const ConfirmationPage(),
    //     ),
    //   );

    // case Navigation.signUpPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<SignUpCubit>(
    //           create: (context) => SignUpCubit(
    //             repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const SignUpPage(),
    //     ),
    //   );

    // case Navigation.searchPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<SearchBloc>(
    //           create: (context) => SearchBloc(
    //             repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const SearchPage(),
    //     ),
    //   );

    // case Navigation.categoriesPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<CategoriesBloc>(
    //           create: (context) => CategoriesBloc(
    //             repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const CategoriesPage(),
    //     ),
    //   );

    // case Navigation.settingsPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<SettingsBloc>(
    //           create: (context) => SettingsBloc(
    //             // repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const SettingsPage(),
    //     ),
    //   );

    // case Navigation.notificationsPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<NotificationsBloc>(
    //           create: (context) => NotificationsBloc(
    //             // repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const NotificationsPage(),
    //     ),
    //   );

    case Navigation.homePage:
      return buildRoute(
        settings,
        MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(
                categoryRepo: GetIt.instance.get(),
                movieRepo: GetIt.instance.get(),
                // repo: GetIt.instance.get(),
                // regionRepo: GetIt.instance.get(),
              ),
            ),
            // BlocProvider<RegionAndDistrictCubit>(
            //   create: (context) => RegionAndDistrictCubit(
            //     // regionRepo: GetIt.instance.get(),
            //   ),
            // ),
          ],
          child: const HomePage(),
        ),
      );

    case Navigation.notificationsPage:
      return buildRoute(
        settings,
        MultiBlocProvider(
          providers: [
            BlocProvider<NotificationsBloc>(
              create: (context) => NotificationsBloc(
                // categoryRepo: GetIt.instance.get(),
                // movieRepo: GetIt.instance.get(),
                // repo: GetIt.instance.get(),
                // regionRepo: GetIt.instance.get(),
              ),
            ),
            // BlocProvider<RegionAndDistrictCubit>(
            //   create: (context) => RegionAndDistrictCubit(
            //     // regionRepo: GetIt.instance.get(),
            //   ),
            // ),
          ],
          child: const NotificationsPage(),
        ),
      );

    case Navigation.profilePage:
      return buildRoute(
        settings,
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(
                // categoryRepo: GetIt.instance.get(),
                // movieRepo: GetIt.instance.get(),
                // repo: GetIt.instance.get(),
                // regionRepo: GetIt.instance.get(),
              ),
            ),
            // BlocProvider<RegionAndDistrictCubit>(
            //   create: (context) => RegionAndDistrictCubit(
            //     // regionRepo: GetIt.instance.get(),
            //   ),
            // ),
          ],
          child: const ProfilePage(),
        ),
      );

    case Navigation.signUpPage:
      return buildRoute(
        settings,
        MultiBlocProvider(
          providers: [
            BlocProvider<SignUpBloc>(
              create: (context) => SignUpBloc(
                // categoryRepo: GetIt.instance.get(),
                // movieRepo: GetIt.instance.get(),
                // repo: GetIt.instance.get(),
                // regionRepo: GetIt.instance.get(),
              ),
            ),
            // BlocProvider<RegionAndDistrictCubit>(
            //   create: (context) => RegionAndDistrictCubit(
            //     // regionRepo: GetIt.instance.get(),
            //   ),
            // ),
          ],
          child: const SignUpPage(),
        ),
      );

      case Navigation.playlistsPage:
      return buildRoute(
        settings,
        MultiBlocProvider(
          providers: [
            BlocProvider<PlaylistsBloc>(
              create: (context) => PlaylistsBloc(
                // categoryRepo: GetIt.instance.get(),
                // movieRepo: GetIt.instance.get(),
                // repo: GetIt.instance.get(),
                // regionRepo: GetIt.instance.get(),
              ),
            ),
            // BlocProvider<RegionAndDistrictCubit>(
            //   create: (context) => RegionAndDistrictCubit(
            //     // regionRepo: GetIt.instance.get(),
            //   ),
            // ),
          ],
          child: const PlaylistsPage(),
        ),
      );

      case Navigation.recPage:
      return buildRoute(
        settings,
        MultiBlocProvider(
          providers: [
            BlocProvider<RecBloc>(
              create: (context) => RecBloc(
                // categoryRepo: GetIt.instance.get(),
                // movieRepo: GetIt.instance.get(),
                // repo: GetIt.instance.get(),
                // regionRepo: GetIt.instance.get(),
              ),
            ),
            // BlocProvider<RegionAndDistrictCubit>(
            //   create: (context) => RegionAndDistrictCubit(
            //     // regionRepo: GetIt.instance.get(),
            //   ),
            // ),
          ],
          child: const RecPage(),
        ),
      );

    case Navigation.playPage:
      return buildRoute(
        settings,
        MultiBlocProvider(
          providers: [
            BlocProvider<PlayBloc>(
              create: (context) => PlayBloc(
                // taskRepo: GetIt.instance.get(),
                // executorRepo: GetIt.instance.get(),
                // repo: GetIt.instance.get(),
                // regionRepo: GetIt.instance.get(),
              ),
            ),
            // BlocProvider<RegionAndDistrictCubit>(
            //   create: (context) => RegionAndDistrictCubit(
            //     // regionRepo: GetIt.instance.get(),
            //   ),
            // ),
          ],
          child: const PlayPage(),
        ),
      );

       case Navigation.postPage:
      return buildRoute(
        settings,
        MultiBlocProvider(
          providers: [
            BlocProvider<PostBloc>(
              create: (context) => PostBloc(
                postRepo: GetIt.instance.get(),
                categoryRepo: GetIt.instance.get()
                // executorRepo: GetIt.instance.get(),
                // repo: GetIt.instance.get(),
                // regionRepo: GetIt.instance.get(),
              ),
            ),
            // BlocProvider<RegionAndDistrictCubit>(
            //   create: (context) => RegionAndDistrictCubit(
            //     // regionRepo: GetIt.instance.get(),
            //   ),
            // ),
          ],
          child: const PostPage(),
        ),
      );

    // case Navigation.myTasksPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<MyTasksBloc>(
    //           create: (context) => MyTasksBloc(
    //             repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const MyTasksPage(),
    //     ),
    //   );
    // case Navigation.findTasksPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<FindTasksBloc>(
    //           create: (context) => FindTasksBloc(
    //             repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const FindTasksPage(),
    //     ),
    //   );
    // case Navigation.chatsPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ChatsBloc>(
    //           create: (context) => ChatsBloc(
    //             taskRepo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const ChatsPage(),
    //     ),
    //   );

    // case Navigation.chatPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ChatBloc>(
    //           create: (context) => ChatBloc(
    //             // repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const ChatPage(),
    //     ),
    //   );
    // case Navigation.subcategoriesPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<SubcategoriesBloc>(
    //           create: (context) => SubcategoriesBloc(
    //             repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const SubcategoriesPage(),
    //     ),
    //   );
    // case Navigation.becomeExecutorPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ExecutorBloc>(
    //           create: (context) => ExecutorBloc(
    //             categoryRepo: GetIt.instance.get(),
    //             executorRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const BecomeExecutorPage(),
    //     ),
    //   );
    // case Navigation.createTaskPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<CreateTaskBloc>(
    //           create: (context) => CreateTaskBloc(
    //             repo: GetIt.instance.get(),
    //             executorRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const CreateTaskPage(),
    //     ),
    //   );
    // case Navigation.executorsPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ExecutorsBloc>(
    //           create: (context) => ExecutorsBloc(
    //             // repo: GetIt.instance.get(),
    //             executorRepo: GetIt.instance.get(),
    //             categoryRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const ExecutorsPage(),
    //     ),
    //   );
    // case Navigation.executorDetailsPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ExecutorDetailsBloc>(
    //           create: (context) => ExecutorDetailsBloc(
    //             // repo: GetIt.instance.get(),
    //             executorRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const ExecutorDetailsPage(),
    //     ),
    //   );
    // case Navigation.taskDetailsPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<TaskDetailsBloc>(
    //           create: (context) => TaskDetailsBloc(
    //             repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const TaskDetailsPage(),
    //     ),
    //   );
    // case Navigation.languagePage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<LanguageBloc>(
    //           create: (context) => LanguageBloc(
    //             localStorage: GetIt.instance.get(),
    //             // repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const LanguagePage(),
    //     ),
    //   );
    // case Navigation.languageSettingsPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<LanguageSettingsBloc>(
    //           create: (context) => LanguageSettingsBloc(
    //             localStorage: GetIt.instance.get(),
    //             // repo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const LanguageSettingsPage(),
    //     ),
    //   );
    // case Navigation.editPersonalInfoPage:
    //   return buildRoute(
    //     settings,
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<EditPersonalInfoBloc>(
    //           create: (context) => EditPersonalInfoBloc(
    //             // localStorage: GetIt.instance.get(),
    //             userRepo: GetIt.instance.get(),
    //             // regionRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         // BlocProvider<RegionAndDistrictCubit>(
    //         //   create: (context) => RegionAndDistrictCubit(
    //         //     // regionRepo: GetIt.instance.get(),
    //         //   ),
    //         // ),
    //       ],
    //       child: const EditPersonalInfoPage(),
    //     ),
    //   );
    // // case Navigation.mainPage:
    // //   return buildRoute(
    // //     settings,
    // //     MultiBlocProvider(
    // //       providers: [
    // //         BlocProvider<MainCubit>(
    // //           create: (context) => MainCubit(
    // //             regionRepo: GetIt.instance.get(),
    // //           ),
    // //         ),
    // //         BlocProvider<RegionAndDistrictCubit>(
    // //           create: (context) => RegionAndDistrictCubit(
    // //             regionRepo: GetIt.instance.get(),
    // //           ),
    // //         ),
    // //         BlocProvider(
    // //           create: (context) => BannerCubit(
    // //             repo: GetIt.instance.get(),
    // //           ),
    // //         ),
    // //         BlocProvider(
    // //           create: (context) => CategoryCubit(
    // //             repo: GetIt.instance.get(),
    // //           ),
    // //         ),
    // //         BlocProvider<SignUpCubit>(
    // //           create: (context) => SignUpCubit(
    // //             regionRepo: GetIt.instance.get(),
    // //             repo: GetIt.instance.get(),
    // //           ),
    // //         ),
    // //         BlocProvider<SearchBloc>(
    // //           create: (context) => SearchBloc(
    // //             complexRepo: GetIt.instance.get(),
    // //           ),
    // //         ),
    // //         BlocProvider<ProfileBloc>(
    // //           create: (context) => ProfileBloc(
    // //             repo: GetIt.instance.get(),
    // //             localStorage: GetIt.instance.get(),
    // //           ),
    // //         ),
    // //         BlocProvider<FavouriteCubit>(
    // //           create: (context) => FavouriteCubit(),
    // //         ),
    //         BlocProvider<DetailBloc>(
    //           create: (context) => DetailBloc(
    //             repo: GetIt.instance.get(),
    //             userRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //         BlocProvider(
    //           create: (context) => HomeBloc(
    //             complexRepo: GetIt.instance.get(),
    //           ),
    //         ),
    //       ],
    //       child: const MainPage(),
    //     ),
    //   );
    // case Navigation.imageViewerPage:
    //   return buildRoute(settings, ImageViewerPage());

    // case Navigation.networkErrorPage:
    //   return buildRoute(
    //     settings,
    //     NetWorkErrorPage(networkInfo: GetIt.instance.get()),
    //   );

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
