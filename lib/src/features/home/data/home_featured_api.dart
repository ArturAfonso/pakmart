import 'dart:convert';
import 'dart:io';

import 'package:pakmart/src/core/locale/app_language_repository.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';
import 'package:pakmart/src/features/home/models/home_popular_app_data.dart';

class HomeFeaturedApi {
  HomeFeaturedApi(this._languageRepository, {HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  final AppLanguageRepository _languageRepository;
  final HttpClient _httpClient;

  Future<List<String>> fetchAppsOfTheWeek({required DateTime date}) async {
    final dateStr = _formatDate(date);
    final uri = Uri.parse('https://flathub.org/api/v2/app-picks/apps-of-the-week/$dateStr');
    final response = await _getJsonMap(uri);

    final apps = response?['apps'];
    if (apps is! List) {
      return const <String>[];
    }

    return apps
        .map((item) => item is Map<String, dynamic> ? item['app_id'] as String? : null)
        .whereType<String>()
        .toList(growable: false);
  }

  Future<FlathubAppInfo?> fetchAppstream(String appId) async {
    final locale = await _resolveApiLocaleCode();
    final encodedId = Uri.encodeComponent(appId);
    final uri = Uri.parse('https://flathub.org/api/v2/appstream/$encodedId?locale=$locale');
    final map = await _getJsonMap(uri);
    if (map == null) {
      return null;
    }

    try {
      return FlathubAppInfo.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<HomePopularCollectionPageData?> fetchCollectionPage({
    required HomePopularCollection collection,
    required int page,
    int perPage = 24,
  }) async {
    final locale = await _resolveApiLocaleCode();
    final query = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
      'locale': locale,
    };
    final uri = Uri.https('flathub.org', '/api/v2/collection/${collection.apiPath}', query);
    final response = await _getJsonMap(uri);
    if (response == null) {
      return null;
    }

    final hits = response['hits'];
    if (hits is! List) {
      return null;
    }

    final apps = hits
        .map((item) => item is Map<String, dynamic> ? HomePopularAppData.fromJson(item) : null)
        .whereType<HomePopularAppData>()
        .toList(growable: false);

    return HomePopularCollectionPageData(
      collection: collection,
      page: _asInt(response['page']) ?? page,
      perPage: _asInt(response['hitsPerPage']) ?? perPage,
      totalPages: _asInt(response['totalPages']) ?? 1,
      totalHits: _asInt(response['totalHits']) ?? apps.length,
      apps: apps,
    );
  }

  Future<Map<String, dynamic>?> _getJsonMap(Uri uri) async {
    try {
      final request = await _httpClient.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final payload = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String> _resolveApiLocaleCode() async {
    final info = await _languageRepository.getEffectiveLocaleInfo();
    final code = info.localeCode.trim();
    if (code.isEmpty) {
      return 'en_US';
    }

    return code.replaceAll('-', '_');
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '');
  }
}
