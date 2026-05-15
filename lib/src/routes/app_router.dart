
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/features/home/screens/home_page.dart';
import 'package:pakmart/src/routes/app_routes.dart';



GoRouter createRouter() {
  return GoRouter(
   initialLocation: AppRoutes.homePath,
    routes: [
      GoRoute(
      name: AppRoutes.HOME, 
      path: AppRoutes.homePath, 
      builder: (context, state) => const HomeScreen(),
     /*  routes: [
        GoRoute(
          name: AppRoutes.DETAILS,
          path: AppRoutes.detailsPath,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return DetailsScreen(id: id);
          },
        ),
      ], */
    ),
  /*   GoRoute(
      name: AppRoutes.LOGIN,
      path: AppRoutes.loginPath,
      builder: (context, state) => const LoginScreen(),
    ), */
    ],
  );
}

/**
 * navegar por rotas filhas como detalhes, use:
 * context.goNamed(
  AppRoutes.DETAILS,
  pathParameters: {'id': '123'},
);
 * 
 */