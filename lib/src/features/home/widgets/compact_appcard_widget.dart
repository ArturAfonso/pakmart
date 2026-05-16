
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class CompactAppCard extends StatelessWidget {
  const CompactAppCard({super.key, 
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
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: app.iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  app.icon,
                  size: 26,
                  color: isDark ? AppColors.darkBackground : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 14),
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
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: titleColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (app.verified)
                          const Icon(Icons.verified_outlined, size: 14, color: AppColors.accent),
                      ],
                    ),
                    Text(
                      app.publisher,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondaryColor),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 15, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          app.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: titleColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '·',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondaryColor),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            app.categoryLabel,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondaryColor),
                          ),
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
