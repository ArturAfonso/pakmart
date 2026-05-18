import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/locale/app_language_cubit.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/preferences/widgets/check_preference_tile.dart';
import 'package:pakmart/src/features/preferences/widgets/choice_preference_tile.dart';
import 'package:pakmart/src/features/preferences/widgets/preference_section.dart';
import 'package:pakmart/src/features/preferences/widgets/switch_preference_tile.dart';
import 'package:pakmart/src/features/preferences/widgets/theme_mode_card.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _searchInSummary = false;
  bool _searchInDescription = false;
  bool _showUnverified = true;
  String _selectedSource = 'flathub';

  static const Map<String, String> _languageTitles = {
    'pt_BR': 'Portugues (Brasil)',
    'en_US': 'English (United States)',
    'es_ES': 'Espanol (Espana)',
  };

  String _languageSubtitle(String localeCode) {
    switch (localeCode) {
      case 'pt_BR':
        return 'Interface em portugues brasileiro';
      case 'en_US':
        return 'Interface in English';
      case 'es_ES':
        return 'Interfaz en espanol';
      default:
        return 'Idioma personalizado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 56),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AJUSTES PESSOAIS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 4,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Preferências',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: titleColor,
                    fontSize: 54,
                    height: 1.05,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 36),
                PreferenceSection(
                  title: 'Pesquisa',
                  description: 'O titulo do app é sempre buscado. Ative para procurar mais a fundo (mais lento).',
                  child: Column(
                    children: [
                      CheckPreferenceTile(
                        title: 'Pesquisar no resumo dos pacotes',
                        subtitle: 'Lê uma linha curta de descrição (lento)',
                        value: _searchInSummary,
                        onChanged: (value) => setState(() => _searchInSummary = value),
                      ),
                      const SizedBox(height: 12),
                      CheckPreferenceTile(
                        title: 'Pesquisar na descrição completa',
                        subtitle: 'Lê o texto longo de cada app (mais lento)',
                        value: _searchInDescription,
                        onChanged: (value) => setState(() => _searchInDescription = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                PreferenceSection(
                  title: 'Confiança',
                  description: 'Controle a visibilidade de aplicativos não verificados pelo Flathub.',
                  child: SwitchPreferenceTile(
                    title: 'Mostrar Flatpaks não verificados',
                    subtitle: 'Recomendado para usuários avançados',
                    value: _showUnverified,
                    onChanged: (value) => setState(() => _showUnverified = value),
                  ),
                ),
                const SizedBox(height: 36),
                PreferenceSection(
                  title: 'Fonte de dados',
                  description: 'De onde a Livraria deve carregar os apps.',
                  child: Column(
                    children: [
                      ChoicePreferenceTile(
                        title: 'Flathub',
                        subtitle: 'Padrão',
                        selected: _selectedSource == 'flathub',
                        onTap: () => setState(() => _selectedSource = 'flathub'),
                      ),
                      const SizedBox(height: 12),
                      ChoicePreferenceTile(
                        title: 'Flathub Beta',
                        subtitle: 'Pacotes em teste',
                        selected: _selectedSource == 'beta',
                        onTap: () => setState(() => _selectedSource = 'beta'),
                      ),
                      const SizedBox(height: 12),
                      ChoicePreferenceTile(
                        title: 'Repositórios Debian (apt)',
                        subtitle: 'Em breve',
                        selected: false,
                        enabled: false,
                      ),
                      const SizedBox(height: 12),
                      ChoicePreferenceTile(
                        title: 'Ubuntu Universe',
                        subtitle: 'Em breve',
                        selected: false,
                        enabled: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                BlocBuilder<AppLanguageCubit, AppLanguageState>(
                  builder: (context, languageState) {
                    return PreferenceSection(
                      title: 'Idioma do app',
                      description:
                          'O padrao inicial usa o idioma do sistema. Depois da primeira escolha manual, ela passa a prevalecer.',
                      child: Column(
                        children: [
                          ChoicePreferenceTile(
                            title: 'Usar idioma do sistema',
                            subtitle: 'Atual: ${languageState.localeCode} (${languageState.distroFamily})',
                            selected: languageState.source == AppLanguageSource.system,
                            onTap: () => context.read<AppLanguageCubit>().useSystemLanguage(),
                          ),
                          const SizedBox(height: 12),
                          for (final entry in _languageTitles.entries) ...[
                            ChoicePreferenceTile(
                              title: entry.value,
                              subtitle: _languageSubtitle(entry.key),
                              selected:
                                  languageState.source == AppLanguageSource.manual &&
                                  languageState.localeCode == entry.key,
                              onTap: () => context.read<AppLanguageCubit>().setManualLanguage(entry.key),
                            ),
                            if (entry.key != _languageTitles.keys.last) const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 36),
                PreferenceSection(
                  title: 'Aparência',
                  description: 'Tema visual da loja.',
                  child: Row(
                    children: [
                      Expanded(
                        child: ThemeModeCard(
                          title: 'Claro',
                          subtitle: 'Papel quente, padrão',
                          selected: !isDark,
                          darkPreview: false,
                          onTap: () {
                            if (isDark) {
                              context.read<ThemeCubit>().toggleTheme();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ThemeModeCard(
                          title: 'Escuro',
                          subtitle: 'Tinta noturna',
                          selected: isDark,
                          darkPreview: true,
                          onTap: () {
                            if (!isDark) {
                              context.read<ThemeCubit>().toggleTheme();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
