import 'package:flutter/material.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart'
    as legacy;
import 'package:pakmart/src/features/installed/repositories/dynamic_permissions_reader.dart';
import 'package:pakmart/src/features/installed/repositories/installation_discovery_service.dart';
import 'package:pakmart/src/features/installed/repositories/installed_app_assembler.dart'
    as assembled;
import 'package:pakmart/src/features/installed/repositories/installed_app_inventory_service.dart';
import 'package:pakmart/src/features/installed/repositories/local_metadata_reader.dart';
import 'package:pakmart/src/features/installed/repositories/static_permissions_reader.dart';




class InstalledAppsRepositoryNew {
  const InstalledAppsRepositoryNew({
    required InstallationDiscoveryService discoveryService,
    required InstalledAppInventoryService inventoryService,
    required LocalMetadataReader metadataReader,
    required StaticPermissionsReader staticPermissionsReader,
    required DynamicPermissionsReader dynamicPermissionsReader,
    required assembled.InstalledAppAssembler assembler,
  }) : _discoveryService = discoveryService,
       _inventoryService = inventoryService,
       _metadataReader = metadataReader,
       _staticPermissionsReader = staticPermissionsReader,
       _dynamicPermissionsReader = dynamicPermissionsReader,
       _assembler = assembler;

  final InstallationDiscoveryService _discoveryService;
  final InstalledAppInventoryService _inventoryService;
  final LocalMetadataReader _metadataReader;
  final StaticPermissionsReader _staticPermissionsReader;
  final DynamicPermissionsReader _dynamicPermissionsReader;
  final assembled.InstalledAppAssembler _assembler;

  
  Future<List<legacy.InstalledAppData>> getInstalledApps() async {
    final domainApps = await getAllInstalledApps();
    return domainApps.map(_toLegacyInstalledAppData).toList(growable: false);
  }

  
  Future<List<assembled.InstalledAppData>> getAllInstalledApps() async {
    try {
      
      final installations = await _discoveryService.discoverInstallations();
      if (installations.isEmpty) {
        return [];
      }

      
      final inventory = await _inventoryService.scanFromInstallations(
        installations,
      );
      if (inventory.isEmpty) {
        return [];
      }

      
      final metadata = await _metadataReader.resolveMetadataForInventory(
        inventory,
      );
      if (metadata.isEmpty) {
        return [];
      }

      
      final staticPermissions = await _staticPermissionsReader
          .resolveStaticPermissionsForMetadata(metadata);

      
      final dynamicPermissions = await _dynamicPermissionsReader
          .resolveDynamicPermissionsForMetadata(metadata);

      
      final apps = await _assembler.assembleMultipleApps(
        metadata: metadata,
        staticPermissions: staticPermissions,
        dynamicPermissions: dynamicPermissions,
      );

      final sortedApps = [...apps]
        ..sort((a, b) {
          final nameComparison = a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          );
          if (nameComparison != 0) {
            return nameComparison;
          }

          return a.appId.toLowerCase().compareTo(b.appId.toLowerCase());
        });

      return sortedApps;
    } catch (e) {
      
      print('Erro ao carregar apps instalados: $e');
      return [];
    }
  }

  
  Future<assembled.InstalledAppData?> getInstalledApp(String appId) async {
    try {
      final allApps = await getAllInstalledApps();
      for (final app in allApps) {
        if (app.appId == appId) {
          return app;
        }
      }
      return null;
    } catch (e) {
      print('Erro ao carregar app $appId: $e');
      return null;
    }
  }

  
  Future<List<assembled.InstalledAppData>> getAppsFromInstallation(
    String installationPath,
  ) async {
    try {
      final allApps = await getAllInstalledApps();
      return allApps
          .where((app) => app.installationPath == installationPath)
          .toList();
    } catch (e) {
      print('Erro ao carregar apps da instalação $installationPath: $e');
      return [];
    }
  }

  Future<void> setStaticPermissionOverride({
    required String appId,
    required String permissionKey,
    required bool enabled,
  }) async {
    await _staticPermissionsReader.setAppOverridePermission(
      appId: appId,
      permissionKey: permissionKey,
      enabled: enabled,
    );
  }

  Future<void> setDynamicPermissionOverride({
    required String appId,
    required String permissionKey,
    required bool enabled,
  }) async {
    await _dynamicPermissionsReader.setDynamicPermission(
      appId: appId,
      permissionKey: permissionKey,
      enabled: enabled,
    );
  }

  legacy.InstalledAppData _toLegacyInstalledAppData(
    assembled.InstalledAppData app,
  ) {
    return legacy.InstalledAppData(
      id: app.appId,
      name: app.name,
      description: app.description ?? app.summary ?? app.name,
      packageName: app.appId,
      version: app.version ?? '-',
      size: '-',
      icon: _iconFromPath(app.iconPath),
      iconBackground: const Color(0xFFEDEDED),
      tagline: app.summary ?? app.description ?? app.name,
      license: app.license ?? 'Desconhecida',
      category: 'Installed',
      sandboxLabel: app.installationLabel,
      permissionSections: _toLegacyPermissionSections(app.permissions),
    );
  }

  List<legacy.InstalledPermissionSectionData> _toLegacyPermissionSections(
    List<assembled.AppPermission> permissions,
  ) {
    final staticPermissions = permissions
        .where(
          (permission) =>
              permission.scope == assembled.PermissionScope.staticSandbox,
        )
        .toList(growable: false);

    final dynamicPermissions = permissions
        .where(
          (permission) =>
              permission.scope == assembled.PermissionScope.dynamicPortal,
        )
        .toList(growable: false);

    final sections = <legacy.InstalledPermissionSectionData>[];

    sections.addAll(_buildStaticSections(staticPermissions));

    if (dynamicPermissions.isNotEmpty) {
      sections.add(
        legacy.InstalledPermissionSectionData(
          index: '${sections.length + 1}.',
          title: 'PORTAIS DINAMICOS',
          entries: dynamicPermissions
              .map(_toLegacyDynamicToggle)
              .toList(growable: false),
        ),
      );
    }

    return List.unmodifiable(sections);
  }

  List<legacy.InstalledPermissionSectionData> _buildStaticSections(
    List<assembled.AppPermission> staticPermissions,
  ) {
    final sectionDefinitions = [
      ('COMPARTILHAMENTO', 'Context/shared-'),
      ('SOCKETS', 'Context/sockets-'),
      ('DISPOSITIVOS', 'Context/devices-'),
      ('PERMITIR', 'Context/allow-'),
      ('FILESYSTEM', 'Context/filesystems-'),
    ];

    final sections = <legacy.InstalledPermissionSectionData>[];

    for (final definition in sectionDefinitions) {
      final title = definition.$1;
      final prefix = definition.$2;

      final entries = staticPermissions
          .where((permission) => permission.key.startsWith(prefix))
          .map(_toLegacyStaticToggle)
          .toList(growable: false);

      if (entries.isEmpty) {
        continue;
      }

      sections.add(
        legacy.InstalledPermissionSectionData(
          index: '${sections.length + 1}.',
          title: title,
          entries: entries,
        ),
      );
    }

    return sections;
  }

  legacy.InstalledPermissionToggleData _toLegacyStaticToggle(
    assembled.AppPermission permission,
  ) {
    final effective = permission.effectiveStatic ?? false;

    return legacy.InstalledPermissionToggleData(
      title: permission.description,
      subtitle: '${_buildStaticSummary(permission)}\n${permission.key}',
      permissionKey: permission.key,
      enabled: effective,
      severity: _staticSeverity(permission),
    );
  }

  legacy.InstalledPermissionToggleData _toLegacyDynamicToggle(
    assembled.AppPermission permission,
  ) {
    final state = permission.portalState ?? assembled.PermissionState.unset;

    return legacy.InstalledPermissionToggleData(
      title: permission.description,
      subtitle:
          'Estado dinamico: ${_portalStateLabel(state)}\nportal=${permission.key}',
      permissionKey: permission.key,
      enabled: state == assembled.PermissionState.allowed,
      severity: _dynamicSeverity(state),
    );
  }

  legacy.PermissionSeverity _staticSeverity(
    assembled.AppPermission permission,
  ) {
    if (permission.effectiveStatic != true) {
      return legacy.PermissionSeverity.normal;
    }

    if (permission.key == 'Context/devices-all' ||
        permission.key == 'Context/allow-devel') {
      return legacy.PermissionSeverity.danger;
    }

    if (permission.key == 'Context/sockets-session-dbus' ||
        permission.key == 'Context/sockets-system-dbus') {
      return legacy.PermissionSeverity.warning;
    }

    return legacy.PermissionSeverity.normal;
  }

  legacy.PermissionSeverity _dynamicSeverity(assembled.PermissionState state) {
    switch (state) {
      case assembled.PermissionState.allowed:
        return legacy.PermissionSeverity.normal;
      case assembled.PermissionState.disallowed:
      case assembled.PermissionState.unset:
        return legacy.PermissionSeverity.normal;
      case assembled.PermissionState.unsupported:
        return legacy.PermissionSeverity.warning;
    }
  }

  String _buildStaticSummary(assembled.AppPermission permission) {
    final declared = _boolLabel(permission.declaredBase);
    final globalOverride = _boolLabel(permission.globalOverride);
    final appOverride = _boolLabel(permission.appOverride);
    final effective = _boolLabel(permission.effectiveStatic);

    return 'Base: $declared | Global: $globalOverride | App: $appOverride | Efetiva: $effective';
  }

  String _boolLabel(bool? value) {
    if (value == null) {
      return 'nao definido';
    }

    return value ? 'permitido' : 'negado';
  }

  String _portalStateLabel(assembled.PermissionState state) {
    switch (state) {
      case assembled.PermissionState.allowed:
        return 'permitido';
      case assembled.PermissionState.disallowed:
        return 'bloqueado';
      case assembled.PermissionState.unset:
        return 'nao definido';
      case assembled.PermissionState.unsupported:
        return 'nao suportado';
    }
  }

  FlathubIcon? _iconFromPath(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }

    final uri = Uri.file(path).toString();
    return FlathubIcon(url: uri, type: 'local', width: 128, height: 128);
  }
}
