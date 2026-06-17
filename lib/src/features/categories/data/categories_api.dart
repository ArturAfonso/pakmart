import 'dart:convert';
import 'dart:io';

import 'package:pakmart/src/core/locale/app_language_repository.dart';
import 'package:pakmart/src/features/categories/models/category_remote_models.dart';

class CategoriesApi {
  CategoriesApi(this._languageRepository, {HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  final AppLanguageRepository _languageRepository;
  final HttpClient _httpClient;

  Future<List<String>> fetchCategories() async {
    final uri = Uri.parse('https://flathub.org/api/v2/collection/category');
    final response = await _getJson(uri);
    if (response is! List) {
      return const <String>[];
    }

    return response.whereType<String>().map((item) => item.trim()).where((item) => item.isNotEmpty).toList(growable: false);
  }

  Future<CategoryAppsPageData?> fetchCategoryApps({
    required String category,
    required int page,
    int perPage = 24,
    CategorySortBy? sortBy,
  }) async {
    final locale = await _resolveApiLocaleCode();
    final query = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
      'locale': locale,
    };
    if (sortBy != null) {
      query['sort_by'] = sortBy.apiValue;
    }

    final uri = Uri.https('flathub.org', '/api/v2/collection/category/${Uri.encodeComponent(category)}', query);
    final response = await _getJson(uri);
    if (response is! Map<String, dynamic>) {
      return null;
    }

    final hits = response['hits'];
    if (hits is! List) {
      return null;
    }

    final apps = hits.map((item) => item is Map<String, dynamic> ? _mapApp(item) : null).whereType<CategoryShelfAppData>().toList(growable: false);

    return CategoryAppsPageData(
      page: _asInt(response['page']) ?? page,
      perPage: _asInt(response['hitsPerPage']) ?? perPage,
      totalPages: _asInt(response['totalPages']) ?? 1,
      totalHits: _asInt(response['totalHits']) ?? apps.length,
      apps: apps,
    );
  }

  CategoryShelfAppData? _mapApp(Map<String, dynamic> json) {
    final appId = _asString(json['app_id']);
    final name = _asString(json['name']);
    if (appId == null || name == null) {
      return null;
    }

    return CategoryShelfAppData(
      appId: appId,
      name: name,
      summary: _asString(json['summary']) ?? 'Sem resumo disponível.',
      publisher: _asString(json['developer_name']) ?? 'Desenvolvedor desconhecido',
      verified: json['verification_verified'] == true,
      iconUrl: _asString(json['icon']),
      mainCategory: _extractMainCategory(json['main_categories']),
      installsLastMonth: _asInt(json['installs_last_month']),
    );
  }

  String? _extractMainCategory(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    if (value is List) {
      for (final item in value) {
        if (item is String && item.trim().isNotEmpty) {
          return item.trim();
        }
      }
    }

    return null;
  }

  Future<dynamic> _getJson(Uri uri) async {
    try {
      final request = await _httpClient.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final payload = await response.transform(utf8.decoder).join();
      return jsonDecode(payload);
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
