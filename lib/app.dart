import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_theme.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/di/injector.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
         BlocProvider<ThemeCubit>(
      create: (_) => sl<ThemeCubit>()..loadTheme(),
    ),
      ],

      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
      return MaterialApp.router(
        title: 'Flutter Demo',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        routerConfig: sl<GoRouter>(),
        debugShowCheckedModeBanner: false,
      );
    },
      ),
    );
  }
}
