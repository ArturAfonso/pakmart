import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';
import 'package:pakmart/src/features/installed/data/installed_app_api.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/models/flatpak_app_model.dart';

abstract class InstalledAppsRepository {
  Future<List<InstalledAppData>> getInstalledApps();
}

class InstalledAppsRepositoryImpl implements InstalledAppsRepository {
  InstalledAppsRepositoryImpl(this._api, {HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  final InstalledAppApi _api;
  final HttpClient _httpClient;
  
  @override
  Future<List<InstalledAppData>> getInstalledApps() {
    // TODO: implement getInstalledApps
    throw UnimplementedError();
  }
}














































/* 
abstract class InstalledAppsRepository {
  Future<List<InstalledAppData>> getInstalledApps();
}

class InstalledAppsRepositoryImpl implements InstalledAppsRepository {
  InstalledAppsRepositoryImpl(this._api, {HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  final InstalledAppApi _api;
  final HttpClient _httpClient;

  @override
  /* Future<List<InstalledAppData>> getInstalledApps() async {
    final localApps = await _listInstalledFlatpaks();

    final merged = await Future.wait(localApps.map(_mergeLocalWithFlathub));

    merged.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return merged;
  } */

  Future<List<FlatpakApp>> _listInstalledFlatpaks() async {
    final result = await Process.run('flatpak', [
      'list',
      '--app',
      '--columns=application,name,version,branch,origin,installation',
    ]);

    if (result.exitCode != 0) return const [];

    final output = (result.stdout as String).trim();
    if (output.isEmpty) return const [];

    final apps = <FlatpakApp>[];
    for (final line in output.split('\n')) {
      if (line.trim().isEmpty) continue;
      final cols = line.split('\t');
      if (cols.length < 6) continue;
      apps.add(FlatpakApp.fromList(cols));
    }
    return apps;
  }

  /* Future<InstalledAppData> _mergeLocalWithFlathub(FlatpakApp local) async {
    final flathubFuture = _api.fetchAppInfo(local.application);
    final sizeFuture = _readInstalledSize(local.application);
    final permsFuture = _readPermissionSections(local.application);

    final flathub = await flathubFuture;
    final size = await sizeFuture;
    final permissionSections = await permsFuture;

    final category = _categoryFrom(flathub);
    final description = _plain(flathub?.summary ?? flathub?.description ?? local.name);

    return InstalledAppData(
      id: local.application,
      name: flathub?.name ?? local.name,
      description: description,
      packageName: local.application,
      version: local.version,
      size: size ?? '-',
      icon: await _chooseIconApp(flathub?.icons),
      iconBackground: _iconBgForCategory(category),
      tagline: description,
      license: flathub?.projectLicense ?? 'Desconhecida',
      category: category,
      sandboxLabel: local.installation.toLowerCase() == 'user' ? 'SANDBOXED USER' : 'SANDBOXED SYSTEM',
      permissionSections: permissionSections,
    );
  } */

  Future<String?> _readInstalledSize(String appId) async {
    final result = await Process.run('flatpak', ['info', '--show-size', appId]);
    if (result.exitCode != 0) return null;
    final text = (result.stdout as String).trim();
    return text.isEmpty ? null : text;
  }

  Future<List<InstalledPermissionSectionData>> _readPermissionSections(String appId) async {
    return const [];
  }

  String _categoryFrom(FlathubAppInfo? info) {
    final list = info?.categories;
    if (list == null || list.isEmpty) return 'Outros';
    return list.first;
  }

  String _plain(String value) {
    final noHtml = value.replaceAll(RegExp(r'<[^>]*>'), ' ');
    return noHtml.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<FlathubIcon?> _chooseIconApp(List<FlathubIcon>? icons) async {
    if (icons == null || icons.isEmpty) return null;

    final sorted = [...icons]
      ..sort((a, b) {
        final aScore = a.scale != null ? 1 : 0;
        final bScore = b.scale != null ? 1 : 0;
        return bScore.compareTo(aScore);
      });

    for (final icon in sorted) {
      if (await _isReachableImageUrl(icon.url)) {
        return icon;
      }
    }

    return icons.first;
  }

  Future<bool> _isReachableImageUrl(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) return false;

      final head = await _httpClient.headUrl(uri);
      final headResponse = await head.close();
      final headOk = _isSuccess(headResponse.statusCode);
      final contentType = headResponse.headers.contentType?.mimeType;

      if (headOk && (contentType == null || contentType.startsWith('image/'))) {
        return true;
      }

      if (headResponse.statusCode != HttpStatus.methodNotAllowed) {
        return false;
      }
    } catch (_) {
      // Some CDNs don't support HEAD. Fall through to GET.
    }

    try {
      final uri = Uri.parse(url);
      final get = await _httpClient.getUrl(uri);
      final getResponse = await get.close();
      final contentType = getResponse.headers.contentType?.mimeType;

      final ok = _isSuccess(getResponse.statusCode);
      final isImage = contentType == null || contentType.startsWith('image/');

      await getResponse.drain();
      return ok && isImage;
    } catch (_) {
      return false;
    }
  }

  bool _isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  Color _iconBgForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'development':
      case 'webdevelopment':
        return const Color(0xFFD7F5FF);
      case 'music':
      case 'audio':
        return const Color(0xFFE3E8FF);
      case 'video':
        return const Color(0xFFFFE9D8);
      case 'office':
        return const Color(0xFFFFE3DA);
      case 'communication':
        return const Color(0xFFD9F7FF);
      default:
        return const Color(0xFFEDEDED);
    }
  }
}
 */