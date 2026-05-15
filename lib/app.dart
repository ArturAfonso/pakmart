


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_theme.dart';
import 'package:pakmart/src/di/injector.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
       theme: AppTheme.light,
       darkTheme: AppTheme.dark,
       themeMode: ThemeMode.light,
      routerConfig: sl<GoRouter>(), 
    );
  }
}