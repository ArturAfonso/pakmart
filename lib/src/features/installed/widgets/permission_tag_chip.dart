




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';

class PermissionTagChip extends StatelessWidget {
	const PermissionTagChip({super.key, required this.label});

	final String label;

	@override
	Widget build(BuildContext context) {
		final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
		final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
		final textColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(999),
				border: Border.all(color: borderColor),
			),
			child: Text(
				label,
				style: Theme.of(context).textTheme.bodySmall?.copyWith(
							color: textColor,
							fontFamily: 'monospace',
						),
			),
		);
	}
}
