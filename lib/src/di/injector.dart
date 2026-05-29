import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/locale/app_language_cubit.dart';
import 'package:pakmart/src/core/locale/app_language_local_datasource.dart';
import 'package:pakmart/src/core/locale/app_language_repository.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/core/theme/theme_repository.dart';
import 'package:pakmart/src/core/theme/themelocal_datasource.dart';
import 'package:pakmart/src/features/apps/bloc/app_info_cubit.dart';
import 'package:pakmart/src/features/apps/data/app_info_api.dart';
import 'package:pakmart/src/features/apps/repositories/app_info_repository.dart';
import 'package:pakmart/src/features/home/bloc/home_featured_bloc.dart';
import 'package:pakmart/src/features/home/bloc/popular_apps_bloc.dart';
import 'package:pakmart/src/features/home/data/home_featured_api.dart';
import 'package:pakmart/src/features/home/repositories/home_featured_repository.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_bloc.dart';
import 'package:pakmart/src/features/installed/data/installed_app_api.dart';
import 'package:pakmart/src/features/installed/repositories/dynamic_permissions_reader.dart';
import 'package:pakmart/src/features/installed/repositories/installation_discovery_service.dart';
import 'package:pakmart/src/features/installed/repositories/installed_app_assembler.dart';
import 'package:pakmart/src/features/installed/repositories/installed_app_inventory_service.dart';
import 'package:pakmart/src/features/installed/repositories/installed_apps_repository_new.dart';
import 'package:pakmart/src/features/installed/repositories/local_metadata_reader.dart';
import 'package:pakmart/src/features/installed/repositories/static_permissions_reader.dart';
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

  sl.registerLazySingleton<InstallationDiscoveryService>(() => const InstallationDiscoveryService());
  sl.registerLazySingleton<InstalledAppInventoryService>(() => InstalledAppInventoryService(sl()));
  sl.registerLazySingleton<LocalMetadataReader>(() => const LocalMetadataReader());
  sl.registerLazySingleton<StaticPermissionsReader>(() => const StaticPermissionsReader());
  sl.registerLazySingleton<DynamicPermissionsReader>(() => const DynamicPermissionsReader());
  sl.registerLazySingleton<InstalledAppAssembler>(() => const InstalledAppAssembler());
  sl.registerLazySingleton<InstalledAppsRepositoryNew>(
    () => InstalledAppsRepositoryNew(
      discoveryService: sl(),
      inventoryService: sl(),
      metadataReader: sl(),
      staticPermissionsReader: sl(),
      dynamicPermissionsReader: sl(),
      assembler: sl(),
    ),
  );

  sl.registerLazySingleton<InstalledAppApi>(() => InstalledAppApi(sl()));
  sl.registerFactory<InstalledAppsBloc>(() => InstalledAppsBloc(sl()));

  sl.registerLazySingleton<AppInfoApi>(() => AppInfoApi(sl()));
  sl.registerLazySingleton<AppInfoRepository>(() => AppInfoRepository(sl()));
  sl.registerFactory<AppInfoCubit>(() => AppInfoCubit(sl()));

  sl.registerLazySingleton<HomeFeaturedApi>(() => HomeFeaturedApi(sl()));
  sl.registerLazySingleton<HomeFeaturedRepository>(() => HomeFeaturedRepository(sl()));
  sl.registerFactory<HomeFeaturedBloc>(() => HomeFeaturedBloc(sl()));
  sl.registerFactory<PopularAppsBloc>(() => PopularAppsBloc(sl()));
}
