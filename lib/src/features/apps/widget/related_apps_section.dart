



import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/apps/widget/related_app_card.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';

class RelatedAppsSection extends StatelessWidget {
  const RelatedAppsSection({super.key, 
    required this.apps,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.isDark,
  });

  final List<CategoryAppData> apps;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (apps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relacionados',
          style: AppTextStyles.titleMediumNormal.copyWith(color: titleColor, fontSize: 24),
        ),
        const SizedBox(height: 14),
        Column(
          children: [
            for (var index = 0; index < apps.length; index++) ...[
              RelatedAppCard(
                app: apps[index],
                titleColor: titleColor,
                secondaryColor: secondaryColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                isDark: isDark,
              ),
              if (index != apps.length - 1) const SizedBox(height: 12),
            ],
          ],
        ),
      ],
    );
  }
}