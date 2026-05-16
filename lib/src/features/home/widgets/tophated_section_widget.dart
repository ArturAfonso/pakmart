



import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';
import 'package:pakmart/src/features/home/widgets/ranked_app_tile.dart';

class TopRatedSection extends StatelessWidget {
  const TopRatedSection({super.key, 
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Melhor avaliados',
          style: AppTextStyles.titleMediumNormal.copyWith(color: titleColor, fontSize: 30),
        ),
        const SizedBox(height: 4),
        Text(
          'Comunidade que ama de verdade',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
        ),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              for (var index = 0; index < apps.length; index++) ...[
                RankedAppTile(
                  rank: index + 1,
                  app: apps[index],
                  titleColor: titleColor,
                  secondaryColor: secondaryColor,
                  borderColor: borderColor,
                  isDark: isDark,
                ),
                if (index != apps.length - 1) Divider(height: 1, color: borderColor),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
