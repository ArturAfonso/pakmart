import 'dart:io';

// Resolve todas as instalacoes Flatpak existentes na maquina.

enum InstallationKind { user, system, custom }

enum InstallationSource {
	envUserDir,
	defaultUserDir,
	envSystemDir,
	defaultSystemDir,
	installationsD,
}

class FlatpakInstallation {
	const FlatpakInstallation({
		required this.label,
		required this.path,
		required this.kind,
		required this.source,
		required this.exists,
		required this.isDirectory,
		required this.hasAppDirectory,
		required this.hasRuntimeDirectory,
		required this.hasExportsDirectory,
		required this.isValid,
		required this.diagnostics,
	});

	final String label;
	final String path;
	final InstallationKind kind;
	final InstallationSource source;
	final bool exists;
	final bool isDirectory;
	final bool hasAppDirectory;
	final bool hasRuntimeDirectory;
	final bool hasExportsDirectory;
	final bool isValid;
	final List<String> diagnostics;
}

class _InstallationCandidate {
	const _InstallationCandidate({
		required this.label,
		required this.path,
		required this.kind,
		required this.source,
	});

	final String label;
	final String path;
	final InstallationKind kind;
	final InstallationSource source;
}

class InstallationDiscoveryService {
	const InstallationDiscoveryService();

	Future<List<FlatpakInstallation>> discoverInstallations() async {
		final candidates = <_InstallationCandidate>[
			..._readEnvironmentCandidates(),
			..._readDefaultCandidates(),
			...await _readCustomInstallationCandidates(),
		];

		final deduplicated = _deduplicateCandidates(candidates);
		final installations = deduplicated.map(_validateCandidate).toList();

		installations.sort((a, b) {
			final kindCompare = a.kind.index.compareTo(b.kind.index);
			if (kindCompare != 0) {
				return kindCompare;
			}

			return a.path.toLowerCase().compareTo(b.path.toLowerCase());
		});

		return installations;
	}

	List<_InstallationCandidate> _readEnvironmentCandidates() {
		final env = Platform.environment;
		final candidates = <_InstallationCandidate>[];

		final userDir = _normalizePath(env['FLATPAK_USER_DIR']);
		if (userDir != null) {
			candidates.add(
				_InstallationCandidate(
					label: 'User',
					path: userDir,
					kind: InstallationKind.user,
					source: InstallationSource.envUserDir,
				),
			);
		}

		final systemDir = _normalizePath(env['FLATPAK_SYSTEM_DIR']);
		if (systemDir != null) {
			candidates.add(
				_InstallationCandidate(
					label: 'System',
					path: systemDir,
					kind: InstallationKind.system,
					source: InstallationSource.envSystemDir,
				),
			);
		}

		return candidates;
	}

	List<_InstallationCandidate> _readDefaultCandidates() {
		final candidates = <_InstallationCandidate>[];
		final home = Platform.environment['HOME'];
		final defaultUserPath = home == null || home.trim().isEmpty
				? null
				: _normalizePath('$home/.local/share/flatpak');

		if (defaultUserPath != null) {
			candidates.add(
				_InstallationCandidate(
					label: 'User',
					path: defaultUserPath,
					kind: InstallationKind.user,
					source: InstallationSource.defaultUserDir,
				),
			);
		}

		final defaultSystemPath = _normalizePath('/var/lib/flatpak');
		if (defaultSystemPath != null) {
			candidates.add(
				_InstallationCandidate(
					label: 'System',
					path: defaultSystemPath,
					kind: InstallationKind.system,
					source: InstallationSource.defaultSystemDir,
				),
			);
		}

		return candidates;
	}

	Future<List<_InstallationCandidate>> _readCustomInstallationCandidates() async {
		final directory = Directory('/etc/flatpak/installations.d');
		if (!await directory.exists()) {
			return const [];
		}

		final entities = await directory.list(followLinks: false).toList();
		final files = entities.whereType<File>().toList()
			..sort((a, b) => a.path.compareTo(b.path));

		final candidates = <_InstallationCandidate>[];

		for (final file in files) {
			final candidate = await _readCustomInstallationFile(file);
			if (candidate != null) {
				candidates.add(candidate);
			}
		}

		return candidates;
	}

