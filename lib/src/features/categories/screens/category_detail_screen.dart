import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/categories/data/categories_data.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';
import 'package:pakmart/src/features/categories/widgets/category_app_card_widget.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final category = CategoriesData.byId(categoryId);
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    if (category == null) {
      return Center(
        child: Text(
          'Categoria não encontrada.',
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
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.CATEGORIES);
                    }
                  },
                  icon: Icon(Icons.arrow_back_rounded, color: secondaryColor, size: 18),
                  label: Text(
                    'Categorias',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(category.icon, size: 58, color: category.iconColor),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRATELEIRA',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: secondaryColor,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.title,
                            style: AppTextStyles.titleLargeNormal.copyWith(
                              color: titleColor,
                              fontSize: 54,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.description,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final columns = width >= 960 ? 2 : 1;
                    final spacing = 16.0;
                    final cardWidth = (width - ((columns - 1) * spacing)) / columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (final app in category.apps)
                          SizedBox(
                            width: cardWidth,
                            child: CategoryAppCard(
                              app: app,
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
