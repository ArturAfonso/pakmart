import 'package:flutter/material.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/features/apps/data/app_info_api.dart';
import 'package:pakmart/src/features/apps/models/app_detail_data.dart';

enum AppInfoLoadFailureReason { notFound, offline, server, invalidData, unknown }

class AppInfoLoadException implements Exception {
  const AppInfoLoadException(this.reason);

  final AppInfoLoadFailureReason reason;
}

class AppInfoRepository {
  AppInfoRepository(this._api);

  final AppInfoApi _api;

  Future<AppDetailData?> loadDetail(String routeAppId) async {
    final remoteAppId = routeAppId;

    FlathubAppInfo? info;
    try {
      info = await _api.fetchAppstream(remoteAppId);
    } catch (error) {
      throw AppInfoLoadException(_mapApiError(error));
    }

    final summary = await _safeFetchSummary(remoteAppId);
    final stats = await _safeFetchStats(remoteAppId);

    if (info == null || info.id.trim().isEmpty || info.name.trim().isEmpty) {
      throw const AppInfoLoadException(AppInfoLoadFailureReason.invalidData);
    }

    return _fromRemote(routeAppId: routeAppId, remoteAppId: remoteAppId, info: info, summary: summary, stats: stats);
  }

  Future<Map<String, dynamic>?> _safeFetchSummary(String appId) async {
    try {
      return await _api.fetchSummary(appId);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _safeFetchStats(String appId) async {
    try {
      return await _api.fetchStats(appId);
    } catch (_) {
      return null;
    }
  }

  AppInfoLoadFailureReason _mapApiError(Object error) {
    if (error is AppInfoApiNetworkException) {
      return AppInfoLoadFailureReason.offline;
    }

    if (error is AppInfoApiMalformedResponseException) {
      return AppInfoLoadFailureReason.invalidData;
    }

    if (error is AppInfoApiHttpException) {
      if (error.statusCode == 404) {
        return AppInfoLoadFailureReason.notFound;
      }
      if (error.statusCode >= 500) {
        return AppInfoLoadFailureReason.server;
      }
      return AppInfoLoadFailureReason.unknown;
    }

    return AppInfoLoadFailureReason.unknown;
  }

  AppDetailData _fromRemote({
    required String routeAppId,
    required String remoteAppId,
    required FlathubAppInfo info,
    required Map<String, dynamic>? summary,
    required Map<String, dynamic>? stats,
  }) {
    final release = _pickLatestRelease(info.releases);
    final summaryMetadata = _asMap(summary?['metadata']);
    final gradient = _resolveHeroGradient(info);

    return AppDetailData(
      routeAppId: routeAppId,
      appId: info.id,
      name: info.name,
      developerName: _sanitizeText(info.developerName) ?? 'Desenvolvedor desconhecido',
      tagline: _sanitizeText(info.summary) ?? _sanitizeText(info.description) ?? 'Aplicativo disponivel no Flathub.',
      description:
          _sanitizeDescription(info.description) ?? 'Nenhuma descricao detalhada disponivel para este aplicativo.',
      fallbackIcon: null,
      iconUrl: _chooseIconUrl(info),
      iconBackground: _resolveBackgroundColor(info),
      hasRemoteData: true,
      heroGradientStart: gradient.$1,
      heroGradientEnd: gradient.$2,
      verified: _isVerified(info),
      isMobileFriendly: info.isMobileFriendly ?? false,
      supportsDesktop: _supportsDesktop(info),
      version: _sanitizeText(release?.version),
      license: _sanitizeText(info.projectLicense),
      categoryLabel: _resolveCategoryLabel(info.categories),
      downloadSizeLabel: _formatBytes(_asInt(summary?['download_size'])),
      installedSizeLabel: _formatBytes(_asInt(summary?['installed_size'])),
      runtimeInstalledSizeLabel: _formatBytes(_asInt(summaryMetadata?['runtimeInstalledSize'])),
      runtimeName: _sanitizeText(_asString(summaryMetadata?['runtimeName'])) ?? info.bundle?.runtime,
      latestReleaseVersion: _sanitizeText(release?.version),
      latestReleaseDescription: _sanitizeDescription(release?.description),
      downloadsLastMonth: _asInt(stats?['installs_last_month']) ?? _asInt(stats?['downloads_last_month']),
      totalInstalls: _asInt(stats?['installs_total']),
      flatpakRef: info.bundle?.value ?? remoteAppId,
      screenshots: _mapScreenshots(info.screenshots),
      links: _mapLinks(info.urls),
    );
  }

  List<AppDetailScreenshotData> _mapScreenshots(List<FlathubScreenshot>? screenshots) {
    if (screenshots == null || screenshots.isEmpty) {
      return const <AppDetailScreenshotData>[];
    }

    final sorted = List<FlathubScreenshot>.from(screenshots)
      ..sort((a, b) {
        final aScore = (a.isDefault ?? false) ? 1 : 0;
        final bScore = (b.isDefault ?? false) ? 1 : 0;
        return bScore.compareTo(aScore);
      });

    final items = <AppDetailScreenshotData>[];
    for (final screenshot in sorted) {
      final bestSize = _pickScreenshotSize(screenshot.sizes);
      if (bestSize == null || bestSize.src.isEmpty) {
        continue;
      }

      items.add(
        AppDetailScreenshotData(
          imageUrl: bestSize.src,
          caption: _sanitizeText(screenshot.caption),
          width: int.tryParse(bestSize.width),
          height: int.tryParse(bestSize.height),
        ),
      );
    }

    return items;
  }

  List<AppDetailLinkData> _mapLinks(Map<String, dynamic>? urls) {
    if (urls == null || urls.isEmpty) {
      return const <AppDetailLinkData>[];
    }

    const orderedKeys = <(String, String)>[
      ('homepage', 'Site oficial'),
      ('help', 'Ajuda'),
      ('bugtracker', 'Relatar problema'),
      ('vcs_browser', 'Codigo-fonte'),
      ('translate', 'Traduzir'),
      ('donation', 'Apoiar projeto'),
      ('contribute', 'Contribuir'),
      ('contact', 'Contato'),
    ];

    final links = <AppDetailLinkData>[];
    for (final entry in orderedKeys) {
      final rawUrl = urls[entry.$1];
      final url = _asString(rawUrl);
      if (url == null || !url.startsWith('http')) {
        continue;
      }

      links.add(AppDetailLinkData(label: entry.$2, url: url));
    }

    return links;
  }

  FlathubRelease? _pickLatestRelease(List<FlathubRelease>? releases) {
    if (releases == null || releases.isEmpty) {
      return null;
    }

    for (final release in releases) {
      if ((release.version ?? '').trim().isNotEmpty) {
        return release;
      }
    }

    return releases.first;
  }

  FlathubScreenshotSize? _pickScreenshotSize(List<FlathubScreenshotSize> sizes) {
    if (sizes.isEmpty) {
      return null;
    }

    final sorted = List<FlathubScreenshotSize>.from(sizes)
      ..sort((a, b) {
        final aArea = (int.tryParse(a.width) ?? 0) * (int.tryParse(a.height) ?? 0);
        final bArea = (int.tryParse(b.width) ?? 0) * (int.tryParse(b.height) ?? 0);
        if (aArea == bArea) {
          return (int.tryParse(b.scale) ?? 1).compareTo(int.tryParse(a.scale) ?? 1);
        }
        return bArea.compareTo(aArea);
      });

    return sorted.first;
  }

  String? _chooseIconUrl(FlathubAppInfo info) {
    final direct = info.icon;
    if (direct != null && direct.isNotEmpty) {
      return direct;
    }

    final icons = info.icons;
    if (icons == null || icons.isEmpty) {
      return null;
    }

    final sorted = List<FlathubIcon>.from(icons)
      ..sort((a, b) {
        final aArea = a.width * a.height * (a.scale ?? 1);
        final bArea = b.width * b.height * (b.scale ?? 1);
        return bArea.compareTo(aArea);
      });

    return sorted.first.url;
  }

  Color _resolveBackgroundColor(FlathubAppInfo info) {
    final branding = info.branding;
    if (branding != null) {
      for (final item in branding) {
        if (item.type != 'primary') {
          continue;
        }

        final color = _parseHexColor(item.value);
        if (color != null) {
          return color.withValues(alpha: 0.2);
        }
      }
    }

    return AppColors.input;
  }

  (Color?, Color?) _resolveHeroGradient(FlathubAppInfo info) {
    final branding = info.branding;
    if (branding == null || branding.isEmpty) {
      return (null, null);
    }

    Color? lightPrimary;
    Color? darkPrimary;

    for (final item in branding) {
      if (item.type != 'primary') {
        continue;
      }

      final color = _parseHexColor(item.value);
      if (color == null) {
        continue;
      }

      final scheme = item.schemePreference?.toLowerCase();
      if (scheme == 'light' && lightPrimary == null) {
        lightPrimary = color;
      }

      if (scheme == 'dark' && darkPrimary == null) {
        darkPrimary = color;
      }

      if (scheme == null && lightPrimary == null) {
        lightPrimary = color;
      }
    }

    return (lightPrimary ?? darkPrimary, darkPrimary ?? lightPrimary);
  }

  Color? _parseHexColor(String hex) {
    final sanitized = hex.replaceFirst('#', '').trim();
    if (sanitized.length != 6 && sanitized.length != 8) {
      return null;
    }

    final withAlpha = sanitized.length == 6 ? 'FF$sanitized' : sanitized;
    final value = int.tryParse(withAlpha, radix: 16);
    if (value == null) {
      return null;
    }

    return Color(value);
  }

  bool _isVerified(FlathubAppInfo info) {
    final metadata = info.metadata;
    if (metadata == null || metadata.isEmpty) {
      return false;
    }

    final direct = metadata['flathub::verification::verified'];
    if (direct is bool) {
      return direct;
    }
    if (direct is String) {
      final value = direct.toLowerCase();
      return value == 'true' || value == '1' || value == 'yes';
    }

    return metadata.keys.any((key) => key.toLowerCase().contains('verification'));
  }

  bool _supportsDesktop(FlathubAppInfo info) {
    final type = info.type.toLowerCase();
    return type.contains('desktop') || type.contains('application');
  }

  String? _resolveCategoryLabel(List<String>? categories) {
    if (categories == null || categories.isEmpty) {
      return null;
    }

    return _humanize(categories.first);
  }

  String? _formatBytes(int? bytes) {
    if (bytes == null || bytes <= 0) {
      return null;
    }

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var value = bytes.toDouble();
    var unitIndex = 0;

    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex += 1;
    }

    final decimalDigits = value >= 100 || unitIndex == 0 ? 0 : 1;
    return '${value.toStringAsFixed(decimalDigits)} ${units[unitIndex]}';
  }

  int? _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  String? _asString(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  String? _sanitizeText(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    var text = raw.replaceAll(RegExp(r'<[^>]*>'), ' ');
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', "'");
    text = text.replaceAll('&lt;', '<');
    text = text.replaceAll('&gt;', '>');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text.isEmpty ? null : text;
  }

  String? _sanitizeDescription(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    var text = raw;
    text = text.replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), '\n');
    text = text.replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n');
    text = text.replaceAll(RegExp(r'<li>', caseSensitive: false), '• ');
    text = text.replaceAll(RegExp(r'</li>', caseSensitive: false), '\n');
    text = text.replaceAll(RegExp(r'<[^>]*>'), ' ');
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', "'");
    text = text.replaceAll('&lt;', '<');
    text = text.replaceAll('&gt;', '>');
    text = text.replaceAll(RegExp(r'\n\s+'), '\n');
    text = text.replaceAll(RegExp(r'[ \t]+'), ' ');
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
    return text.isEmpty ? null : text;
  }

  String _humanize(String value) {
    final normalized = value.replaceAll(RegExp(r'[_-]+'), ' ').trim();
    if (normalized.isEmpty) {
      return value;
    }

    return normalized[0].toUpperCase() + normalized.substring(1).toLowerCase();
  }
}
