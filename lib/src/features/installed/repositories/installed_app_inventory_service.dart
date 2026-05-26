

import 'dart:io';

import 'package:pakmart/src/features/installed/repositories/installation_discovery_service.dart';



enum InventoryEntryStatus {
	ok,
	missingCurrent,
	missingActive,
	unreadable,
}

class InstalledAppInventoryEntry {
	const InstalledAppInventoryEntry({
		required this.appId,
		required this.installationLabel,
		required this.installationKind,
		required this.installationPath,
		required this.appDirectoryPath,
		required this.currentPath,
		required this.activePath,
		required this.resolvedCurrentPath,
		required this.resolvedActivePath,
		required this.status,
		required this.diagnostics,
	});

	final String appId;
	final String installationLabel;
	final InstallationKind installationKind;
	final String installationPath;
	final String appDirectoryPath;
	final String currentPath;
	final String activePath;
	final String? resolvedCurrentPath;
	final String? resolvedActivePath;
	final InventoryEntryStatus status;
	final List<String> diagnostics;

	bool get isHealthy => status == InventoryEntryStatus.ok;
}

class InstalledAppInventoryService {
	const InstalledAppInventoryService(this._discoveryService);

	final InstallationDiscoveryService _discoveryService;

	Future<List<InstalledAppInventoryEntry>> scanInstalledApps({
		bool includeInvalidInstallations = false,
	}) async {
		final installations = await _discoveryService.discoverInstallations();
		final effectiveInstallations = includeInvalidInstallations
				? installations
				: installations.where((item) => item.isValid).toList(growable: false);

		return scanFromInstallations(effectiveInstallations);
	}

	Future<List<InstalledAppInventoryEntry>> scanFromInstallations(
		List<FlatpakInstallation> installations,
	) async {
		final entries = <InstalledAppInventoryEntry>[];

		for (final installation in installations) {
			if (!installation.isValid) {
				continue;
			}

			entries.addAll(await _scanSingleInstallation(installation));
		}

		entries.sort((a, b) {
			final appCompare = a.appId.toLowerCase().compareTo(b.appId.toLowerCase());
			if (appCompare != 0) {
				return appCompare;
			}

			final kindCompare = a.installationKind.index.compareTo(b.installationKind.index);
			if (kindCompare != 0) {
				return kindCompare;
			}

			return a.installationPath.toLowerCase().compareTo(b.installationPath.toLowerCase());
		});

		return entries;
	}

	Future<List<InstalledAppInventoryEntry>> _scanSingleInstallation(
		FlatpakInstallation installation,
	) async {
		final appRootPath = _joinPath(installation.path, 'app');
		final appRoot = Directory(appRootPath);

		if (!await appRoot.exists()) {
			return const [];
		}

		final children = await appRoot.list(followLinks: false).toList();
		final appDirectories = children.whereType<Directory>().toList()
			..sort((a, b) => a.path.compareTo(b.path));

		final entries = <InstalledAppInventoryEntry>[];

		for (final appDirectory in appDirectories) {
			final appId = _basename(appDirectory.path);
			if (appId.isEmpty) {
				continue;
			}

			entries.add(await _buildInventoryEntry(installation, appId, appDirectory.path));
		}

		return entries;
	}

	Future<InstalledAppInventoryEntry> _buildInventoryEntry(
		FlatpakInstallation installation,
		String appId,
		String appDirectoryPath,
	) async {
		final diagnostics = <String>[];
		final currentPath = _joinPath(appDirectoryPath, 'current');
		final activePath = _joinPath(currentPath, 'active');

		final currentEntity = FileSystemEntity.typeSync(currentPath, followLinks: false);
		final activeEntity = FileSystemEntity.typeSync(activePath, followLinks: false);

		String? resolvedCurrentPath;
		String? resolvedActivePath;

		if (currentEntity == FileSystemEntityType.notFound) {
			diagnostics.add('missing-current');
			return InstalledAppInventoryEntry(
				appId: appId,
				installationLabel: installation.label,
				installationKind: installation.kind,
				installationPath: installation.path,
				appDirectoryPath: appDirectoryPath,
				currentPath: currentPath,
				activePath: activePath,
				resolvedCurrentPath: null,
				resolvedActivePath: null,
				status: InventoryEntryStatus.missingCurrent,
				diagnostics: List.unmodifiable(diagnostics),
			);
		}

		try {
			final currentEntityObject = FileSystemEntity.isDirectorySync(currentPath)
					? Directory(currentPath)
					: Link(currentPath);
			resolvedCurrentPath = await currentEntityObject.resolveSymbolicLinks();
		} catch (_) {
			diagnostics.add('unresolved-current-path');
		}

		if (activeEntity == FileSystemEntityType.notFound) {
			diagnostics.add('missing-active');
			return InstalledAppInventoryEntry(
				appId: appId,
				installationLabel: installation.label,
				installationKind: installation.kind,
				installationPath: installation.path,
				appDirectoryPath: appDirectoryPath,
				currentPath: currentPath,
				activePath: activePath,
				resolvedCurrentPath: resolvedCurrentPath,
				resolvedActivePath: null,
				status: InventoryEntryStatus.missingActive,
				diagnostics: List.unmodifiable(diagnostics),
			);
		}

		try {
			final activeEntityObject = FileSystemEntity.isDirectorySync(activePath)
					? Directory(activePath)
					: Link(activePath);
			resolvedActivePath = await activeEntityObject.resolveSymbolicLinks();
		} catch (_) {
			diagnostics.add('unresolved-active-path');
		}

		final status = diagnostics.contains('unresolved-current-path') || diagnostics.contains('unresolved-active-path')
				? InventoryEntryStatus.unreadable
				: InventoryEntryStatus.ok;

		return InstalledAppInventoryEntry(
			appId: appId,
			installationLabel: installation.label,
			installationKind: installation.kind,
			installationPath: installation.path,
			appDirectoryPath: appDirectoryPath,
			currentPath: currentPath,
			activePath: activePath,
			resolvedCurrentPath: resolvedCurrentPath,
			resolvedActivePath: resolvedActivePath,
			status: status,
			diagnostics: List.unmodifiable(diagnostics),
		);
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
}