import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_state.dart';
import 'package:pakmart/src/features/installed/repositories/installed_apps_repository_new.dart';

class InstalledAppsBloc extends Cubit<InstalledAppsState> {
  InstalledAppsBloc(this._repository) : super(InstalledAppsInitial());

  final InstalledAppsRepositoryNew _repository;

  Future<void> loadInstalledApps({bool forceRefresh = false}) async {
    final current = state;

    if (current is InstalledAppsLoaded && !forceRefresh) {
      emit(InstalledAppsLoaded(current.data, isLoadingData: true));
    } else {
      emit(InstalledAppsLoading());
    }

    try {
      final apps = await _repository.getInstalledApps();
      emit(InstalledAppsLoaded(apps));
    } catch (e) {
      emit(InstalledAppsError('Falha ao carregar aplicativos instalados: $e'));
    }
  }

  Future<void> refresh() async {
    await loadInstalledApps(forceRefresh: true);
  }
}
