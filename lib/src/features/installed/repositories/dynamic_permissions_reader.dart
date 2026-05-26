import 'package:dbus/dbus.dart';
import 'package:pakmart/src/features/installed/repositories/local_metadata_reader.dart';




enum PortalPermissionState { allowed, disallowed, unset, unsupported }


class DynamicPermission {
  const DynamicPermission({
    required this.key,
    required this.portalName,
    required this.state,
    required this.diagnostics,
  });

  final String key; 
  final String portalName; 
  final PortalPermissionState state;
  final List<String> diagnostics;
}


class DynamicAppPermissions {
  const DynamicAppPermissions({
    required this.appId,
    required this.installationLabel,
    required this.permissions,
    required this.diagnostics,
  });

  final String appId;
  final String installationLabel;
  final List<DynamicPermission> permissions;
  final List<String> diagnostics;
}

class DynamicPermissionsReader {
  const DynamicPermissionsReader();

  static const String _service = 'org.freedesktop.impl.portal.PermissionStore';
  static const String _interface =
      'org.freedesktop.impl.portal.PermissionStore';
  static const String _objectPath =
      '/org/freedesktop/impl/portal/PermissionStore';

  
  static const List<_PortalSpec> _knownPortals = [
    _PortalSpec(
      key: 'background',
      portalName: 'org.freedesktop.portal.Background',
      table: 'background',
      id: 'background',
      allowedTokens: ['yes'],
      disallowedTokens: ['no'],
    ),
    _PortalSpec(
      key: 'notifications',
      portalName: 'org.freedesktop.portal.Notification',
      table: 'notifications',
      id: 'notification',
      allowedTokens: ['yes'],
      disallowedTokens: ['no'],
    ),
    _PortalSpec(
      key: 'microphone',
      portalName: 'org.freedesktop.portal.Device',
      table: 'devices',
      id: 'microphone',
      allowedTokens: ['yes'],
      disallowedTokens: ['no'],
    ),
    _PortalSpec(
      key: 'speakers',
      portalName: 'org.freedesktop.portal.Device',
      table: 'devices',
      id: 'speakers',
      allowedTokens: ['yes'],
      disallowedTokens: ['no'],
    ),
    _PortalSpec(
      key: 'camera',
      portalName: 'org.freedesktop.portal.Device',
      table: 'devices',
      id: 'camera',
      allowedTokens: ['yes'],
      disallowedTokens: ['no'],
    ),
    _PortalSpec(
      key: 'location',
      portalName: 'org.freedesktop.portal.Location',
      table: 'location',
      id: 'location',
      allowedTokens: ['exact', '1', 'true', 'yes'],
      disallowedTokens: ['none', '0', 'false', 'no'],
    ),
  ];

  Future<List<DynamicAppPermissions>> resolveDynamicPermissionsForMetadata(
    List<LocalAppMetadata> metadata,
  ) async {
    final dynamicPermissions = <DynamicAppPermissions>[];
    final client = DBusClient.session();
    final store = DBusRemoteObject(
      client,
      name: _service,
      path: DBusObjectPath(_objectPath),
    );

    try {
      final permissionStoreAvailable = await _checkPermissionStoreAvailable(
        store,
      );

      for (final app in metadata) {
        dynamicPermissions.add(
          await _resolvePermissionsForApp(
            app,
            permissionStoreAvailable: permissionStoreAvailable,
            store: store,
          ),
        );
      }

      return dynamicPermissions;
    } finally {
      client.close();
    }
  }

  Future<void> setDynamicPermission({
    required String appId,
    required String permissionKey,
    required bool enabled,
  }) async {
    final portal = _portalSpecForKey(permissionKey);
    if (portal == null) {
      throw UnsupportedError(
        'Permissao dinamica nao suportada: $permissionKey',
      );
    }

    final client = DBusClient.session();
    final store = DBusRemoteObject(
      client,
      name: _service,
      path: DBusObjectPath(_objectPath),
    );

    try {
      final permissionStoreAvailable = await _checkPermissionStoreAvailable(
        store,
      );
      if (!permissionStoreAvailable) {
        throw StateError('PermissionStore indisponivel na sessao DBus.');
      }

      final token = enabled
          ? _preferredToken(portal.allowedTokens, fallback: 'yes')
          : _preferredToken(portal.disallowedTokens, fallback: 'no');

      await store.callMethod(_interface, 'SetPermission', [
        DBusString(portal.table),
        const DBusBoolean(true),
        DBusString(portal.id),
        DBusString(appId),
        DBusArray.string([token]),
      ]);
    } finally {
      client.close();
    }
  }

