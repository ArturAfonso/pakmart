import 'dart:io';

import 'package:pakmart/src/features/installed/repositories/installation_discovery_service.dart';
import 'package:pakmart/src/features/installed/repositories/installed_app_inventory_service.dart';



class LocalAppMetadata {
  const LocalAppMetadata({
    required this.appId,
    required this.installationLabel,
    required this.installationKind,
    required this.installationPath,
    required this.resolvedActivePath,
    required this.name,
    required this.summary,
    required this.description,
    required this.iconPath,
    required this.version,
    required this.license,
    required this.branch,
    required this.runtime,
    required this.command,
    required this.diagnostics,
  });

  final String appId;
  final String installationLabel;
  final InstallationKind installationKind;
  final String installationPath;
  final String? resolvedActivePath;
  final String name;
  final String? summary;
  final String? description;
  final String? iconPath;
  final String? version;
  final String? license;
  final String? branch;
  final String? runtime;
  final String? command;
  final List<String> diagnostics;
}

class LocalMetadataReader {
  const LocalMetadataReader();

  Future<List<LocalAppMetadata>> resolveMetadataForInventory(
    List<InstalledAppInventoryEntry> entries,
  ) async {
    final metadata = <LocalAppMetadata>[];

    for (final entry in entries) {
      if (!entry.isHealthy || entry.resolvedActivePath == null) {
        final diagnosticCopy = [...entry.diagnostics, 'skipped-unhealthy'];
        metadata.add(
          LocalAppMetadata(
            appId: entry.appId,
            installationLabel: entry.installationLabel,
            installationKind: entry.installationKind,
            installationPath: entry.installationPath,
            resolvedActivePath: entry.resolvedActivePath,
            name: entry.appId,
            summary: null,
            description: null,
            iconPath: null,
            version: null,
            license: null,
            branch: null,
            runtime: null,
            command: null,
            diagnostics: List.unmodifiable(diagnosticCopy),
          ),
        );
        continue;
      }

      metadata.add(
        await _resolveMetadataForEntry(entry),
      );
    }

    return metadata;
  }

  Future<LocalAppMetadata> _resolveMetadataForEntry(
    InstalledAppInventoryEntry entry,
  ) async {
    final diagnostics = <String>[...entry.diagnostics];
    final activePath = entry.resolvedActivePath!;

    String name = entry.appId;
    String? summary;
    String? description;
    String? iconPath;
    String? version;
    String? license;
    String? branch;
    String? runtime;
    String? command;

    final metadataData = await _readMetadataFile(activePath);
    if (metadataData != null) {
      branch = metadataData['branch'];
      runtime = metadataData['runtime'];
      command = metadataData['command'];
      version = metadataData['version'];
      license = metadataData['license'];
    } else {
      diagnostics.add('metadata-file-not-read');
    }

    final metainfoData = await _readMetainfoFile(activePath, entry.appId);
    if (metainfoData != null) {
      name = metainfoData['name'] ?? name;
      summary = metainfoData['summary'];
      description = metainfoData['description'];
      iconPath = metainfoData['iconPath'];
      license = metainfoData['license'] ?? license;
    }

    final desktopData = await _readDesktopFile(activePath, entry.appId);
    if (desktopData != null) {
      name = desktopData['name'] ?? name;
      summary = desktopData['comment'] ?? summary;
      final iconReference = desktopData['icon'];
      if (iconReference != null) {
        iconPath = await _resolveIconReference(activePath, iconReference) ?? iconPath;
      }
    }

    iconPath ??= await _findIconFallback(activePath);

    return LocalAppMetadata(
      appId: entry.appId,
      installationLabel: entry.installationLabel,
      installationKind: entry.installationKind,
      installationPath: entry.installationPath,
      resolvedActivePath: activePath,
      name: name,
      summary: summary,
      description: description,
      iconPath: iconPath,
      version: version,
      license: license,
      branch: branch,
      runtime: runtime,
      command: command,
      diagnostics: List.unmodifiable(diagnostics),
    );
  }

