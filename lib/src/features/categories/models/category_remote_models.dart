import 'package:flutter/material.dart';

class CategoryShelfData {
  const CategoryShelfData({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
}

class CategoryShelfAppData {
  const CategoryShelfAppData({
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
}

enum CategorySortBy {
  installsLastMonth,
  trending;

  String get apiValue {
    switch (this) {
      case CategorySortBy.installsLastMonth:
        return 'installs_last_month';
      case CategorySortBy.trending:
        return 'trending';
    }
  }

  String get label {
    switch (this) {
      case CategorySortBy.installsLastMonth:
        return 'Mais baixados (mês)';
      case CategorySortBy.trending:
        return 'Em ascensão';
    }
  }
}

class CategoryAppsPageData {
  const CategoryAppsPageData({
    required this.page,
    required this.perPage,
    required this.totalPages,
    required this.totalHits,
    required this.apps,
  });

  final int page;
  final int perPage;
  final int totalPages;
  final int totalHits;
  final List<CategoryShelfAppData> apps;
}
