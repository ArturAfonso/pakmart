import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/preferences/app_preferences_repository.dart';

class AppPreferencesState {
  const AppPreferencesState({required this.showUnverifiedApps});

  final bool showUnverifiedApps;

  AppPreferencesState copyWith({bool? showUnverifiedApps}) {
    return AppPreferencesState(
      showUnverifiedApps: showUnverifiedApps ?? this.showUnverifiedApps,
    );
  }
}

class AppPreferencesCubit extends Cubit<AppPreferencesState> {
  AppPreferencesCubit(this._repository)
    : super(
        AppPreferencesState(showUnverifiedApps: _repository.showUnverifiedApps),
      );

  final AppPreferencesRepository _repository;

  Future<void> setShowUnverifiedApps(bool value) async {
    if (value == state.showUnverifiedApps) {
      return;
    }

    await _repository.setShowUnverifiedApps(value);
    emit(state.copyWith(showUnverifiedApps: value));
  }
}