  Future<Map<String, String>?> _readMetadataFile(String activePath) async {
    try {
      final metadataFile = File(_joinPath(activePath, 'metadata'));
      if (!await metadataFile.exists()) {
        return null;
      }

      final lines = await metadataFile.readAsLines();
      final data = <String, String>{};
      String? currentSection;

      for (final rawLine in lines) {
        final line = rawLine.trim();

        if (line.isEmpty || line.startsWith(';')) {
          continue;
        }

        if (line.startsWith('[') && line.endsWith(']')) {
          currentSection = line.substring(1, line.length - 1).toLowerCase();
          continue;
        }

        if (!line.contains('=')) {
          continue;
        }

        final separatorIndex = line.indexOf('=');
        final key = line.substring(0, separatorIndex).trim().toLowerCase();
        final value = line.substring(separatorIndex + 1).trim();

        if (value.isEmpty) {
          continue;
        }

        if (currentSection == 'application') {
          if (key == 'name') {
            data['appId'] = value;
          } else if (key == 'version') {
            data['version'] = value;
          } else if (key == 'runtime-version') {
            data['branch'] = value;
          }
        } else if (currentSection == 'runtime') {
          if (key == 'name') {
            data['runtime'] = value;
          }
        } else if (key == 'command' && currentSection == 'application') {
          data['command'] = value;
        }
      }

      return data.isNotEmpty ? data : null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, String>?> _readMetainfoFile(String activePath, String appId) async {
    try {
      final shareDir = await _firstExistingDirectory(activePath, const [
        'files/share/metainfo',
        'export/share/metainfo',
      ]);
      if (shareDir == null) {
        return null;
      }

      final entities = await shareDir.list(followLinks: false).toList();
      final candidates = entities
          .whereType<File>()
          .where((f) => f.path.endsWith('.metainfo.xml') || f.path.endsWith('.appdata.xml'))
          .toList(growable: false);

      if (candidates.isEmpty) {
        return null;
      }

      final preferredMetainfo = '$appId.metainfo.xml';
      final preferredAppdata = '$appId.appdata.xml';
      final metainfoFile = candidates.firstWhere(
        (f) => _basename(f.path) == preferredMetainfo || _basename(f.path) == preferredAppdata,
        orElse: () => candidates.first,
      );

      if (metainfoFile.path.isEmpty || !await metainfoFile.exists()) {
        return null;
      }

      final content = await metainfoFile.readAsString();
      return _parseMetainfoXml(content, activePath);
    } catch (_) {
      return null;
    }
  }

  Map<String, String> _parseMetainfoXml(String content, String activePath) {
    final data = <String, String>{};

    final nameMatch = RegExp(r'<name[^>]*>([^<]+)</name>').firstMatch(content);
    if (nameMatch != null) {
      data['name'] = nameMatch.group(1)?.trim() ?? '';
    }

    final summaryMatch = RegExp(r'<summary[^>]*>([^<]+)</summary>').firstMatch(content);
    if (summaryMatch != null) {
      data['summary'] = summaryMatch.group(1)?.trim() ?? '';
    }

    final descriptionMatch = RegExp(r'<description[^>]*>([^<]+)</description>').firstMatch(content);
    if (descriptionMatch != null) {
      final desc = descriptionMatch.group(1)?.trim() ?? '';
      data['description'] = desc.replaceAll(RegExp(r'\s+'), ' ');
    }

    final licenseMatch = RegExp(r'<metadata_license>([^<]+)</metadata_license>').firstMatch(content);
    if (licenseMatch != null) {
      data['license'] = licenseMatch.group(1)?.trim() ?? '';
    }

    final iconMatch = RegExp(r'<icon[^>]*type="[^"]*">([^<]+)</icon>').firstMatch(content);
    if (iconMatch != null) {
      final iconName = iconMatch.group(1)?.trim();
      if (iconName != null && iconName.isNotEmpty) {
        final iconPath = _findIconByName(activePath, iconName);
        if (iconPath != null) {
          data['iconPath'] = iconPath;
        }
      }
    }

    return data;
  }

  Future<Map<String, String>?> _readDesktopFile(String activePath, String appId) async {
    try {
      final applicationsDir = await _firstExistingDirectory(activePath, const [
        'files/share/applications',
        'export/share/applications',
      ]);
      if (applicationsDir == null) {
        return null;
      }

      final desktopFileName = '$appId.desktop';
      final desktopFile = File(_joinPath(applicationsDir.path, desktopFileName));

      if (await desktopFile.exists()) {
        return _parseDesktopFile(await desktopFile.readAsLines());
      }

      final desktopCandidates = await applicationsDir
          .list(followLinks: false)
          .where((entity) => entity is File && entity.path.endsWith('.desktop'))
          .cast<File>()
          .toList();

      for (final candidate in desktopCandidates) {
        final parsed = _parseDesktopFile(await candidate.readAsLines());
        if (parsed == null) {
          continue;
        }

        if (parsed['x-flatpak'] == appId || parsed['startupwmclass'] == appId) {
          return parsed;
        }

        final candidateName = _basename(candidate.path).replaceAll('.desktop', '');
        if (candidateName == appId) {
          return parsed;
        }
      }

      for (final candidate in desktopCandidates) {
        final parsed = _parseDesktopFile(await candidate.readAsLines());
        if (parsed != null) {
          return parsed;
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Map<String, String>? _parseDesktopFile(List<String> lines) {
    final data = <String, String>{};
    bool inDesktopEntry = false;

    for (final rawLine in lines) {
      final line = rawLine.trim();

      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }

      if (line.startsWith('[') && line.endsWith(']')) {
        inDesktopEntry = line.toLowerCase() == '[desktop entry]';
        continue;
      }

      if (!inDesktopEntry || !line.contains('=')) {
        continue;
      }

      final separatorIndex = line.indexOf('=');
      final key = line.substring(0, separatorIndex).trim().toLowerCase();
      final value = line.substring(separatorIndex + 1).trim();

      if (value.isEmpty) {
        continue;
      }

      if (key == 'name') {
        data['name'] = value;
      } else if (key.startsWith('name[') && !data.containsKey('name')) {
        data['name'] = value;
      } else if (key == 'comment') {
        data['comment'] = value;
      } else if (key.startsWith('comment[') && !data.containsKey('comment')) {
        data['comment'] = value;
      } else if (key == 'icon') {
        data['icon'] = value;
      } else if (key == 'x-flatpak') {
        data['x-flatpak'] = value;
      } else if (key == 'startupwmclass') {
        data['startupwmclass'] = value;
      }
    }

    return data.isNotEmpty ? data : null;
  }

  Future<String?> _findIconFallback(String activePath) async {
    try {
      final iconRoots = _iconRootsForActivePath(activePath);

      final allCandidates = <String>[];
      for (final root in iconRoots) {
        allCandidates.addAll(await _collectImageFiles(root));
      }

      return _pickBestIcon(allCandidates);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _resolveIconReference(String activePath, String iconRef) async {
    final cleaned = iconRef.trim().replaceAll('"', '');
    final normalized = cleaned.split(';').first.trim();
    if (normalized.isEmpty) {
      return null;
    }

    if (normalized.startsWith('/')) {
      final absolute = File(normalized);
      if (await absolute.exists()) {
        return absolute.path;
      }
      return null;
    }

    if (normalized.contains('/')) {
      final relativeCandidates = [
        _joinPath(activePath, 'export/share/icons/$normalized'),
        _joinPath(activePath, 'files/share/icons/$normalized'),
        _joinPath(activePath, 'files/share/$normalized'),
      ];

      final installationRoot = _installationRootFromActivePath(activePath);
      if (installationRoot != null) {
        relativeCandidates.add(_joinPath(installationRoot, 'exports/share/icons/$normalized'));
      }

      for (final path in relativeCandidates) {
        final file = File(path);
        if (await file.exists()) {
          return file.path;
        }
      }
    }

    return _findIconByName(activePath, normalized);
  }

  String? _findIconByName(String activePath, String iconName) {
    try {
      final iconRoots = _iconRootsForActivePath(activePath);

      final lowercaseRef = iconName.toLowerCase();

      final matches = <String>[];

      for (final root in iconRoots) {
        final dir = Directory(root);
        if (!dir.existsSync()) {
          continue;
        }

        final entities = dir.listSync(recursive: true, followLinks: false);
        for (final entity in entities) {
          if (entity is! File) {
            continue;
          }
          final baseName = _basename(entity.path).toLowerCase();
          if (!_isImageFileName(baseName)) {
            continue;
          }

          final withoutExt = baseName.contains('.')
              ? baseName.substring(0, baseName.lastIndexOf('.'))
              : baseName;

          if (withoutExt == lowercaseRef || withoutExt.startsWith('$lowercaseRef-') || baseName.startsWith('$lowercaseRef.')) {
            matches.add(entity.absolute.path);
          }
        }
      }

      return _pickBestIcon(matches);
    } catch (_) {
      return null;
    }
  }

  String _joinPath(String left, String right) {
    final normalizedLeft = left.endsWith('/') ? left.substring(0, left.length - 1) : left;
    final normalizedRight = right.startsWith('/') ? right.substring(1) : right;
    return '$normalizedLeft/$normalizedRight';
  }

  String _basename(String path) {
    if (path.isEmpty) {
      return '';
    }

    final normalized = path.endsWith('/') && path.length > 1 ? path.substring(0, path.length - 1) : path;
    final index = normalized.lastIndexOf('/');
    if (index < 0 || index + 1 >= normalized.length) {
      return normalized;
    }

    return normalized.substring(index + 1);
  }

  Future<Directory?> _firstExistingDirectory(String activePath, List<String> candidates) async {
    for (final candidate in candidates) {
      final dir = Directory(_joinPath(activePath, candidate));
      if (await dir.exists()) {
        return dir;
      }
    }
    return null;
  }

  Future<List<String>> _collectImageFiles(String rootPath) async {
    final dir = Directory(rootPath);
    if (!await dir.exists()) {
      return const [];
    }

    final files = <String>[];
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is! File) {
        continue;
      }

      final name = _basename(entity.path).toLowerCase();
      if (_isImageFileName(name)) {
        files.add(entity.absolute.path);
      }
    }

    return files;
  }

  bool _isImageFileName(String fileName) {
    return fileName.endsWith('.png') || fileName.endsWith('.svg') || fileName.endsWith('.jpg') || fileName.endsWith('.jpeg');
  }

  String? _pickBestIcon(List<String> candidates) {
    if (candidates.isEmpty) {
      return null;
    }

    final sorted = [...candidates]..sort((a, b) => _scoreIconPath(b).compareTo(_scoreIconPath(a)));
    return sorted.first;
  }

  int _scoreIconPath(String iconPath) {
    final lower = iconPath.toLowerCase();
    int score = 0;

    if (lower.endsWith('.png')) {
      score += 40;
    } else if (lower.endsWith('.svg')) {
      score += 30;
    } else {
      score += 10;
    }

    if (lower.contains('/scalable/')) {
      score += 25;
    }

    if (lower.contains('/symbolic/')) {
      score -= 15;
    }

    final sizeMatch = RegExp(r'/([0-9]{2,4})x([0-9]{2,4})/').firstMatch(lower);
    if (sizeMatch != null) {
      final size = int.tryParse(sizeMatch.group(1) ?? '0') ?? 0;
      score += size ~/ 8;
    }

    return score;
  }

  List<String> _iconRootsForActivePath(String activePath) {
    final roots = <String>{
      _joinPath(activePath, 'export/share/icons'),
      _joinPath(activePath, 'files/share/icons'),
      _joinPath(activePath, 'files/share/pixmaps'),
      _joinPath(activePath, 'export/share/pixmaps'),
    };

    final installationRoot = _installationRootFromActivePath(activePath);
    if (installationRoot != null) {
      roots.add(_joinPath(installationRoot, 'exports/share/icons'));
      roots.add(_joinPath(installationRoot, 'exports/share/pixmaps'));
    }

    final home = Platform.environment['HOME'];
    if (home != null && home.isNotEmpty) {
      roots.add('$home/.local/share/flatpak/exports/share/icons');
      roots.add('$home/.local/share/flatpak/exports/share/pixmaps');
    }

    roots.add('/var/lib/flatpak/exports/share/icons');
    roots.add('/var/lib/flatpak/exports/share/pixmaps');

    return roots.toList(growable: false);
  }

  String? _installationRootFromActivePath(String activePath) {
    final marker = '/app/';
    final index = activePath.indexOf(marker);
    if (index <= 0) {
      return null;
    }

    return activePath.substring(0, index);
  }
}