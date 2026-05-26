import 'dart:async';
import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_state.dart';
import 'package:pakmart/src/features/installed/repositories/installed_apps_repository_new.dart';

class InstalledAppsBloc extends Cubit<InstalledAppsState> {
  InstalledAppsBloc(this._repository) : super(InstalledAppsInitial()) {
    _startRealtimePermissionWatchers();
  }

  final InstalledAppsRepositoryNew _repository;

  static const String _permissionStoreService =
      'org.freedesktop.impl.portal.PermissionStore';
  static const String _permissionStoreInterface =
      'org.freedesktop.impl.portal.PermissionStore';
  static const String _permissionStorePath =
      '/org/freedesktop/impl/portal/PermissionStore';

  DBusClient? _permissionStoreClient;
  StreamSubscription<DBusSignal>? _permissionStoreChangedSubscription;
  StreamSubscription<FileSystemEvent>? _userOverridesSubscription;
  StreamSubscription<FileSystemEvent>? _systemOverridesSubscription;
  Timer? _refreshDebounce;
  bool _watchersInitialized = false;

  Future<void> loadInstalledApps({bool forceRefresh = false}) async {
    final current = state;

    if (current is InstalledAppsLoaded && !forceRefresh) {
      emit(InstalledAppsLoaded(current.data, isLoadingData: true));
    } else {
      emit(InstalledAppsLoading());
    }

    try {
      final apps = await _repository.getInstalledApps();
      emit(InstalledAppsLoaded(apps));
    } catch (e) {
      emit(InstalledAppsError('Falha ao carregar aplicativos instalados: $e'));
    }
  }

  Future<void> refresh() async {
    await loadInstalledApps(forceRefresh: true);
  }

  Future<void> setStaticPermissionOverride({
    required String appId,
    required String permissionKey,
    required bool enabled,
  }) async {
    await _repository.setStaticPermissionOverride(
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
    await _repository.setDynamicPermissionOverride(
      appId: appId,
      permissionKey: permissionKey,
      enabled: enabled,
    );
  }

  void _startRealtimePermissionWatchers() {
    if (_watchersInitialized) {
      return;
    }
    _watchersInitialized = true;

    _watchPermissionStoreChanges();
    _watchFlatpakOverrides();
  }

  Future<void> _watchPermissionStoreChanges() async {
    final client = DBusClient.session();
    final store = DBusRemoteObject(
      client,
      name: _permissionStoreService,
      path: DBusObjectPath(_permissionStorePath),
    );

    try {
      
      await store.callMethod(_permissionStoreInterface, 'List', const [
        DBusString('background'),
      ]);

      _permissionStoreClient = client;
      final signalStream = DBusRemoteObjectSignalStream(
        object: store,
        interface: _permissionStoreInterface,
        name: 'Changed',
      );

      _permissionStoreChangedSubscription = signalStream.listen(
        (_) => _scheduleRefresh(),
        onError: (_) {
          
        },
      );
    } catch (_) {
      client.close();
    }
  }

  Future<void> _watchFlatpakOverrides() async {
    final home = Platform.environment['HOME'] ?? '';

    if (home.isNotEmpty) {
      final userDir = Directory('$home/.local/share/flatpak/overrides');
      if (!await userDir.exists()) {
        await userDir.create(recursive: true);
      }
      _userOverridesSubscription = userDir.watch().listen(
        (_) => _scheduleRefresh(),
        onError: (_) {},
      );
    }

    final systemDir = Directory('/var/lib/flatpak/overrides');
    if (await systemDir.exists()) {
      _systemOverridesSubscription = systemDir.watch().listen(
        (_) => _scheduleRefresh(),
        onError: (_) {},
      );
    }
  }

  void _scheduleRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 400), () async {
      if (isClosed) {
        return;
      }

      await refresh();
    });
  }

  @override
  Future<void> close() async {
    _refreshDebounce?.cancel();
    await _permissionStoreChangedSubscription?.cancel();
    await _userOverridesSubscription?.cancel();
    await _systemOverridesSubscription?.cancel();
    _permissionStoreClient?.close();
    return super.close();
  }
}
