


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';

class PreferenceSection extends StatelessWidget {
  const PreferenceSection({super.key, 
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMediumNormal.copyWith(color: titleColor, fontSize: 26),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}