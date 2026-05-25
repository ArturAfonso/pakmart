import 'dart:io';

import 'package:pakmart/src/features/installed/repositories/local_metadata_reader.dart';

// Lê metadata base + override global + override por app para calcular permissoes efetivas.

// Estrutura de uma permissao staticacom seus 3 niveis de origem.
class StaticPermission {
  const StaticPermission({
    required this.key,
    required this.base,
    required this.globalOverride,
    required this.appOverride,
    required this.effective,
    required this.origin,
    required this.diagnostics,
  });

  final String key;
  final bool? base;
  final bool? globalOverride;
  final bool? appOverride;
  final bool? effective;
  final PermissionOrigin origin;
  final List<String> diagnostics;
}

// Indica qual arquivo foi lido por ultimo para este valor efetivo.
enum PermissionOrigin { base, globalOverride, appOverride, unset }

// Agrupa todas as permissoes estaticas de um app.
class StaticAppPermissions {
  const StaticAppPermissions({
    required this.appId,
    required this.installationLabel,
    required this.permissions,
    required this.diagnostics,
  });

  final String appId;
  final String installationLabel;
  final List<StaticPermission> permissions;
  final List<String> diagnostics;
}

class StaticPermissionsReader {
  const StaticPermissionsReader();

  // Mapeamento entre chaves exibidas na UI e listas reais da secao [Context]
  // do metadata/override Flatpak.
  static const List<_PermissionSpec> knownPermissions = [
    _PermissionSpec(
      flatKey: 'Context/shared-network',
      contextList: 'shared',
      token: 'network',
    ),
    _PermissionSpec(
      flatKey: 'Context/shared-ipc',
      contextList: 'shared',
      token: 'ipc',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-x11',
      contextList: 'sockets',
      token: 'x11',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-wayland',
      contextList: 'sockets',
      token: 'wayland',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-fallback-x11',
      contextList: 'sockets',
      token: 'fallback-x11',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-pulseaudio',
      contextList: 'sockets',
      token: 'pulseaudio',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-session-dbus',
      contextList: 'sockets',
      token: 'session-dbus',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-system-dbus',
      contextList: 'sockets',
      token: 'system-dbus',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-ssh-auth',
      contextList: 'sockets',
      token: 'ssh-auth',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-pcsc',
      contextList: 'sockets',
      token: 'pcsc',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-cups',
      contextList: 'sockets',
      token: 'cups',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-gpg-agent',
      contextList: 'sockets',
      token: 'gpg-agent',
    ),
    _PermissionSpec(
      flatKey: 'Context/sockets-inherit-wayland-socket',
      contextList: 'sockets',
      token: 'inherit-wayland-socket',
    ),
    _PermissionSpec(
      flatKey: 'Context/devices-dri',
      contextList: 'devices',
      token: 'dri',
    ),
    _PermissionSpec(
      flatKey: 'Context/devices-input',
      contextList: 'devices',
      token: 'input',
    ),
    _PermissionSpec(
      flatKey: 'Context/devices-kvm',
      contextList: 'devices',
      token: 'kvm',
    ),
    _PermissionSpec(
      flatKey: 'Context/devices-shm',
      contextList: 'devices',
      token: 'shm',
    ),
    _PermissionSpec(
      flatKey: 'Context/devices-usb',
      contextList: 'devices',
      token: 'usb',
    ),
    _PermissionSpec(
      flatKey: 'Context/devices-all',
      contextList: 'devices',
      token: 'all',
    ),
    _PermissionSpec(
      flatKey: 'Context/allow-devel',
      contextList: 'features',
      token: 'devel',
    ),
    _PermissionSpec(
      flatKey: 'Context/allow-multiarch',
      contextList: 'features',
      token: 'multiarch',
    ),
    _PermissionSpec(
      flatKey: 'Context/allow-bluetooth',
      contextList: 'features',
      token: 'bluetooth',
    ),
    _PermissionSpec(
      flatKey: 'Context/allow-canbus',
      contextList: 'features',
      token: 'canbus',
    ),
    _PermissionSpec(
      flatKey: 'Context/allow-per-app-dev-shm',
      contextList: 'features',
      token: 'per-app-dev-shm',
    ),
  ];

  Future<List<StaticAppPermissions>> resolveStaticPermissionsForMetadata(
    List<LocalAppMetadata> metadata,
  ) async {
    final staticPermissions = <StaticAppPermissions>[];

    // Lê override global uma vez.
    final globalOverrides = await _readGlobalOverrides();

    for (final app in metadata) {
      staticPermissions.add(
        await _resolvePermissionsForApp(app, globalOverrides),
      );
    }

    return staticPermissions;
  }

  Future<StaticAppPermissions> _resolvePermissionsForApp(
    LocalAppMetadata app,
    Map<String, bool?> globalOverrides,
  ) async {
    final diagnostics = <String>[];
    final permissions = <StaticPermission>[];

    final basePermissions = await _readBasePermissionsFromMetadata(app);
    if (app.resolvedActivePath == null) {
      diagnostics.add('missing-active-path');
    }

    // Lê override por app.
    final appOverrides = await _readAppOverrides(app.appId);

    for (final permission in knownPermissions) {
      final base = basePermissions[permission.flatKey] ?? false;
      final globalOverride = globalOverrides[permission.flatKey];
      final appOverride = appOverrides[permission.flatKey];

      // Calcula valor efetivo: app vence global que vence base.
      final effective = appOverride ?? globalOverride ?? base;
      final origin = _determineOrigin(base, globalOverride, appOverride);

      permissions.add(
        StaticPermission(
          key: permission.flatKey,
          base: base,
          globalOverride: globalOverride,
          appOverride: appOverride,
          effective: effective,
          origin: origin,
          diagnostics: List.unmodifiable([]),
        ),
      );
    }

    return StaticAppPermissions(
      appId: app.appId,
      installationLabel: app.installationLabel,
      permissions: List.unmodifiable(permissions),
      diagnostics: List.unmodifiable(diagnostics),
    );
  }

