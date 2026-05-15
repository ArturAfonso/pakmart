

import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/routes/app_router.dart';


final sl = GetIt.instance;

void configureDependencies() {
 sl.registerLazySingleton<GoRouter>(() => createRouter());
}


