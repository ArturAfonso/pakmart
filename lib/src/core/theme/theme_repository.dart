

import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/themelocal_datasource.dart';

abstract class ThemeRepository {
  Future<ThemeMode> getSavedThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}

class ThemeRepositoryImpl implements ThemeRepository {
  ThemeRepositoryImpl(this._local);
  final ThemeLocalDataSource _local;

  @override
  Future<ThemeMode> getSavedThemeMode() => _local.getThemeMode();

  @override
  Future<void> saveThemeMode(ThemeMode mode) => _local.saveThemeMode(mode);
}