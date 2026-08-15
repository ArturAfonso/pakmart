import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesRepository {
  AppPreferencesRepository(this._preferences);

  static const showUnverifiedAppsKey = 'show_unverified_apps';

  final SharedPreferences _preferences;

  bool get showUnverifiedApps =>
      _preferences.getBool(showUnverifiedAppsKey) ?? true;

  Future<void> setShowUnverifiedApps(bool value) async {
    await _preferences.setBool(showUnverifiedAppsKey, value);
  }

  bool canDisplayApp({required bool verified}) {
    return showUnverifiedApps || verified;
  }
}
