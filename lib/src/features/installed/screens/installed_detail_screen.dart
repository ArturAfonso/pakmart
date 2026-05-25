import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_bloc.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_state.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/widgets/installed_app_summary_card.dart';
import 'package:pakmart/src/features/installed/widgets/permissions_card.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class InstalledDetailScreen extends StatefulWidget {
  const InstalledDetailScreen({super.key, required this.appId, this.actualApp});

  final String appId;
  final InstalledAppData? actualApp;

  @override
  State<InstalledDetailScreen> createState() => _InstalledDetailScreenState();
}

class _InstalledDetailScreenState extends State<InstalledDetailScreen> {
  late final InstalledAppData? _app;
  late final Map<String, bool> _toggleValues;

  @override
  void initState() {
    super.initState();
    _app = widget.actualApp ?? _findAppInBlocState(widget.appId);
    _toggleValues = _buildToggleValues(_app);
  }

  @override
  Widget build(BuildContext context) {
    final app = _app;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    if (app == null) {
      return Center(
        child: Text(
          'Aplicativo não encontrado.',
          style: AppTextStyles.bodyLarge.copyWith(color: titleColor),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 56),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.INSTALLED);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: secondaryColor,
                    size: 18,
                  ),
                  label: Text(
                    'Instalados',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 1080;

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InstalledAppSummaryCard(
                            app: app,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            borderColor: borderColor,
                            surfaceColor: surfaceColor,
                            isDark: isDark,
                            onUninstalled: _handleAppUninstalled,
                          ),
                          const SizedBox(height: 24),
                          PermissionsCard(
                            app: app,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            borderColor: borderColor,
                            surfaceColor: surfaceColor,
                            toggleValues: _toggleValues,
                            onToggleChanged: (key, value) {
                              setState(() {
                                _toggleValues[key] = value;
                              });
                            },
                            isDark: isDark,
                          ),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300,
                          child: InstalledAppSummaryCard(
                            app: app,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            borderColor: borderColor,
                            surfaceColor: surfaceColor,
                            isDark: isDark,
                            onUninstalled: _handleAppUninstalled,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: PermissionsCard(
                            app: app,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            borderColor: borderColor,
                            surfaceColor: surfaceColor,
                            toggleValues: _toggleValues,
                            onToggleChanged: (key, value) {
                              setState(() {
                                _toggleValues[key] = value;
                              });
                            },
                            isDark: isDark,
                          ),
                        ),
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
  }

  static Map<String, bool> _buildToggleValues(InstalledAppData? app) {
    if (app == null) {
      return {};
    }

    final values = <String, bool>{};

    for (final section in app.permissionSections) {
      for (final entry in section.entries) {
        if (entry is InstalledPermissionToggleData) {
          values[entry.permissionKey] = entry.enabled;
        }
      }
    }

    return values;
  }

  InstalledAppData? _findAppInBlocState(String appId) {
    final state = context.read<InstalledAppsBloc>().state;
    if (state is! InstalledAppsLoaded) {
      return null;
    }

    for (final app in state.data) {
      if (app.id == appId) {
        return app;
      }
    }

    return null;
  }

  Future<void> _handleAppUninstalled(InstalledAppData app) async {
    await context.read<InstalledAppsBloc>().refresh();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${app.name} foi desinstalado com sucesso.')),
    );

    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.INSTALLED);
  }
}
