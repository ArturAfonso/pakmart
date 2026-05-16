import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/apps/screens/install_card_widget.dart';
import 'package:pakmart/src/features/apps/widget/about_card_widget.dart';
import 'package:pakmart/src/features/apps/widget/apphero_section.dart';
import 'package:pakmart/src/features/apps/widget/related_apps_section.dart';
import 'package:pakmart/src/features/categories/data/categories_data.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key, required this.appId});

  final String appId;

  @override
  Widget build(BuildContext context) {
    final app = CategoriesData.appById(appId);
    final category = CategoriesData.categoryByAppId(appId);
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
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

    final relatedApps = category == null
        ? <CategoryAppData>[]
        : category.apps.where((relatedApp) => relatedApp.id != app.id).toList();

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
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else if (category != null) {
                      context.goNamed(
                        AppRoutes.CATEGORY_DETAILS,
                        pathParameters: {AppRoutes.categoryIdParam: category.id},
                      );
                    } else {
                      context.goNamed(AppRoutes.HOME);
                    }
                  },
                  icon: Icon(Icons.arrow_back_rounded, color: secondaryColor, size: 18),
                  label: Text(
                    'Voltar',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 960;

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppHeroSection(
                            app: app,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 24),
                          InstallCard(
                            app: app,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                          ),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppHeroSection(
                            app: app,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 40),
                        SizedBox(
                          width: 330,
                          child: InstallCard(
                            app: app,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 960;

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AboutCard(
                            about: app.about,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                          ),
                          if (relatedApps.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            RelatedAppsSection(
                              apps: relatedApps,
                              titleColor: titleColor,
                              secondaryColor: secondaryColor,
                              surfaceColor: surfaceColor,
                              borderColor: borderColor,
                              isDark: isDark,
                            ),
                          ],
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AboutCard(
                            about: app.about,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                          ),
                        ),
                        const SizedBox(width: 40),
                        SizedBox(
                          width: 330,
                          child: RelatedAppsSection(
                            apps: relatedApps,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
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
}



