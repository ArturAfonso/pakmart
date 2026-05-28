import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/di/injector.dart';
import 'package:pakmart/src/features/apps/bloc/app_info_cubit.dart';
import 'package:pakmart/src/features/apps/bloc/app_info_state.dart';
import 'package:pakmart/src/features/apps/models/app_detail_data.dart';
import 'package:pakmart/src/features/apps/widget/app_links_card.dart';
import 'package:pakmart/src/features/apps/widget/app_screenshot_carousel.dart';
import 'package:pakmart/src/features/apps/screens/install_card_widget.dart';
import 'package:pakmart/src/features/apps/widget/about_card_widget.dart';
import 'package:pakmart/src/features/apps/widget/apphero_section.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_bloc.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_state.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key, required this.appId});

  final String appId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppInfoCubit>()..load(appId),
      child: _AppInfoView(appId: appId),
    );
  }
}

class _AppInfoView extends StatefulWidget {
  const _AppInfoView({required this.appId});

  final String appId;

  @override
  State<_AppInfoView> createState() => _AppInfoViewState();
}

class _AppInfoViewState extends State<_AppInfoView> {
  bool _isMutating = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return BlocBuilder<AppInfoCubit, AppInfoState>(
      builder: (context, state) {
        if (state.status == AppInfoStatus.loading && state.detail == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.detail == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'Aplicativo nao encontrado.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: titleColor),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.read<AppInfoCubit>().load(widget.appId),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        final detail = state.detail!;
        final isInstalled = _isInstalled(detail, context.watch<InstalledAppsBloc>().state);

        return SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 56),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: _handleBack,
                      icon: Icon(Icons.arrow_back_rounded, color: secondaryColor, size: 18),
                      label: Text(
                        'Voltar',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: secondaryColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 18),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 980;
                        final lead = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppHeroSection(
                              app: detail,
                              titleColor: titleColor,
                              secondaryColor: secondaryColor,
                              surfaceColor: surfaceColor,
                              borderColor: borderColor,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 18),
                            _HighlightsWrap(
                              app: detail,
                              titleColor: titleColor,
                              secondaryColor: secondaryColor,
                              surfaceColor: surfaceColor,
                              borderColor: borderColor,
                            ),
                          ],
                        );

                        final aside = InstallCard(
                          app: detail,
                          titleColor: titleColor,
                          secondaryColor: secondaryColor,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          isInstalled: isInstalled,
                          isBusy: _isMutating,
                          onInstallPressed: () => _handleInstall(detail),
                          onOpenPressed: () => _handleOpen(detail),
                          onUninstallPressed: () => _handleUninstall(detail),
                        );

