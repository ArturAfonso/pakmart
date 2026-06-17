


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/features/categories/models/category_remote_models.dart';
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

  final CategoryShelfAppData app;
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
          pathParameters: {AppRoutes.appIdParam: app.appId},
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
                  color: isDark ? const Color(0xFF2A2D40) : const Color(0xFFE8F3FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: app.iconUrl == null
                      ? Icon(
                          Icons.apps_rounded,
                          size: 30,
                          color: isDark ? AppColors.darkBackground : AppColors.textPrimary,
                        )
                      : Image.network(
                          app.iconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.apps_rounded,
                            size: 30,
                            color: isDark ? AppColors.darkBackground : AppColors.textPrimary,
                          ),
                        ),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: titleColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (app.verified) const Icon(Icons.verified_outlined, size: 15, color: AppColors.accent),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.publisher,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          app.installsLastMonth == null ? 'Sem dados' : _formatNumber(app.installsLastMonth!),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: titleColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '·',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          app.mainCategory ?? 'Geral',
                          overflow: TextOverflow.ellipsis,
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

  String _formatNumber(int value) {
    final digits = value.toString();
    if (digits.length <= 3) {
      return digits;
    }

    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      final reverseIndex = digits.length - index;
      buffer.write(digits[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }
}