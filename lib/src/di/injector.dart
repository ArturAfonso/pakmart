import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/locale/app_language_cubit.dart';
import 'package:pakmart/src/core/locale/app_language_local_datasource.dart';
import 'package:pakmart/src/core/locale/app_language_repository.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/core/theme/theme_repository.dart';
import 'package:pakmart/src/core/theme/themelocal_datasource.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_bloc.dart';
import 'package:pakmart/src/features/installed/data/installed_app_api.dart';
import 'package:pakmart/src/features/installed/repositories/installed_apps_repository.dart';
import 'package:pakmart/src/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<GoRouter>(() => createRouter());

  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<ThemeLocalDataSource>(() => ThemeLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(sl()));
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl()));

  sl.registerLazySingleton<AppLanguageLocalDataSource>(() => AppLanguageLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<AppLanguageRepository>(() => AppLanguageRepositoryImpl(sl()));
  sl.registerFactory<AppLanguageCubit>(() => AppLanguageCubit(sl()));

  sl.registerLazySingleton<InstalledAppApi>(() => InstalledAppApi());
  sl.registerLazySingleton<InstalledAppsRepository>(() => InstalledAppsRepositoryImpl(sl()));
  sl.registerFactory<InstalledAppsBloc>(() => InstalledAppsBloc(sl()));
}
