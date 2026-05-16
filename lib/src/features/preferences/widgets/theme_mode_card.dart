




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';

class ThemeModeCard extends StatelessWidget {
  const ThemeModeCard({super.key, 
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.darkPreview,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final bool darkPreview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final borderColor = selected
        ? AppColors.accent
        : isDark
            ? AppColors.darkBorder
            : AppColors.border;
    final backgroundColor = darkPreview ? const Color(0xFF201A17) : AppColors.surface;
    final titleColor = darkPreview ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final subtitleColor = darkPreview ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(color: titleColor),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: subtitleColor),
            ),
          ],
        ),
      ),
    );
  }
}