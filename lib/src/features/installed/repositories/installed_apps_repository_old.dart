import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';
import 'package:pakmart/src/features/installed/data/installed_app_api.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/models/flatpak_app_model.dart';

abstract class InstalledAppsRepository {
  Future<List<InstalledAppData>> getInstalledApps();
}

class InstalledAppsRepositoryImpl implements InstalledAppsRepository {
  InstalledAppsRepositoryImpl(this._api, {HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  final InstalledAppApi _api;
  final HttpClient _httpClient;
  
  @override
  Future<List<InstalledAppData>> getInstalledApps() {
    // TODO: implement getInstalledApps
    throw UnimplementedError();
  }
}













































