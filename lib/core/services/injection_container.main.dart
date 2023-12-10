part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  await _onBoardingInit();
  await _authInit();
}

Future<void> _authInit() async {
  sl
    ..registerFactory(() => AuthBloc(
        signIn: sl(), signUp: sl(), updateUser: sl(), forgotPassowrd: sl()))
    ..registerLazySingleton(() => SignInUS(sl()))
    ..registerLazySingleton(() => SignUpUS(sl()))
    ..registerLazySingleton(() => ForgotPasswordUS(sl()))
    ..registerLazySingleton(() => UpdateUserUS(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(() =>
        AuthRemoteDataSourceImpl(
            authClient: sl(), cloudStoreClient: sl(), dbClient: sl()))
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _onBoardingInit() async {
  final pref = await SharedPreferences.getInstance();
  sl
    ..registerFactory(() =>
        OnBoardingCubit(cacheFirstTimer: sl(), checkIfUserFirstTime: sl()))
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
        () => OnBoardingLocalDataSrcImpl(sl()))
    ..registerLazySingleton(() => pref);
}
