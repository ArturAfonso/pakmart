import 'package:flutter/material.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';

enum PermissionSeverity { normal, warning, danger }

sealed class InstalledPermissionEntryData {
  const InstalledPermissionEntryData();
}

class InstalledPermissionToggleData extends InstalledPermissionEntryData {
  const InstalledPermissionToggleData({
    required this.title,
    required this.subtitle,
    required this.permissionKey,
    required this.enabled,
    this.severity = PermissionSeverity.normal,
  });

  final String title;
  final String subtitle;
  final String permissionKey;
  final bool enabled;
  final PermissionSeverity severity;
}

class InstalledPermissionTagsData extends InstalledPermissionEntryData {
  const InstalledPermissionTagsData({
    required this.title,
    required this.subtitle,
    required this.tags,
    this.addButtonLabel = 'Adicionar',
  });

  final String title;
  final String subtitle;
  final List<String> tags;
  final String addButtonLabel;
}

class InstalledPermissionSectionData {
  const InstalledPermissionSectionData({
    required this.index,
    required this.title,
    required this.entries,
  });

  final String index;
  final String title;
  final List<InstalledPermissionEntryData> entries;
}

class InstalledAppData {
  const InstalledAppData({
    required this.id,
    required this.name,
    required this.description,
    required this.packageName,
    required this.version,
    required this.size,
     this.icon,
    required this.iconBackground,
    required this.tagline,
    required this.license,
    required this.category,
    required this.sandboxLabel,
    required this.permissionSections,
  });

