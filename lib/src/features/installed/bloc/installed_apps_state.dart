


import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';

/// Estados possíveis da tela Home
abstract class InstalledAppsState {}

class InstalledAppsInitial extends InstalledAppsState {}

class InstalledAppsLoading extends InstalledAppsState {}

class InstalledAppsLoaded extends InstalledAppsState {
  final List<InstalledAppData> data;
  final bool isLoadingData;

  InstalledAppsLoaded(this.data, {this.isLoadingData = false});
}

class InstalledAppsError extends InstalledAppsState {
  final String message;

  InstalledAppsError(this.message);
}