  Future<void> unsetDynamicPermission({
    required String appId,
    required String permissionKey,
  }) async {
    final portal = _portalSpecForKey(permissionKey);
    if (portal == null) {
      throw UnsupportedError(
        'Permissao dinamica nao suportada: $permissionKey',
      );
    }

    final client = DBusClient.session();
    final store = DBusRemoteObject(
      client,
      name: _service,
      path: DBusObjectPath(_objectPath),
    );

    try {
      final permissionStoreAvailable = await _checkPermissionStoreAvailable(
        store,
      );
      if (!permissionStoreAvailable) {
        throw StateError('PermissionStore indisponivel na sessao DBus.');
      }

      await store.callMethod(_interface, 'DeletePermission', [
        DBusString(portal.table),
        DBusString(portal.id),
        DBusString(appId),
      ]);
    } finally {
      client.close();
    }
  }

  
  Future<bool> _checkPermissionStoreAvailable(DBusRemoteObject store) async {
    try {
      await store.callMethod(_interface, 'List', [
        const DBusString('background'),
      ]);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<DynamicAppPermissions> _resolvePermissionsForApp(
    LocalAppMetadata app, {
    required bool permissionStoreAvailable,
    required DBusRemoteObject store,
  }) async {
    final diagnostics = <String>[];
    final permissions = <DynamicPermission>[];

    if (!permissionStoreAvailable) {
      diagnostics.add('permission-store-unavailable');
      
      for (final portal in _knownPortals) {
        permissions.add(
          DynamicPermission(
            key: portal.key,
            portalName: portal.portalName,
            state: PortalPermissionState.unsupported,
            diagnostics: List.unmodifiable(['permission-store-unavailable']),
          ),
        );
      }
    } else {
      
      for (final portal in _knownPortals) {
        final readResult = await _readPortalState(
          store: store,
          appId: app.appId,
          portal: portal,
        );

        permissions.add(
          DynamicPermission(
            key: portal.key,
            portalName: portal.portalName,
            state: readResult.state,
            diagnostics: List.unmodifiable(readResult.diagnostics),
          ),
        );
      }
    }

    return DynamicAppPermissions(
      appId: app.appId,
      installationLabel: app.installationLabel,
      permissions: List.unmodifiable(permissions),
      diagnostics: List.unmodifiable(diagnostics),
    );
  }

  Future<_PortalReadResult> _readPortalState({
    required DBusRemoteObject store,
    required String appId,
    required _PortalSpec portal,
  }) async {
    try {
      final response = await store.callMethod(_interface, 'GetPermission', [
        DBusString(portal.table),
        DBusString(portal.id),
        DBusString(appId),
      ]);

      if (response.returnValues.isEmpty) {
        return const _PortalReadResult(
          state: PortalPermissionState.unset,
          diagnostics: ['portal-empty-response'],
        );
      }

      final first = response.returnValues.first;
      if (first is! DBusArray) {
        return const _PortalReadResult(
          state: PortalPermissionState.unsupported,
          diagnostics: ['portal-invalid-response-type'],
        );
      }

      final tokens = <String>[];
      for (final child in first.children) {
        if (child is DBusString) {
          tokens.add(child.value.toLowerCase());
        }
      }

      if (tokens.isEmpty) {
        return const _PortalReadResult(
          state: PortalPermissionState.unset,
          diagnostics: ['portal-empty-permission-list'],
        );
      }

      final allowed = tokens.any(portal.allowedTokens.contains);
      if (allowed) {
        return _PortalReadResult(
          state: PortalPermissionState.allowed,
          diagnostics: ['portal-tokens:${tokens.join(',')}'],
        );
      }

      final disallowed = tokens.any(portal.disallowedTokens.contains);
      if (disallowed) {
        return _PortalReadResult(
          state: PortalPermissionState.disallowed,
          diagnostics: ['portal-tokens:${tokens.join(',')}'],
        );
      }

      return _PortalReadResult(
        state: PortalPermissionState.unset,
        diagnostics: ['portal-unknown-tokens:${tokens.join(',')}'],
      );
    } catch (e) {
      final message = e.toString().toLowerCase();

      
      if (message.contains('not found') ||
          message.contains('org.freedesktop.portal.error.notfound')) {
        return const _PortalReadResult(
          state: PortalPermissionState.unset,
          diagnostics: ['portal-entry-not-found'],
        );
      }

      
      return _PortalReadResult(
        state: PortalPermissionState.unsupported,
        diagnostics: ['portal-read-error:$e'],
      );
    }
  }

  _PortalSpec? _portalSpecForKey(String key) {
    for (final portal in _knownPortals) {
      if (portal.key == key) {
        return portal;
      }
    }
    return null;
  }

  String _preferredToken(List<String> tokens, {required String fallback}) {
    if (tokens.isEmpty) {
      return fallback;
    }

    return tokens.first;
  }
}

class _PortalSpec {
  const _PortalSpec({
    required this.key,
    required this.portalName,
    required this.table,
    required this.id,
    required this.allowedTokens,
    required this.disallowedTokens,
  });

  final String key;
  final String portalName;
  final String table;
  final String id;
  final List<String> allowedTokens;
  final List<String> disallowedTokens;
}

class _PortalReadResult {
  const _PortalReadResult({required this.state, required this.diagnostics});

  final PortalPermissionState state;
  final List<String> diagnostics;
}
