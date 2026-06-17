class SearchAppData {
  const SearchAppData({
    required this.appId,
    required this.name,
    required this.summary,
    required this.publisher,
    required this.verified,
    this.iconUrl,
    this.mainCategory,
    this.installsLastMonth,
  });

  final String appId;
  final String name;
  final String summary;
  final String publisher;
  final bool verified;
  final String? iconUrl;
  final String? mainCategory;
  final int? installsLastMonth;

  static SearchAppData? fromJson(Map<String, dynamic> json) {
    final appId = _asString(json['app_id']) ?? _asString(json['id']);
    final name = _asString(json['name']);
    if (appId == null || name == null) {
      return null;
    }

    return SearchAppData(
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

  static String? _extractMainCategory(dynamic value) {
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

  static String? _asString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    return null;
  }

  static int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '');
  }
}

class SearchPageData {
  const SearchPageData({
    required this.query,
    required this.page,
    required this.perPage,
    required this.totalPages,
    required this.totalHits,
    required this.apps,
  });

  final String query;
  final int page;
  final int perPage;
  final int totalPages;
  final int totalHits;
  final List<SearchAppData> apps;
}
