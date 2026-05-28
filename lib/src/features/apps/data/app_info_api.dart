import 'dart:convert';
import 'dart:io';

import 'package:pakmart/src/core/locale/app_language_repository.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';

class AppInfoApiNetworkException implements Exception {
  const AppInfoApiNetworkException();
}

class AppInfoApiHttpException implements Exception {
  const AppInfoApiHttpException(this.statusCode);

  final int statusCode;
}

class AppInfoApiMalformedResponseException implements Exception {
  const AppInfoApiMalformedResponseException();
}

class AppInfoApi {
  AppInfoApi(this._languageRepository);

  final AppLanguageRepository _languageRepository;

  Future<FlathubAppInfo?> fetchAppstream(String appId) async {
    final locale = await _languageRepository.getEffectiveLocaleInfo();
    final resolvedLocale = _resolveApiLocaleCode(locale.localeCode);
    final uri = Uri.parse(
      'https://flathub.org/api/v2/appstream/${Uri.encodeComponent(appId)}',
    ).replace(queryParameters: {'locale': resolvedLocale});

    final json = await _getJsonObject(uri);
    if (json == null) {
      return null;
    }

    return FlathubAppInfo.fromJson(json);
  }

  Future<Map<String, dynamic>?> fetchSummary(String appId) {
    final uri = Uri.parse('https://flathub.org/api/v2/summary/${Uri.encodeComponent(appId)}');
    return _getJsonObject(uri);
  }

  Future<Map<String, dynamic>?> fetchStats(String appId) {
    final uri = Uri.parse('https://flathub.org/api/v2/stats/${Uri.encodeComponent(appId)}');
    return _getJsonObject(uri);
  }

  Future<Map<String, dynamic>?> _getJsonObject(Uri uri) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        await response.drain<void>();
        throw AppInfoApiHttpException(response.statusCode);
      }

      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw const AppInfoApiMalformedResponseException();
    } on SocketException {
      throw const AppInfoApiNetworkException();
    } on HttpException {
      throw const AppInfoApiNetworkException();
    } finally {
      client.close(force: true);
    }
  }

  String _resolveApiLocaleCode(String localeCode) {
    final normalized = localeCode.replaceAll('-', '_').trim();
    if (normalized.isEmpty) {
      return 'en';
    }

    return normalized;
  }
}
