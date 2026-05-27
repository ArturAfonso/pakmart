import 'package:flutter/material.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';
import 'package:pakmart/src/features/categories/data/categories_data.dart';
import 'package:pakmart/src/features/home/data/home_featured_api.dart';
import 'package:pakmart/src/features/home/models/home_featured_app_data.dart';

class HomeFeaturedRepository {
  HomeFeaturedRepository(this._api);

  final HomeFeaturedApi _api;

  Future<List<String>> fetchAppsOfTheWeek({DateTime? date}) {
    return _api.fetchAppsOfTheWeek(date: date ?? DateTime.now());
  }

  Future<HomeFeaturedAppData?> fetchFeaturedApp(String appId) async {
    final info = await _api.fetchAppstream(appId);
    if (info == null) {
      return null;
    }

    return _toFeaturedData(info);
  }

  HomeFeaturedAppData _toFeaturedData(FlathubAppInfo info) {
    final mappedLocal = CategoriesData.appById(info.id);
    final iconUrl = _chooseIconUrl(info);
    final gradient = _resolveHeroGradient(info);

    return HomeFeaturedAppData(
      id: info.id,
      name: info.name,
      tagline: _sanitizeText(info.summary) ?? _sanitizeText(info.description) ?? 'Aplicativo em destaque no Flathub.',
      flathubUrl: 'https://flathub.org/apps/${Uri.encodeComponent(info.id)}',
      iconBackground: _resolveBackgroundColor(info),
      heroGradientStart: gradient.$1,
      heroGradientEnd: gradient.$2,
      iconUrl: iconUrl,
      iconData: mappedLocal?.icon ?? Icons.apps_rounded,
      detailRouteAppId: mappedLocal?.id,
    );
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
    if (branding != null && branding.isNotEmpty) {
      for (final item in branding) {
        if (item.type != 'primary') {
          continue;
        }

        final color = _parseHexColor(item.value);
        if (color != null) {
          return color.withValues(alpha: 0.28);
        }
      }
    }

    return const Color(0x334D6475);
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

    final start = lightPrimary ?? darkPrimary;
    final end = darkPrimary ?? lightPrimary;
    return (start, end);
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

  String? _sanitizeText(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    var text = raw.replaceAll(RegExp(r'<[^>]*>'), ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.isEmpty) {
      return null;
    }

    return text;
  }
}
