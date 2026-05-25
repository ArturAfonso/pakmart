import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/features/apps/screens/app_info_screen.dart';
import 'package:pakmart/src/features/categories/screens/category_detail_screen.dart';
import 'package:pakmart/src/features/categories/screens/categories_screen.dart';
import 'package:pakmart/src/features/home/screens/home_screen.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_bloc.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_state.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/screens/installed_detail_screen.dart';
import 'package:pakmart/src/features/installed/screens/installed_screen.dart';
import 'package:pakmart/src/features/preferences/screens/preferences_screen.dart';
import 'package:pakmart/src/features/shell/screens/app_shell.dart';
import 'package:pakmart/src/routes/app_routes.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.homePath,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(name: AppRoutes.HOME, path: AppRoutes.homePath, builder: (context, state) => const HomeScreen()),
          GoRoute(
            name: AppRoutes.APP_INFO,
            path: AppRoutes.appInfoPath,
            builder: (context, state) => AppInfoScreen(appId: state.pathParameters[AppRoutes.appIdParam]!),
          ),
          GoRoute(
            name: AppRoutes.CATEGORIES,
            path: AppRoutes.categoriesPath,
            builder: (context, state) => const CategoriesScreen(),
            routes: [
              GoRoute(
                name: AppRoutes.CATEGORY_DETAILS,
                path: AppRoutes.categoryDetailsPath,
                builder: (context, state) =>
                    CategoryDetailScreen(categoryId: state.pathParameters[AppRoutes.categoryIdParam]!),
              ),
            ],
          ),
          GoRoute(
            name: AppRoutes.INSTALLED,
            path: AppRoutes.installedPath,
            builder: (context, state) => const InstalledScreen(),
            routes: [
              GoRoute(
                name: AppRoutes.INSTALLED_DETAILS,
                path: AppRoutes.installedDetailsPath,
                builder: (context, state) {
                  final extra = state.extra;
                  if (extra is InstalledAppData) {
                    return InstalledDetailScreen(actualApp: extra, appId: extra.id);
                  }

                  final appId = state.pathParameters[AppRoutes.appIdParam];
                  if (appId == null || appId.isEmpty) {
                    return const Scaffold(body: Center(child: Text('Aplicativo não encontrado.')));
                  }

                  final blocState = context.read<InstalledAppsBloc>().state;
                  if (blocState is InstalledAppsLoaded) {
                    InstalledAppData? app;
                    for (final item in blocState.data) {
                      if (item.id == appId) {
                        app = item;
                        break;
                      }
                    }

                    if (app != null) {
                      return InstalledDetailScreen(actualApp: app, appId: appId);
                    }
                  }

                  return InstalledDetailScreen(appId: appId);
                },
              ),
            ],
          ),
          GoRoute(
            name: AppRoutes.PREFERENCES,
            path: AppRoutes.preferencesPath,
            builder: (context, state) => const PreferencesScreen(),
          ),
        ],
      ),
    ],
  );
}