                        if (compact) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [lead, const SizedBox(height: 24), aside],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: lead),
                            const SizedBox(width: 40),
                            SizedBox(width: 340, child: aside),
                          ],
                        );
                      },
                    ),
                    if (detail.screenshots.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      AppScreenshotCarousel(
                        screenshots: detail.screenshots,
                        titleColor: titleColor,
                        secondaryColor: secondaryColor,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                      ),
                    ],
                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 980;
                        final sideWidgets = <Widget>[];

                        if (detail.links.isNotEmpty) {
                          sideWidgets.add(
                            AppLinksCard(
                              links: detail.links,
                              titleColor: titleColor,
                              secondaryColor: secondaryColor,
                              surfaceColor: surfaceColor,
                              borderColor: borderColor,
                            ),
                          );
                        }

                        // Relacionados desativado por ora para manter a feature
                        // de detalhes estritamente baseada em dados remotos validos.
                        // Quando houver endpoint confiavel no Flathub, esta secao
                        // pode ser reativada aqui.

                        if (compact) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AboutCard(
                                app: detail,
                                titleColor: titleColor,
                                secondaryColor: secondaryColor,
                                surfaceColor: surfaceColor,
                                borderColor: borderColor,
                              ),
                              if (sideWidgets.isNotEmpty) ...[const SizedBox(height: 24), ...sideWidgets],
                            ],
                          );
                        }

                        if (sideWidgets.isEmpty) {
                          return AboutCard(
                            app: detail,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AboutCard(
                                app: detail,
                                titleColor: titleColor,
                                secondaryColor: secondaryColor,
                                surfaceColor: surfaceColor,
                                borderColor: borderColor,
                              ),
                            ),
                            const SizedBox(width: 40),
                            SizedBox(width: 340, child: Column(children: sideWidgets)),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isInstalled(AppDetailData detail, InstalledAppsState installedState) {
    if (installedState is! InstalledAppsLoaded) {
      return false;
    }

    for (final app in installedState.data) {
      if (app.id == detail.appId || app.packageName == detail.appId) {
        return true;
      }
    }

    return false;
  }

  Future<void> _handleInstall(AppDetailData detail) async {
    setState(() {
      _isMutating = true;
    });

    final success = await context.read<InstalledAppsBloc>().installApp(detail.appId);

    if (!mounted) {
      return;
    }

    setState(() {
      _isMutating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? '${detail.name} foi instalado com sucesso.' : 'Nao foi possivel instalar ${detail.name}.',
        ),
      ),
    );
  }

  Future<void> _handleOpen(AppDetailData detail) async {
    final success = await context.read<InstalledAppsBloc>().openApp(detail.appId);
    if (!mounted || success) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nao foi possivel abrir ${detail.name}.')));
  }

  Future<void> _handleUninstall(AppDetailData detail) async {
    final installedAppsBloc = context.read<InstalledAppsBloc>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Desinstalar app?'),
          content: Text('Deseja remover ${detail.name} do sistema?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Desinstalar')),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      _isMutating = true;
    });

    final success = await installedAppsBloc.uninstallApp(detail.appId);

    if (!mounted) {
      return;
    }

    setState(() {
      _isMutating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '${detail.name} foi removido do sistema.' : 'Nao foi possivel remover ${detail.name}.'),
      ),
    );
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.HOME);
  }
}

class _HighlightsWrap extends StatelessWidget {
  const _HighlightsWrap({
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  final AppDetailData app;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final compatibility = app.isMobileFriendly && app.supportsDesktop
        ? 'Desktop + Mobile'
        : app.isMobileFriendly
        ? 'Mobile'
        : 'Desktop';
    final sizeValue = app.downloadSizeLabel ?? app.installedSizeLabel ?? '-';
    final sizeCaption = app.installedSizeLabel != null && app.installedSizeLabel != app.downloadSizeLabel
        ? 'Instalado: ${app.installedSizeLabel}'
        : 'Tamanho do pacote';
    final monthlyValue = _formatCompact(app.downloadsLastMonth);
    final monthlyCaption = app.totalInstalls == null
        ? 'Downloads no ultimo mes'
        : '${_formatCompact(app.totalInstalls)} no total';

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        _HighlightCard(
          label: 'Tamanho',
          value: sizeValue,
          caption: sizeCaption,
          icon: Icons.inventory_2_outlined,
          titleColor: titleColor,
          secondaryColor: secondaryColor,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
        ),
        _HighlightCard(
          label: 'Compatibilidade',
          value: compatibility,
          caption: app.runtimeName ?? 'Suporte principal',
          icon: Icons.devices_rounded,
          titleColor: titleColor,
          secondaryColor: secondaryColor,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
        ),
        _HighlightCard(
          label: 'Mensal',
          value: monthlyValue,
          caption: monthlyCaption,
          icon: Icons.ssid_chart_rounded,
          titleColor: titleColor,
          secondaryColor: secondaryColor,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
        ),
      ],
    );
  }

  static String _formatCompact(int? value) {
    if (value == null || value <= 0) {
      return '-';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value >= 10000000 ? 0 : 1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}k';
    }
    return value.toString();
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 250),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: titleColor, size: 20),
            const SizedBox(height: 16),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: secondaryColor, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: titleColor, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(caption, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondaryColor, height: 1.45)),
          ],
        ),
      ),
    );
  }
}
