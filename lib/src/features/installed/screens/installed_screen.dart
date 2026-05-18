import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_bloc.dart';
import 'package:pakmart/src/features/installed/bloc/installed_apps_state.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/widgets/Installed_app_tile.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class InstalledScreen extends StatelessWidget {
  const InstalledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 56),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUA BIBLIOTECA PESSOAL',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 4,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aplicativos instalados',
                  style: AppTextStyles.titleLargeNormal.copyWith(color: titleColor, fontSize: 54, height: 1.05),
                ),
                const SizedBox(height: 12),
                Text(
                  'Abra, gerencie permissões ou remova os apps que vivem no seu sistema.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor),
                ),
                const SizedBox(height: 40),
                BlocBuilder<InstalledAppsBloc, InstalledAppsState>(
                  builder: (context, state) {
                    if (state is InstalledAppsLoading) {
                  return Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
                }if (state is InstalledAppsLoaded) {
          final apps = state.data;
          return Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: borderColor),
                  ),
                  child: apps.isNotEmpty ? Column(
                    children: [
                      for (var index = 0; index < apps.length; index++) ...[
                        InstalledAppTile(app: apps[index]),
                        if (index != apps.length - 1) Divider(height: 1, color: borderColor),
                      ],
                    ],
                  ) : Container(),
                );
        } else if (state is InstalledAppsError) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(state.message),
              ElevatedButton(
                onPressed: () => context.read<InstalledAppsBloc>().refresh(),
                child: Text('Tentar novamente'),
              ),
            ],
          );
        }  return SizedBox.shrink();
                  },
                ),
                /* Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: borderColor),
                  ),
                  child: apps.isNotEmpty ? Column(
                    children: [
                      for (var index = 0; index < apps.length; index++) ...[
                        InstalledAppTile(app: apps[index]),
                        if (index != apps.length - 1) Divider(height: 1, color: borderColor),
                      ],
                    ],
                  ) : Container(),
                ), */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
