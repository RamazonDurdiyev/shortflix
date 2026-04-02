import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/network/network_info.dart';
import 'package:shortflix/core/network/network_interceptor.dart';
import 'package:shortflix/src/repository/category_repo/category_repo.dart';
import 'package:shortflix/src/repository/auth_repo/auth_repo.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';

// Dependency injection file

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();
  final Box hiveBox = await Hive.openBox("default");
  // final Box<UserModel> userBox = await Hive.openBox("user");
  // final Box<List<String>> searchesBox = await Hive.openBox("searches");

  var dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(milliseconds: CONNECT_TIME_OUT),
      receiveTimeout: const Duration(milliseconds: RECEIVE_TIME_OUT),
      sendTimeout: const Duration(milliseconds: SEND_TIME_OUT),
    ),
  );

  // External
  sl.registerLazySingleton<Box>(() => hiveBox);
  // sl.registerLazySingleton<Box<UserModel>>(() => userBox);
  sl.registerSingleton<RefreshTokenHelper>(RefreshTokenHelper(box: hiveBox));
  dio = addInterceptor(dio);
  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl(), dataChecker: sl()),
  );

  // core
  // sl.registerLazySingleton(() => InputConverter());

  // Repositories
  sl.registerLazySingleton(
    () => AuthRepo(
      networkInfo: sl.get(),
      client: sl.get(),
      localStorage: hiveBox,
    ),
  );

    sl.registerLazySingleton(
    () => CategoryRepo(
      networkInfo: sl.get(),
      client: sl.get(),
      localStorage: hiveBox,
    ),
  );
    sl.registerLazySingleton(
    () => MovieRepo(
      networkInfo: sl.get(),
      client: sl.get(),
      localStorage: hiveBox,
    ),
  );
  // sl.registerLazySingleton(
  //   () => CategoryRepo(networkInfo: sl.get(), client: sl.get()),
  // );
  // sl.registerLazySingleton(
  //   () => TaskRepo(networkInfo: sl.get(), client: sl.get()),
  // );
  // sl.registerLazySingleton(
  //   () => UserRepo(
  //     networkInfo: sl.get(),
  //     client: sl.get(),
  //     localStorage: hiveBox,
  //   ),
  // );
}