  Future<Map<String, bool?>> _readBasePermissionsFromMetadata(
    LocalAppMetadata app,
  ) async {
    final activePath = app.resolvedActivePath;
    if (activePath == null || activePath.isEmpty) {
      return _emptyBasePermissions();
    }

    final metadataPath = '$activePath/metadata';
    final contextValues = await _readContextValuesFromIniFile(metadataPath);
    return _contextToKnownPermissions(contextValues, missingAsFalse: true);
  }

  Map<String, bool?> _emptyBasePermissions() {
    final values = <String, bool?>{};
    for (final permission in knownPermissions) {
      values[permission.flatKey] = false;
    }
    return values;
  }

  // Lê override global (unico para todo o sistema).
  Future<Map<String, bool?>> _readGlobalOverrides() async {
    final userDir = Platform.environment['HOME'] ?? '';
    final sources = <String>[
      '/var/lib/flatpak/overrides/global',
      if (userDir.isNotEmpty) '$userDir/.local/share/flatpak/overrides/global',
    ];

    final merged = <String, bool?>{};
    for (final source in sources) {
      merged.addAll(
        await _contextToKnownPermissionsFromIniFile(
          source,
          missingAsFalse: false,
        ),
      );
    }

    return merged;
  }

  // Lê override especifico de um app.
  Future<Map<String, bool?>> _readAppOverrides(String appId) async {
    final userDir = Platform.environment['HOME'] ?? '';
    final sources = <String>[
      '/var/lib/flatpak/overrides/$appId',
      if (userDir.isNotEmpty) '$userDir/.local/share/flatpak/overrides/$appId',
    ];

    final merged = <String, bool?>{};
    for (final source in sources) {
      merged.addAll(
        await _contextToKnownPermissionsFromIniFile(
          source,
          missingAsFalse: false,
        ),
      );
    }

    return merged;
  }

  Future<Map<String, bool?>> _contextToKnownPermissionsFromIniFile(
    String filePath, {
    required bool missingAsFalse,
  }) async {
    final contextValues = await _readContextValuesFromIniFile(filePath);
    return _contextToKnownPermissions(
      contextValues,
      missingAsFalse: missingAsFalse,
    );
  }

  Future<Map<String, Map<String, bool?>>> _readContextValuesFromIniFile(
    String filePath,
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const {};
      }

      final lines = await file.readAsLines();
      return _parseContextValues(lines);
    } catch (_) {
      return const {};
    }
  }

  Map<String, Map<String, bool?>> _parseContextValues(List<String> lines) {
    final contextValues = <String, Map<String, bool?>>{};
    String? currentSection;

    for (final rawLine in lines) {
      final line = rawLine.trim();

      if (line.isEmpty || line.startsWith(';') || line.startsWith('#')) {
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

      if (currentSection != 'context' || key.isEmpty) {
        continue;
      }

      final normalizedList = key == 'allow' ? 'features' : key;
      if (normalizedList != 'shared' &&
          normalizedList != 'sockets' &&
          normalizedList != 'devices' &&
          normalizedList != 'features') {
        continue;
      }

      final target = contextValues.putIfAbsent(
        normalizedList,
        () => <String, bool?>{},
      );

      for (final item in value.split(';')) {
        for (final rawToken in item.split(',')) {
          var token = rawToken.trim().toLowerCase();
          if (token.isEmpty) {
            continue;
          }

          var enabled = true;
          if (token.startsWith('!')) {
            enabled = false;
            token = token.substring(1).trim();
          }

          final suffixIndex = token.indexOf(':');
          if (suffixIndex > 0) {
            token = token.substring(0, suffixIndex);
          }

          if (token.isEmpty) {
            continue;
          }

          target[token] = enabled;
        }
      }
    }

    return contextValues;
  }

  Map<String, bool?> _contextToKnownPermissions(
    Map<String, Map<String, bool?>> contextValues, {
    required bool missingAsFalse,
  }) {
    final resolved = <String, bool?>{};

    for (final permission in knownPermissions) {
      final value = contextValues[permission.contextList]?[permission.token];
      if (value != null) {
        resolved[permission.flatKey] = value;
      } else if (missingAsFalse) {
        resolved[permission.flatKey] = false;
      }
    }

    return resolved;
  }

  // Determina de qual fonte veio o valor efetivo.
  PermissionOrigin _determineOrigin(
    bool? base,
    bool? globalOverride,
    bool? appOverride,
  ) {
    if (appOverride != null) {
      return PermissionOrigin.appOverride;
    }
    if (globalOverride != null) {
      return PermissionOrigin.globalOverride;
    }
    if (base != null) {
      return PermissionOrigin.base;
    }
    return PermissionOrigin.unset;
  }
}

class _PermissionSpec {
  const _PermissionSpec({
    required this.flatKey,
    required this.contextList,
    required this.token,
  });

  final String flatKey;
  final String contextList;
  final String token;
}
