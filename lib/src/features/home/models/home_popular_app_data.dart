enum HomePopularCollection {
  popular,
  trending,
  favorites;

  String get apiPath {
    switch (this) {
      case HomePopularCollection.popular:
        return 'popular';
      case HomePopularCollection.trending:
        return 'trending';
      case HomePopularCollection.favorites:
        return 'favorites';
    }
  }

  String get label {
    switch (this) {
      case HomePopularCollection.popular:
        return 'Mais populares';
      case HomePopularCollection.trending:
        return 'Em ascensão';
      case HomePopularCollection.favorites:
        return 'Mais favoritados';
    }
  }

  String get description {
    switch (this) {
      case HomePopularCollection.popular:
        return 'Ranking por instalações no último mês.';
      case HomePopularCollection.trending:
        return 'Apps com maior crescimento recente de instalações.';
      case HomePopularCollection.favorites:
        return 'Apps com mais marcações de favorito.';
    }
  }
}

class HomePopularAppData {
  const HomePopularAppData({
    required this.appId,
    required this.name,
    required this.summary,
    required this.developerName,
    required this.iconUrl,
    required this.mainCategory,
    required this.verified,
    this.installsLastMonth,
    this.favoritesCount,
    this.trendingScore,
    this.isMobileFriendly,
  });

  final String appId;
  final String name;
  final String summary;
  final String developerName;
  final String? iconUrl;
  final String? mainCategory;
  final bool verified;
  final int? installsLastMonth;
  final int? favoritesCount;
  final double? trendingScore;
  final bool? isMobileFriendly;

  static HomePopularAppData? fromJson(Map<String, dynamic> json) {
    final appId = _asString(json['app_id']) ?? _asString(json['id']);
    final name = _asString(json['name']);
    if (appId == null || name == null) {
      return null;
    }

    return HomePopularAppData(
      appId: appId,
      name: name,
      summary: _asString(json['summary']) ?? '',
      developerName: _asString(json['developer_name']) ?? 'Desenvolvedor desconhecido',
      iconUrl: _asString(json['icon']),
      mainCategory: _asString(json['main_categories']),
      verified: json['verification_verified'] == true,
      installsLastMonth: _asInt(json['installs_last_month']),
      favoritesCount: _asInt(json['favorites_count']),
      trendingScore: _asDouble(json['trending']),
      isMobileFriendly: json['isMobileFriendly'] is bool ? json['isMobileFriendly'] as bool : null,
    );
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

  static double? _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '');
  }
}

class HomePopularCollectionPageData {
  const HomePopularCollectionPageData({
    required this.collection,
    required this.page,
    required this.perPage,
    required this.totalPages,
    required this.totalHits,
    required this.apps,
  });

  final HomePopularCollection collection;
  final int page;
  final int perPage;
  final int totalPages;
  final int totalHits;
  final List<HomePopularAppData> apps;
}
