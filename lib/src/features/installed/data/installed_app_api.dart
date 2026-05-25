import 'dart:convert';
import 'dart:io';

import 'package:pakmart/src/core/locale/app_language_repository.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';

class InstalledAppApi {
  InstalledAppApi(this._languageRepository, {HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  final HttpClient _httpClient;
  final AppLanguageRepository _languageRepository;

 /*  Future<FlathubAppInfo?> fetchAppInfo(String appId, {String? locale}) async {
    final resolvedLocale = (locale != null && locale.isNotEmpty) ? locale : await _resolveApiLocaleCode();
    final uri = Uri.parse('https://flathub.org/api/v2/appstream/$appId?locale=$resolvedLocale');
    final request = await _httpClient.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');

    final response = await request.close();

    if (response.statusCode == 404) return null;
    if (response.statusCode < 200 || response.statusCode >= 300) return null;

    final body = await utf8.decoder.bind(response).join();
    final map = jsonDecode(body) as Map<String, dynamic>;
    return FlathubAppInfo.fromJson(map);
  } */

  Future<String> _resolveApiLocaleCode() async {
    final info = await _languageRepository.getEffectiveLocaleInfo();
    final code = info.localeCode.toLowerCase();

    if (code.startsWith('pt')) {
      return 'ptbr';
    }

    if (code.startsWith('es')) {
      return 'es';
    }

    return 'en';
  }
}