  final String id;
  final String name;
  final String description;
  final String packageName;
  final String version;
  final String size;
  final FlathubIcon? icon;
  final Color iconBackground;
  final String tagline;
  final String license;
  final String category;
  final String sandboxLabel;
  final List<InstalledPermissionSectionData> permissionSections;
}
/* 
abstract final class InstalledAppsData {
  static  apps = [
    InstalledAppData(
      id: 'flowstudio',
      name: 'FlowStudio',
      description: 'Ambiente de escrita minimalista, focado e silencioso.',
      packageName: 'art.atelier.FlowStudio',
      version: '3.2.1',
      size: '84.2 MB',
      icon: FlathubIcon(
        url: 'https://flathub.org/icons/flowstudio.png', type: '', width: null, height: null),
      iconBackground: Color(0xFFFFE3DA),
      tagline: 'Ambiente de escrita minimalista, focado e silencioso.',
      license: 'GPL-3.0',
      category: 'Office',
      sandboxLabel: 'SANDBOXED',
      permissionSections: [
        InstalledPermissionSectionData(
          index: '1.',
          title: 'COMPARTILHAMENTO',
          entries: [
            InstalledPermissionToggleData(
              title: 'Rede',
              subtitle: 'Acesso à internet e rede local\nshare=network',
              permissionKey: 'share-network',
              enabled: true,
            ),
            InstalledPermissionToggleData(
              title: 'IPC com host',
              subtitle: 'Comunicação entre processos\nshare=ipc',
              permissionKey: 'share-ipc',
              enabled: true,
            ),
          ],
        ),
        InstalledPermissionSectionData(
          index: '2.',
          title: 'SOCKETS',
          entries: [
            InstalledPermissionToggleData(
              title: 'X11',
              subtitle: 'socket=x11',
              permissionKey: 'socket-x11',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Wayland',
              subtitle: 'socket=wayland',
              permissionKey: 'socket-wayland',
              enabled: true,
            ),
            InstalledPermissionToggleData(
              title: 'Fallback X11',
              subtitle: 'socket=fallback-x11',
              permissionKey: 'socket-fallback-x11',
              enabled: true,
            ),
            InstalledPermissionToggleData(
              title: 'PulseAudio',
              subtitle: 'socket=pulseaudio',
              permissionKey: 'socket-pulseaudio',
              enabled: true,
            ),
            InstalledPermissionToggleData(
              title: 'D-Bus de sessão',
              subtitle: 'socket=session-bus',
              permissionKey: 'socket-session-bus',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'D-Bus do sistema',
              subtitle: 'socket=system-bus',
              permissionKey: 'socket-system-bus',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Agente SSH',
              subtitle: 'socket=ssh-auth',
              permissionKey: 'socket-ssh-auth',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Cartões inteligentes',
              subtitle: 'socket=pcsc',
              permissionKey: 'socket-pcsc',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Impressão (CUPS)',
              subtitle: 'socket=cups',
              permissionKey: 'socket-cups',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Agente GPG',
              subtitle: 'socket=gpg-agent',
              permissionKey: 'socket-gpg-agent',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Herdar socket Wayland',
              subtitle: 'socket=inherit-wayland-socket',
              permissionKey: 'socket-inherit-wayland',
              enabled: false,
            ),
          ],
        ),
        InstalledPermissionSectionData(
          index: '3.',
          title: 'DISPOSITIVOS',
          entries: [
            InstalledPermissionToggleData(
              title: 'Aceleração GPU',
              subtitle: 'device=dri',
              permissionKey: 'device-dri',
              enabled: true,
            ),
            InstalledPermissionToggleData(
              title: 'Dispositivos de entrada',
              subtitle: 'device=input',
              permissionKey: 'device-input',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Virtualização (KVM)',
              subtitle: 'device=kvm',
              permissionKey: 'device-kvm',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Memória compartilhada',
              subtitle: 'device=shm',
              permissionKey: 'device-shm',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Todos (ex: webcam)',
              subtitle: 'Acesso amplo a hardware\ndevice=all',
              permissionKey: 'device-all',
              enabled: false,
              severity: PermissionSeverity.danger,
            ),
          ],
        ),
        InstalledPermissionSectionData(
          index: '4.',
          title: 'PERMITIR',
          entries: [
            InstalledPermissionToggleData(
              title: 'Chamadas de desenvolvimento',
              subtitle: 'ex: ptrace\nallow=devel',
              permissionKey: 'allow-devel',
              enabled: false,
              severity: PermissionSeverity.warning,
            ),
            InstalledPermissionToggleData(
              title: 'Programas de outras arquiteturas',
              subtitle: 'allow=multiarch',
              permissionKey: 'allow-multiarch',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Bluetooth',
              subtitle: 'allow=bluetooth',
              permissionKey: 'allow-bluetooth',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Barramento CAN',
              subtitle: 'allow=canbus',
              permissionKey: 'allow-canbus',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Memória compartilhada por app',
              subtitle: 'allow=per-app-dev-shm',
              permissionKey: 'allow-per-app-dev-shm',
              enabled: false,
            ),
          ],
        ),
        InstalledPermissionSectionData(
          index: '5.',
          title: 'SISTEMA DE ARQUIVOS',
          entries: [
            InstalledPermissionToggleData(
              title: 'Todos os arquivos do sistema',
              subtitle: 'Acesso amplo aos dados\nfilesystem=host',
              permissionKey: 'filesystem-host',
              enabled: false,
              severity: PermissionSeverity.danger,
            ),
            InstalledPermissionToggleData(
              title: 'Bibliotecas e executáveis do sistema',
              subtitle: 'filesystem=host-os',
              permissionKey: 'filesystem-host-os',
              enabled: false,
              severity: PermissionSeverity.warning,
            ),
            InstalledPermissionToggleData(
              title: 'Configurações do sistema',
              subtitle: 'filesystem=host-etc',
              permissionKey: 'filesystem-host-etc',
              enabled: false,
              severity: PermissionSeverity.warning,
            ),
            InstalledPermissionToggleData(
              title: 'Todos os arquivos do usuário',
              subtitle: 'Acesso à pasta pessoal completa\nfilesystem=home',
              permissionKey: 'filesystem-home',
              enabled: false,
              severity: PermissionSeverity.danger,
            ),
            InstalledPermissionTagsData(
              title: 'Outros caminhos',
              subtitle: 'Caminhos personalizados (ex: ~/Documentos)',
              tags: ['xdg-pictures', 'xdg-music'],
            ),
          ],
        ),
        InstalledPermissionSectionData(
          index: '6.',
          title: 'BARRAMENTOS D-BUS',
          entries: [
            InstalledPermissionTagsData(
              title: 'Talk (pode falar com)',
              subtitle: 'Nomes que o app pode invocar',
              tags: [
                'org.freedesktop.Notifications',
                'org.kde.StatusNotifierWatcher',
                'com.canonical.AppMenu.Registrar',
              ],
            ),
            InstalledPermissionTagsData(
              title: 'Own (pode possuir)',
              subtitle: 'Nomes de barramento que o app possui',
              tags: [],
            ),
          ],
        ),
        InstalledPermissionSectionData(
          index: '7.',
          title: 'PORTAIS DINÂMICOS',
          entries: [
            InstalledPermissionToggleData(
              title: 'Segundo plano',
              subtitle: 'portal=background',
              permissionKey: 'portal-background',
              enabled: true,
            ),
            InstalledPermissionToggleData(
              title: 'Notificações',
              subtitle: 'portal=notifications',
              permissionKey: 'portal-notifications',
              enabled: true,
            ),
            InstalledPermissionToggleData(
              title: 'Microfone',
              subtitle: 'portal=microphone',
              permissionKey: 'portal-microphone',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Saída de áudio',
              subtitle: 'portal=speakers',
              permissionKey: 'portal-speakers',
              enabled: true,
            ),
            InstalledPermissionToggleData(
              title: 'Câmera',
              subtitle: 'portal=camera',
              permissionKey: 'portal-camera',
              enabled: false,
            ),
            InstalledPermissionToggleData(
              title: 'Localização',
              subtitle: 'portal=location',
              permissionKey: 'portal-location',
              enabled: false,
              severity: PermissionSeverity.warning,
            ),
          ],
        ),
      ],
    ),
    InstalledAppData(
      id: 'echo-player',
      name: 'Echo Player',
      description: 'Tocador de música acolhedor com biblioteca local e podcasts.',
      packageName: 'fm.harmony.Echo',
      version: '2.4.1',
      size: '142.5 MB',
      icon: Icons.headphones_rounded,
      iconBackground: Color(0xFFE3E8FF),
      tagline: 'Um reprodutor suave para bibliotecas locais e podcasts.',
      license: 'MPL-2.0',
      category: 'Music',
      sandboxLabel: 'SANDBOXED',
      permissionSections: [],
    ),
    InstalledAppData(
      id: 'teleframe',
      name: 'Teleframe',
      description: 'Mensageiro nativo rápido com sincronização em todos os dispositivos.',
      packageName: 'im.frame.Teleframe',
      version: '2.4.1',
      size: '98 MB',
      icon: Icons.chat_bubble_outline_rounded,
      iconBackground: Color(0xFFD9F7FF),
      tagline: 'Mensageiro nativo rápido com sincronização em todos os dispositivos.',
      license: 'AGPL-3.0',
      category: 'Communication',
      sandboxLabel: 'SANDBOXED',
      permissionSections: [],
    ),
    InstalledAppData(
      id: 'vscodium',
      name: 'VSCodium',
      description: 'Editor de código aberto, sem telemetria proprietária.',
      packageName: 'com.vscodium.codium',
      version: '1.92',
      size: '320 MB',
      icon: Icons.keyboard_rounded,
      iconBackground: Color(0xFFD7F5FF),
      tagline: 'Editor aberto e enxuto para desenvolvimento diário.',
      license: 'MIT',
      category: 'Development',
      sandboxLabel: 'SANDBOXED',
      permissionSections: [],
    ),
  ];

  static InstalledAppData? byId(String appId) {
    for (final app in apps) {
      if (app.id == appId) {
        return app;
      }
    }

    return null;
  }
} */