	Future<_InstallationCandidate?> _readCustomInstallationFile(File file) async {
		try {
			final lines = await file.readAsLines();
			String? path;
			String? label;

			for (final rawLine in lines) {
				final line = rawLine.trim();
				if (line.isEmpty || line.startsWith('#') || !line.contains('=')) {
					continue;
				}

				final separatorIndex = line.indexOf('=');
				final key = line.substring(0, separatorIndex).trim().toLowerCase();
				final value = line.substring(separatorIndex + 1).trim();

				if (value.isEmpty) {
					continue;
				}

				if (key == 'path') {
					path = _normalizePath(value);
				} else if (key == 'displayname' || key == 'id' || key == 'name') {
					label ??= value;
				}
			}

			if (path == null) {
				return null;
			}

			final fileName = file.uri.pathSegments.isNotEmpty ? file.uri.pathSegments.last : file.path;
			final resolvedLabel =
					label == null || label.trim().isEmpty ? 'Custom ${_trimExtension(fileName)}' : label;

			return _InstallationCandidate(
				label: resolvedLabel,
				path: path,
				kind: InstallationKind.custom,
				source: InstallationSource.installationsD,
			);
		} catch (_) {
			return null;
		}
	}

	List<_InstallationCandidate> _deduplicateCandidates(List<_InstallationCandidate> candidates) {
		final unique = <String, _InstallationCandidate>{};

		for (final candidate in candidates) {
			final normalizedPath = _normalizePath(candidate.path);
			if (normalizedPath == null) {
				continue;
			}

			unique.putIfAbsent(
				normalizedPath,
				() => _InstallationCandidate(
					label: candidate.label,
					path: normalizedPath,
					kind: candidate.kind,
					source: candidate.source,
				),
			);
		}

		return unique.values.toList(growable: false);
	}

	FlatpakInstallation _validateCandidate(_InstallationCandidate candidate) {
		final diagnostics = <String>[];
		final root = Directory(candidate.path);
		final exists = root.existsSync();
		final isDirectory = exists ? FileSystemEntity.isDirectorySync(candidate.path) : false;

		if (!exists) {
			diagnostics.add('path-not-found');
		} else if (!isDirectory) {
			diagnostics.add('path-is-not-directory');
		}

		final appDirectory = Directory(_joinPath(candidate.path, 'app'));
		final runtimeDirectory = Directory(_joinPath(candidate.path, 'runtime'));
		final exportsDirectory = Directory(_joinPath(candidate.path, 'exports'));

		final hasAppDirectory = appDirectory.existsSync();
		final hasRuntimeDirectory = runtimeDirectory.existsSync();
		final hasExportsDirectory = exportsDirectory.existsSync();

		if (exists && isDirectory && !hasAppDirectory) {
			diagnostics.add('missing-app-directory');
		}
		if (exists && isDirectory && !hasRuntimeDirectory) {
			diagnostics.add('missing-runtime-directory');
		}
		if (exists && isDirectory && !hasExportsDirectory) {
			diagnostics.add('missing-exports-directory');
		}

		final isValid = exists && isDirectory && hasAppDirectory;

		return FlatpakInstallation(
			label: candidate.label,
			path: candidate.path,
			kind: candidate.kind,
			source: candidate.source,
			exists: exists,
			isDirectory: isDirectory,
			hasAppDirectory: hasAppDirectory,
			hasRuntimeDirectory: hasRuntimeDirectory,
			hasExportsDirectory: hasExportsDirectory,
			isValid: isValid,
			diagnostics: List.unmodifiable(diagnostics),
		);
	}

	String? _normalizePath(String? rawPath) {
		if (rawPath == null) {
			return null;
		}

		var normalized = rawPath.trim();
		if (normalized.isEmpty) {
			return null;
		}

		final home = Platform.environment['HOME'];
		if (normalized == '~' && home != null && home.isNotEmpty) {
			normalized = home;
		} else if (normalized.startsWith('~/') && home != null && home.isNotEmpty) {
			normalized = _joinPath(home, normalized.substring(2));
		}

		normalized = normalized.replaceAll(RegExp(r'/+'), '/');
		if (normalized.length > 1 && normalized.endsWith('/')) {
			normalized = normalized.substring(0, normalized.length - 1);
		}

		return normalized;
	}

	String _joinPath(String left, String right) {
		final normalizedLeft = left.endsWith('/') ? left.substring(0, left.length - 1) : left;
		final normalizedRight = right.startsWith('/') ? right.substring(1) : right;
		return '$normalizedLeft/$normalizedRight';
	}

	String _trimExtension(String fileName) {
		final separatorIndex = fileName.lastIndexOf('.');
		if (separatorIndex <= 0) {
			return fileName;
		}

		return fileName.substring(0, separatorIndex);
	}
}