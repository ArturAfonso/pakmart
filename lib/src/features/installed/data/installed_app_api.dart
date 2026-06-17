import 'dart:convert';
import 'dart:io';

import 'package:pakmart/src/core/locale/app_language_repository.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';

class InstalledAppApi {
  InstalledAppApi(this._languageRepository, {HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  final HttpClient _httpClient;
  final AppLanguageRepository _languageRepository;



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
