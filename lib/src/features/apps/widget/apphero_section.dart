


import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';

class AppHeroSection extends StatelessWidget {
  const AppHeroSection({super.key, 
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.isDark,
  });

  final CategoryAppData app;
  final Color titleColor;
  final Color secondaryColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 98,
          height: 98,
          decoration: BoxDecoration(
            color: app.iconBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            app.icon,
            size: 46,
            color: isDark ? AppColors.darkBackground : AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Text(
                    app.name,
                    style: AppTextStyles.titleLargeNormal.copyWith(
                      color: titleColor,
                      fontSize: 44,
                      height: 1.05,
                    ),
                  ),
                  if (app.verified)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_outlined, size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text(
                            'VERIFICADO',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '"${app.tagline}"',
                style: AppTextStyles.bodyLargeItalic.copyWith(color: secondaryColor),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(Icons.star_rounded, size: 18, color: AppColors.accent),
                  Text(
                    app.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    app.ratingCountLabel,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor),
                  ),
                  Text(
                    app.downloadsLabel,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}