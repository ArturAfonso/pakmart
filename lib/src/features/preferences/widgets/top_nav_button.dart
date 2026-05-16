


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';

class TopNavButton extends StatelessWidget {
  const TopNavButton({super.key, 
    required this.label,
    required this.selected,
    this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final color = selected
        ? isDark
            ? AppColors.darkTextPrimary
            : AppColors.textPrimary
        : isDark
            ? AppColors.darkTextSecondary
            : AppColors.textSecondary;

    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
      ),
    );
  }
}