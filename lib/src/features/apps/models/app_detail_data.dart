import 'package:flutter/material.dart';

class AppDetailData {
  const AppDetailData({
    required this.routeAppId,
    required this.appId,
    required this.name,
    required this.developerName,
    required this.tagline,
    required this.description,
    required this.iconBackground,
    required this.hasRemoteData,
    required this.verified,
    required this.isMobileFriendly,
    required this.supportsDesktop,
    required this.screenshots,
    required this.links,
    this.fallbackIcon,
    this.iconUrl,
    this.heroGradientStart,
    this.heroGradientEnd,
    this.version,
    this.license,
    this.categoryLabel,
    this.downloadSizeLabel,
    this.installedSizeLabel,
    this.runtimeInstalledSizeLabel,
    this.runtimeName,
    this.latestReleaseVersion,
    this.latestReleaseDescription,
    this.downloadsLastMonth,
    this.totalInstalls,
    this.flatpakRef,
  });

  final String routeAppId;
  final String appId;
  final String name;
  final String developerName;
  final String tagline;
  final String description;
  final IconData? fallbackIcon;
  final String? iconUrl;
  final Color iconBackground;
  final bool hasRemoteData;
  final Color? heroGradientStart;
  final Color? heroGradientEnd;
  final bool verified;
  final bool isMobileFriendly;
  final bool supportsDesktop;
  final String? version;
  final String? license;
  final String? categoryLabel;
  final String? downloadSizeLabel;
  final String? installedSizeLabel;
  final String? runtimeInstalledSizeLabel;
  final String? runtimeName;
  final String? latestReleaseVersion;
  final String? latestReleaseDescription;
  final int? downloadsLastMonth;
  final int? totalInstalls;
  final String? flatpakRef;
  final List<AppDetailScreenshotData> screenshots;
  final List<AppDetailLinkData> links;
}

class AppDetailScreenshotData {
  const AppDetailScreenshotData({required this.imageUrl, this.caption, this.width, this.height});

  final String imageUrl;
  final String? caption;
  final int? width;
  final int? height;
}

class AppDetailLinkData {
  const AppDetailLinkData({required this.label, required this.url});

  final String label;
  final String url;
}
