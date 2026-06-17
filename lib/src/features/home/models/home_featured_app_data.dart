import 'package:flutter/material.dart';

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
}
