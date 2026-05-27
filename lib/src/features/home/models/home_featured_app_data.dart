import 'package:flutter/material.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';

class HomeFeaturedAppData {
  const HomeFeaturedAppData({
    required this.id,
    required this.name,
    required this.tagline,
    required this.flathubUrl,
    required this.iconBackground,
    this.heroGradientStart,
    this.heroGradientEnd,
    this.iconData,
    this.iconUrl,
    this.detailRouteAppId,
  });

  final String id;
  final String name;
  final String tagline;
  final String flathubUrl;
  final Color iconBackground;
  final Color? heroGradientStart;
  final Color? heroGradientEnd;
  final IconData? iconData;
  final String? iconUrl;
  final String? detailRouteAppId;

  factory HomeFeaturedAppData.fromCategoryApp(CategoryAppData app) {
    return HomeFeaturedAppData(
      id: app.id,
      name: app.name,
      tagline: app.tagline,
      flathubUrl: 'https://flathub.org/apps/${Uri.encodeComponent(app.flatpakId)}',
      iconBackground: app.iconBackground,
      iconData: app.icon,
      detailRouteAppId: app.id,
    );
  }
}
