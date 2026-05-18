import 'package:pakmart/src/core/locale/app_language_local_datasource.dart';

class EffectiveLocaleInfo {
  const EffectiveLocaleInfo({
    required this.localeCode,
    required this.isManual,
    required this.distroId,
    required this.distroFamily,
  });

  final String localeCode;
  final bool isManual;
  final String distroId;
  final String distroFamily;
}

abstract class AppLanguageRepository {
  Future<EffectiveLocaleInfo> getEffectiveLocaleInfo();
  Future<void> setUserLocaleCode(String localeCode);
  Future<EffectiveLocaleInfo> useSystemLocale();
}

class AppLanguageRepositoryImpl implements AppLanguageRepository {
  AppLanguageRepositoryImpl(this._local);

  final AppLanguageLocalDataSource _local;

  @override
  Future<EffectiveLocaleInfo> getEffectiveLocaleInfo() async {
    final userLocale = await _local.getUserLocaleCode();
    if (userLocale != null && userLocale.isNotEmpty) {
      final system = await _local.detectSystemLocaleInfo();
      return EffectiveLocaleInfo(
        localeCode: userLocale,
        isManual: true,
        distroId: system.distroId,
        distroFamily: system.distroFamily,
      );
    }

    final system = await _local.detectSystemLocaleInfo();
    await _local.saveCachedSystemLocaleCode(system.localeCode);

    return EffectiveLocaleInfo(
      localeCode: system.localeCode,
      isManual: false,
      distroId: system.distroId,
      distroFamily: system.distroFamily,
    );
  }

  @override
  Future<void> setUserLocaleCode(String localeCode) {
    return _local.saveUserLocaleCode(localeCode);
  }

  @override
  Future<EffectiveLocaleInfo> useSystemLocale() async {
    await _local.clearUserLocaleCode();

    final system = await _local.detectSystemLocaleInfo();
    await _local.saveCachedSystemLocaleCode(system.localeCode);

    return EffectiveLocaleInfo(
      localeCode: system.localeCode,
      isManual: false,
      distroId: system.distroId,
      distroFamily: system.distroFamily,
    );
  }
}
