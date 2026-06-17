import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:pakmart/src/core/locale/app_language_cubit.dart';
import 'package:pakmart/src/core/theme/app_theme.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/di/injector.dart';
import 'package:pakmart/src/features/home/bloc/home_featured_bloc.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()..loadTheme()),
        BlocProvider<AppLanguageCubit>(create: (_) => sl<AppLanguageCubit>()..loadLanguage()),
        BlocProvider(create: (_) => sl<HomeFeaturedBloc>()),
        BlocProvider(create: (_) => sl<InstalledAppsBloc>()..loadInstalledApps()),
      ],

      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return BlocBuilder<AppLanguageCubit, AppLanguageState>(
            builder: (context, languageState) {
              return MaterialApp.router(
                title: 'Flutter Demo',
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: mode,
                locale: languageState.locale,
                supportedLocales: AppLanguageCubit.supportedLocales,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: sl<GoRouter>(),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
