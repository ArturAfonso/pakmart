import 'dart:convert';
import 'dart:io';

import 'package:pakmart/src/core/locale/app_language_repository.dart';
import 'package:pakmart/src/features/search/models/search_app_data.dart';

class SearchApi {
  SearchApi(this._languageRepository, {HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  final AppLanguageRepository _languageRepository;
  final HttpClient _httpClient;

  Future<SearchPageData?> search({required String query, required int page, int perPage = 24}) async {
    final locale = await _resolveApiLocaleCode();
    final uri = Uri.https('flathub.org', '/api/v2/search', {'locale': locale});

    final payload = <String, dynamic>{'query': query, 'page': page, 'hits_per_page': perPage};

    final response = await _postJson(uri, payload);
    if (response == null) {
      return null;
    }

    final hits = response['hits'];
    if (hits is! List) {
      return null;
    }

    final apps = hits
        .map((item) => item is Map<String, dynamic> ? SearchAppData.fromJson(item) : null)
        .whereType<SearchAppData>()
        .toList(growable: false);

    return SearchPageData(
      query: _asString(response['query']) ?? query,
      page: _asInt(response['page']) ?? page,
      perPage: _asInt(response['hitsPerPage']) ?? perPage,
      totalPages: _asInt(response['totalPages']) ?? 1,
      totalHits: _asInt(response['totalHits']) ?? apps.length,
      apps: apps,
    );
  }

  Future<Map<String, dynamic>?> _postJson(Uri uri, Map<String, dynamic> payload) async {
    try {
      final request = await _httpClient.postUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.write(jsonEncode(payload));

      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
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

  int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '');
  }

  String? _asString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    return null;
  }
}
