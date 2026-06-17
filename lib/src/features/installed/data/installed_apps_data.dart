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