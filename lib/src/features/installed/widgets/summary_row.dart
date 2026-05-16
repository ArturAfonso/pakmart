


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';

class SummaryRow extends StatelessWidget {
	const SummaryRow({super.key, required this.label, required this.value, this.monospace = false});

	final String label;
	final String value;
	final bool monospace;

	@override
	Widget build(BuildContext context) {
		final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
		final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
		final valueColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

		return Padding(
			padding: const EdgeInsets.symmetric(vertical: 6),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Expanded(
						child: Text(
							label,
							style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: labelColor),
						),
					),
					const SizedBox(width: 12),
					Flexible(
						child: Text(
							value,
							textAlign: TextAlign.right,
							style: (monospace ? Theme.of(context).textTheme.bodySmall : Theme.of(context).textTheme.bodyMedium)
									?.copyWith(
								color: valueColor,
								fontWeight: FontWeight.w600,
								height: 1.4,
							),
						),
					),
				],
			),
		);
	}
}