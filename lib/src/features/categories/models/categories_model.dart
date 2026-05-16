


import 'package:flutter/material.dart';

class CategoryAppData {
  const CategoryAppData({
    required this.id,
    required this.name,
    required this.publisher,
    required this.rating,
    required this.ratingCountLabel,
    required this.downloadsLabel,
    required this.categoryLabel,
    required this.icon,
    required this.iconBackground,
    required this.tagline,
    required this.about,
    required this.version,
    required this.size,
    required this.license,
    required this.flatpakId,
    this.verified = true,
  });

  final String id;
  final String name;
  final String publisher;
  final double rating;
  final String ratingCountLabel;
  final String downloadsLabel;
  final String categoryLabel;
  final IconData icon;
  final Color iconBackground;
  final String tagline;
  final String about;
  final String version;
  final String size;
  final String license;
  final String flatpakId;
  final bool verified;
}

class CategoryData {
  const CategoryData({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.apps,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<CategoryAppData> apps;

  int get appCount => apps.length;
}