import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/locale/app_language_repository.dart';

enum AppLanguageSource { system, manual }

class AppLanguageState {
  const AppLanguageState({
    required this.locale,
    required this.localeCode,
    required this.source,
    required this.distroId,
    required this.distroFamily,
    this.isLoading = false,
  });

  final Locale locale;
  final String localeCode;
  final AppLanguageSource source;
  final String distroId;
  final String distroFamily;
  final bool isLoading;

  AppLanguageState copyWith({
    Locale? locale,
    String? localeCode,
    AppLanguageSource? source,
    String? distroId,
    String? distroFamily,
    bool? isLoading,
  }) {
    return AppLanguageState(
      locale: locale ?? this.locale,
      localeCode: localeCode ?? this.localeCode,
      source: source ?? this.source,
      distroId: distroId ?? this.distroId,
      distroFamily: distroFamily ?? this.distroFamily,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AppLanguageCubit extends Cubit<AppLanguageState> {
    /// Retorna o locale formatado para uso na API do Flathub.
    /// Exemplo: pt_BR -> ptbr, en_US -> en, es_ES -> es
    String get apiLocaleCode {
      final code = state.localeCode.toLowerCase();
      if (code.startsWith('pt')) {
        // Aceita pt-br ou ptbr
        return 'ptbr';
      } else if (code.startsWith('en')) {
        return 'en';
      } else if (code.startsWith('es')) {
        return 'es';
      }
      // fallback para en
      return 'en';
    }
  AppLanguageCubit(this._repository)
    : super(
        const AppLanguageState(
          locale: Locale('en', 'US'),
          localeCode: 'en_US',
          source: AppLanguageSource.system,
          distroId: 'unknown',
          distroFamily: 'unknown',
        ),
      );

  final AppLanguageRepository _repository;

  static const supportedLocales = <Locale>[Locale('pt', 'BR'), Locale('en', 'US'), Locale('es', 'ES')];

  Future<void> loadLanguage() async {
    emit(state.copyWith(isLoading: true));
    final info = await _repository.getEffectiveLocaleInfo();
    emit(
      state.copyWith(
        locale: _toLocale(info.localeCode),
        localeCode: info.localeCode,
        source: info.isManual ? AppLanguageSource.manual : AppLanguageSource.system,
        distroId: info.distroId,
        distroFamily: info.distroFamily,
        isLoading: false,
      ),
    );
  }

  Future<void> setManualLanguage(String localeCode) async {
    emit(state.copyWith(isLoading: true));
    await _repository.setUserLocaleCode(localeCode);
    final info = await _repository.getEffectiveLocaleInfo();

    emit(
      state.copyWith(
        locale: _toLocale(info.localeCode),
        localeCode: info.localeCode,
        source: AppLanguageSource.manual,
        distroId: info.distroId,
        distroFamily: info.distroFamily,
        isLoading: false,
      ),
    );
  }

  Future<void> useSystemLanguage() async {
    emit(state.copyWith(isLoading: true));
    final info = await _repository.useSystemLocale();

    emit(
      state.copyWith(
        locale: _toLocale(info.localeCode),
        localeCode: info.localeCode,
        source: AppLanguageSource.system,
        distroId: info.distroId,
        distroFamily: info.distroFamily,
        isLoading: false,
      ),
    );
  }

  Locale _toLocale(String localeCode) {
    final normalized = localeCode.replaceAll('-', '_');
    final parts = normalized.split('_');

    if (parts.length >= 2) {
      return Locale(parts[0].toLowerCase(), parts[1].toUpperCase());
    }

    return Locale(parts.first.toLowerCase());
  }
}
