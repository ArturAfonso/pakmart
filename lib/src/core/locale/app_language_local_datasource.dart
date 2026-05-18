import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SystemLocaleInfo {
  const SystemLocaleInfo({required this.distroId, required this.distroFamily, required this.localeCode});

  final String distroId;
  final String distroFamily;
  final String localeCode;
}

abstract class AppLanguageLocalDataSource {
  Future<String?> getUserLocaleCode();
  Future<void> saveUserLocaleCode(String localeCode);
  Future<void> clearUserLocaleCode();
  Future<String?> getCachedSystemLocaleCode();
  Future<void> saveCachedSystemLocaleCode(String localeCode);
  Future<SystemLocaleInfo> detectSystemLocaleInfo();
}

class AppLanguageLocalDataSourceImpl implements AppLanguageLocalDataSource {
  AppLanguageLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _userLocaleKey = 'app_language_user_locale';
  static const _systemLocaleKey = 'app_language_system_locale';

  @override
  Future<String?> getUserLocaleCode() async => _prefs.getString(_userLocaleKey);

  @override
  Future<void> saveUserLocaleCode(String localeCode) async {
    await _prefs.setString(_userLocaleKey, _normalizeLocaleCode(localeCode));
  }

  @override
  Future<void> clearUserLocaleCode() async {
    await _prefs.remove(_userLocaleKey);
  }

  @override
  Future<String?> getCachedSystemLocaleCode() async {
    final locale = _prefs.getString(_systemLocaleKey);
    return locale == null ? null : _normalizeLocaleCode(locale);
  }

  @override
  Future<void> saveCachedSystemLocaleCode(String localeCode) async {
    await _prefs.setString(_systemLocaleKey, _normalizeLocaleCode(localeCode));
  }

  @override
  Future<SystemLocaleInfo> detectSystemLocaleInfo() async {
    final distro = await _detectDistro();
    final locale = await _detectLocaleByDistroFamily(distro.family);

    return SystemLocaleInfo(distroId: distro.id, distroFamily: distro.family, localeCode: locale);
  }

  Future<_LinuxDistro> _detectDistro() async {
    try {
      final result = await Process.run('cat', ['/etc/os-release']);
      if (result.exitCode != 0) {
        return const _LinuxDistro(id: 'unknown', family: 'unknown');
      }

      final text = (result.stdout as String).trim();
      final id = _readOsReleaseValue(text, 'ID')?.toLowerCase() ?? 'unknown';
      final idLike = _readOsReleaseValue(text, 'ID_LIKE')?.toLowerCase().split(' ') ?? const <String>[];

      final allIds = <String>{id, ...idLike};

      if (allIds.any((e) => e.contains('debian') || e.contains('ubuntu'))) {
        return _LinuxDistro(id: id, family: 'debian');
      }

      if (allIds.any((e) => e.contains('arch') || e.contains('manjaro'))) {
        return _LinuxDistro(id: id, family: 'arch');
      }

      if (allIds.any((e) => e.contains('fedora') || e.contains('rhel'))) {
        return _LinuxDistro(id: id, family: 'fedora');
      }

      return _LinuxDistro(id: id, family: id);
    } catch (_) {
      return const _LinuxDistro(id: 'unknown', family: 'unknown');
    }
  }

  Future<String> _detectLocaleByDistroFamily(String family) async {
    if (family == 'arch') {
      final localeByLocalectl = await _readLocaleUsingLocalectl();
      if (localeByLocalectl != null) return localeByLocalectl;
    }

    final localeByLocaleCmd = await _readLocaleUsingLocaleCmd();
    if (localeByLocaleCmd != null) return localeByLocaleCmd;

    return _normalizeLocaleCode(Platform.localeName);
  }

  Future<String?> _readLocaleUsingLocalectl() async {
    try {
      final result = await Process.run('localectl', ['status']);
      if (result.exitCode != 0) return null;

      final text = (result.stdout as String).trim();
      final regex = RegExp(r'LANG=([^\s]+)');
      final match = regex.firstMatch(text);
      if (match == null) return null;

      return _normalizeLocaleCode(match.group(1)!);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _readLocaleUsingLocaleCmd() async {
    try {
      final result = await Process.run('locale', []);
      if (result.exitCode != 0) return null;

      final text = (result.stdout as String).trim();
      final regex = RegExp(r'^LANG=([^\n]+)$', multiLine: true);
      final match = regex.firstMatch(text);
      if (match == null) return null;

      return _normalizeLocaleCode(match.group(1)!);
    } catch (_) {
      return null;
    }
  }

  String? _readOsReleaseValue(String content, String key) {
    final regex = RegExp('^${RegExp.escape(key)}=(.*)\$', multiLine: true);
    final match = regex.firstMatch(content);
    if (match == null) return null;

    return match.group(1)?.replaceAll('"', '').trim();
  }

  String _normalizeLocaleCode(String rawLocale) {
    var locale = rawLocale.trim();
    if (locale.isEmpty) return 'en_US';

    final dotIndex = locale.indexOf('.');
    if (dotIndex >= 0) {
      locale = locale.substring(0, dotIndex);
    }

    final atIndex = locale.indexOf('@');
    if (atIndex >= 0) {
      locale = locale.substring(0, atIndex);
    }

    locale = locale.replaceAll('-', '_');

    if (!locale.contains('_') && locale.length == 2) {
      final upper = locale.toUpperCase();
      locale = '${locale.toLowerCase()}_$upper';
    }

    return locale;
  }
}

class _LinuxDistro {
  const _LinuxDistro({required this.id, required this.family});

  final String id;
  final String family;
}
