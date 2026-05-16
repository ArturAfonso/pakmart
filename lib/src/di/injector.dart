

import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/core/theme/theme_repository.dart';
import 'package:pakmart/src/core/theme/themelocal_datasource.dart';
import 'package:pakmart/src/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';


final sl = GetIt.instance;

Future<void> configureDependencies() async {
 sl.registerLazySingleton<GoRouter>(() => createRouter());

 
 final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
 sl.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(sl()),
  );
    sl.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(sl()),
  );
   sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl())..loadTheme());

}


