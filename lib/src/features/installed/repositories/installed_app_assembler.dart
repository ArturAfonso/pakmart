import 'package:pakmart/src/features/installed/repositories/dynamic_permissions_reader.dart';
import 'package:pakmart/src/features/installed/repositories/local_metadata_reader.dart';
import 'package:pakmart/src/features/installed/repositories/static_permissions_reader.dart';




enum PermissionScope { staticSandbox, dynamicPortal }


enum PermissionState { allowed, disallowed, unset, unsupported }


class AppPermission {
  const AppPermission({
    required this.key,
    required this.scope,
    required this.description,
    this.declaredBase,
    this.globalOverride,
    this.appOverride,
    this.effectiveStatic,
    this.portalState,
    required this.supported,
    this.unsupportedReason,
  });

  final String key;
  final PermissionScope scope;
  final String description;

  
  final bool? declaredBase;
  final bool? globalOverride;
  final bool? appOverride;
  final bool? effectiveStatic;

  
  final PermissionState? portalState;

  final bool supported;
  final String? unsupportedReason;
}


class InstalledAppData {
  const InstalledAppData({
    required this.appId,
    required this.name,
    required this.summary,
    required this.description,
    required this.iconPath,
    required this.version,
    required this.license,
    required this.branch,
    required this.runtime,
    required this.command,
    required this.installationLabel,
    required this.installationPath,
    required this.permissions,
    required this.diagnostics,
  });

  final String appId;
  final String name;
  final String? summary;
  final String? description;
  final String? iconPath;
  final String? version;
  final String? license;
  final String branch;
  final String runtime;
  final String? command;
  final String installationLabel;
  final String installationPath;
  final List<AppPermission> permissions;
  final List<String> diagnostics;

  
  List<AppPermission> get staticPermissions => permissions
      .where((p) => p.scope == PermissionScope.staticSandbox)
      .toList();

  
  List<AppPermission> get dynamicPermissions => permissions
      .where((p) => p.scope == PermissionScope.dynamicPortal)
      .toList();
}

class InstalledAppAssembler {
  const InstalledAppAssembler();

  
  static const Map<String, String> permissionDescriptions = {
    'Context/shared-network': 'Acesso à rede',
    'Context/shared-ipc': 'Namespace IPC compartilhado',
    'Context/sockets-x11': 'Janela X11',
    'Context/sockets-wayland': 'Janela Wayland',
    'Context/sockets-fallback-x11': 'Fallback para X11',
    'Context/sockets-pulseaudio': 'Servidor PulseAudio',
    'Context/sockets-session-dbus': 'Barramento D-Bus (sessão)',
    'Context/sockets-system-dbus': 'Barramento D-Bus (sistema)',
    'Context/sockets-ssh-auth': 'Autenticação SSH',
    'Context/sockets-pcsc': 'Smart cards',
    'Context/sockets-cups': 'Sistema de impressão',
    'Context/sockets-gpg-agent': 'Diretórios GPG-Agent',
    'Context/sockets-inherit-wayland-socket': 'Socket Wayland herdado',
    'Context/devices-dri': 'Aceleração GPU',
    'Context/devices-input': 'Dispositivos de entrada',
    'Context/devices-kvm': 'Virtualização',
    'Context/devices-shm': 'Memória compartilhada',
    'Context/devices-usb': 'Dispositivos USB',
    'Context/devices-all': 'Todos os dispositivos',
    'Context/allow-devel': 'Syscalls de desenvolvimento',
    'Context/allow-multiarch': 'Programas de outras arquiteturas',
    'Context/allow-bluetooth': 'Bluetooth',
    'Context/allow-canbus': 'Barramento CAN',
    'Context/allow-per-app-dev-shm': 'Memória compartilhada por app',
    'Context/filesystems-host': 'Todos os arquivos do sistema',
    'Context/filesystems-host-os':
        'Bibliotecas, executáveis e dados estáticos do sistema',
    'Context/filesystems-host-etc': 'Configurações do sistema (/etc)',
    'Context/filesystems-home': 'Todos os arquivos do usuário',
    'background': 'Executar em background',
    'notifications': 'Enviar notificações',
    'microphone': 'Acessar microfone',
    'speakers': 'Reproduzir áudio',
    'camera': 'Usar câmera',
    'location': 'Acessar localização',
  };

