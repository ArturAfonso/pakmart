

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/theme/theme_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._repository) : super(ThemeMode.light);

  final ThemeRepository _repository;

  Future<void> loadTheme() async {
    final mode = await _repository.getSavedThemeMode();
    emit(mode);
  }

  Future<void> toggleTheme() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    await _repository.saveThemeMode(next);
  }
}