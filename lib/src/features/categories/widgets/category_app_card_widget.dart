


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class CategoryAppCard extends StatelessWidget {
  const CategoryAppCard({super.key, 
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.isDark,
  });

  final CategoryAppData app;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRoutes.APP_INFO,
          pathParameters: {AppRoutes.appIdParam: app.id},
        ),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: app.iconBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  app.icon,
                  size: 30,
                  color: isDark ? AppColors.darkBackground : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        Text(
                          app.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: titleColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const Icon(Icons.verified_outlined, size: 15, color: AppColors.accent),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.publisher,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          app.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: titleColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '·',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          app.categoryLabel,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}