  Future<InstalledAppData> assembleAppData({
    required LocalAppMetadata metadata,
    required StaticAppPermissions staticPermissions,
    required DynamicAppPermissions dynamicPermissions,
  }) async {
    final diagnostics = <String>[
      ...metadata.diagnostics,
      ...staticPermissions.diagnostics,
      ...dynamicPermissions.diagnostics,
    ];

    final permissions = <AppPermission>[];

    
    for (final staticPerm in staticPermissions.permissions) {
      permissions.add(
        AppPermission(
          key: staticPerm.key,
          scope: PermissionScope.staticSandbox,
          description: permissionDescriptions[staticPerm.key] ?? staticPerm.key,
          declaredBase: staticPerm.base,
          globalOverride: staticPerm.globalOverride,
          appOverride: staticPerm.appOverride,
          effectiveStatic: staticPerm.effective,
          portalState: null,
          supported: true,
          unsupportedReason: null,
        ),
      );
    }

    
    for (final dynamicPerm in dynamicPermissions.permissions) {
      final portalState = _mapPortalState(dynamicPerm.state);
      final supported = dynamicPerm.state != PortalPermissionState.unsupported;

      permissions.add(
        AppPermission(
          key: dynamicPerm.key,
          scope: PermissionScope.dynamicPortal,
          description:
              permissionDescriptions[dynamicPerm.key] ?? dynamicPerm.key,
          declaredBase: null,
          globalOverride: null,
          appOverride: null,
          effectiveStatic: null,
          portalState: portalState,
          supported: supported,
          unsupportedReason: supported ? null : 'PermissionStore indisponível',
        ),
      );
    }

    return InstalledAppData(
      appId: metadata.appId,
      name: metadata.name,
      summary: metadata.summary,
      description: metadata.description,
      iconPath: metadata.iconPath,
      version: metadata.version,
      license: metadata.license,
      branch: metadata.branch ?? 'master',
      runtime: metadata.runtime ?? 'unknown',
      command: metadata.command,
      installationLabel: metadata.installationLabel,
      installationPath: metadata.installationPath,
      permissions: List.unmodifiable(permissions),
      diagnostics: List.unmodifiable(diagnostics),
    );
  }

  
  PermissionState _mapPortalState(PortalPermissionState portalState) {
    switch (portalState) {
      case PortalPermissionState.allowed:
        return PermissionState.allowed;
      case PortalPermissionState.disallowed:
        return PermissionState.disallowed;
      case PortalPermissionState.unset:
        return PermissionState.unset;
      case PortalPermissionState.unsupported:
        return PermissionState.unsupported;
    }
  }

  
  Future<List<InstalledAppData>> assembleMultipleApps({
    required List<LocalAppMetadata> metadata,
    required List<StaticAppPermissions> staticPermissions,
    required List<DynamicAppPermissions> dynamicPermissions,
  }) async {
    final result = <InstalledAppData>[];

    
    final staticByAppId = {for (final sp in staticPermissions) sp.appId: sp};
    final dynamicByAppId = {for (final dp in dynamicPermissions) dp.appId: dp};

    for (final app in metadata) {
      final static = staticByAppId[app.appId];
      final dynamic_ = dynamicByAppId[app.appId];

      if (static == null || dynamic_ == null) {
        
        continue;
      }

      result.add(
        await assembleAppData(
          metadata: app,
          staticPermissions: static,
          dynamicPermissions: dynamic_,
        ),
      );
    }

    return result;
  }
}
