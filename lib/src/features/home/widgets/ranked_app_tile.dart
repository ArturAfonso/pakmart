

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class RankedAppTile extends StatelessWidget {
  const RankedAppTile({super.key, 
    required this.rank,
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.borderColor,
    required this.isDark,
  });

  final int rank;
  final CategoryAppData app;
  final Color titleColor;
  final Color secondaryColor;
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
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Text(
                  rank.toString().padLeft(2, '0'),
                  style: AppTextStyles.titleMediumNormal.copyWith(
                    color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: app.iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  app.icon,
                  size: 24,
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
                        if (app.verified)
                          const Icon(Icons.verified_outlined, size: 14, color: AppColors.accent),
                      ],
                    ),
                    Text(
                      app.tagline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 17, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text(
                    app.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: titleColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}