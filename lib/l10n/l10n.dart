import 'package:flutter/widgets.dart';
import 'package:pakmart/l10n/generated/app_localizations.dart';

export 'package:pakmart/l10n/generated/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension CategoryLocalizations on AppLocalizations {
  String categoryTitle(String id, String fallback) {
    return switch (id.toLowerCase()) {
      'audiovideo' => categoryAudioVideo,
      'development' => categoryDevelopment,
      'education' => categoryEducation,
      'game' => categoryGames,
      'graphics' => categoryGraphics,
      'network' => categoryInternet,
      'office' => categoryOffice,
      'science' => categoryScience,
      'system' => categorySystem,
      'utility' => categoryUtilities,
      _ => fallback.isEmpty ? categoryGeneric : fallback,
    };
  }

  String categoryDescription(String id, String fallbackTitle) {
    return switch (id.toLowerCase()) {
      'audiovideo' => categoryAudioVideoDescription,
      'development' => categoryDevelopmentDescription,
      'education' => categoryEducationDescription,
      'game' => categoryGamesDescription,
      'graphics' => categoryGraphicsDescription,
      'network' => categoryInternetDescription,
      'office' => categoryOfficeDescription,
      'science' => categoryScienceDescription,
      'system' => categorySystemDescription,
      'utility' => categoryUtilitiesDescription,
      _ => categoryGenericDescription(categoryTitle(id, fallbackTitle)),
    };
  }
}

extension PermissionLocalizations on AppLocalizations {
  String permissionSectionTitle(String title) {
    return switch (title) {
      'COMPARTILHAMENTO' => permissionSectionSharing,
      'SOCKETS' => permissionSectionSockets,
      'DISPOSITIVOS' => permissionSectionDevices,
      'PERMITIR' => permissionSectionAllow,
      'FILESYSTEM' => permissionSectionFilesystem,
      'PORTAIS DINAMICOS' => permissionSectionPortals,
      _ => title,
    };
  }

  String permissionTitle(String key, String fallback) {
    return switch (key) {
      'Context/shared-network' => permissionNetwork,
      'Context/shared-ipc' => permissionSharedIpc,
      'Context/sockets-x11' => permissionX11,
      'Context/sockets-wayland' => permissionWayland,
      'Context/sockets-fallback-x11' => permissionFallbackX11,
      'Context/sockets-pulseaudio' => permissionPulseAudio,
      'Context/sockets-session-dbus' => permissionSessionDbus,
      'Context/sockets-system-dbus' => permissionSystemDbus,
      'Context/sockets-ssh-auth' => permissionSshAuth,
      'Context/sockets-pcsc' => permissionSmartCards,
      'Context/sockets-cups' => permissionPrinting,
      'Context/sockets-gpg-agent' => permissionGpgAgent,
      'Context/sockets-inherit-wayland-socket' => permissionInheritedWayland,
      'Context/devices-dri' => permissionGpu,
      'Context/devices-input' => permissionInputDevices,
      'Context/devices-kvm' => permissionVirtualization,
      'Context/devices-shm' => permissionSharedMemory,
      'Context/devices-usb' => permissionUsb,
      'Context/devices-all' => permissionAllDevices,
      'Context/allow-devel' => permissionDevelopment,
      'Context/allow-multiarch' => permissionMultiarch,
      'Context/allow-bluetooth' => permissionBluetooth,
      'Context/allow-canbus' => permissionCanBus,
      'Context/allow-per-app-dev-shm' => permissionPerAppSharedMemory,
      'Context/filesystems-host' => permissionHostFiles,
      'Context/filesystems-host-os' => permissionHostOsFiles,
      'Context/filesystems-host-etc' => permissionSystemConfig,
      'Context/filesystems-home' => permissionHomeFiles,
      'background' => permissionBackground,
      'notifications' => permissionNotifications,
      'microphone' => permissionMicrophone,
      'speakers' => permissionSpeakers,
      'camera' => permissionCamera,
      'location' => permissionLocation,
      _ => fallback,
    };
  }

  String permissionSummary(String summary) {
    return summary
        .replaceAll('Estado dinamico:', permissionDynamicState)
        .replaceAll('Base:', permissionBase)
        .replaceAll('Global:', permissionGlobal)
        .replaceAll('App:', permissionApp)
        .replaceAll('Efetiva:', permissionEffective)
        .replaceAll('nao suportado', permissionUnsupported)
        .replaceAll('nao definido', permissionUnset)
        .replaceAll('permitido', permissionAllowed)
        .replaceAll('bloqueado', permissionBlocked)
        .replaceAll('negado', permissionDenied);
  }
}
