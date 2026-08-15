import 'package:flutter_test/flutter_test.dart';
import 'package:pakmart/src/core/preferences/app_preferences_cubit.dart';
import 'package:pakmart/src/core/preferences/app_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('shows unverified apps by default', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = AppPreferencesRepository(preferences);

    expect(repository.showUnverifiedApps, isTrue);
    expect(repository.canDisplayApp(verified: false), isTrue);
  });

  test('persists the choice to hide unverified apps', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = AppPreferencesRepository(preferences);
    final cubit = AppPreferencesCubit(repository);

    await cubit.setShowUnverifiedApps(false);

    expect(cubit.state.showUnverifiedApps, isFalse);
    expect(repository.canDisplayApp(verified: false), isFalse);
    expect(repository.canDisplayApp(verified: true), isTrue);
    expect(
      preferences.getBool(AppPreferencesRepository.showUnverifiedAppsKey),
      isFalse,
    );

    await cubit.close();
  });
}
