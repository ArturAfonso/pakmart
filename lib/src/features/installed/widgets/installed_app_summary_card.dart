


import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/widgets/summary_row.dart';

class InstalledAppSummaryCard extends StatelessWidget {
	const InstalledAppSummaryCard({super.key, 
		required this.app,
		required this.titleColor,
		required this.secondaryColor,
		required this.borderColor,
		required this.surfaceColor,
		required this.isDark,
	});

	final InstalledAppData app;
	final Color titleColor;
	final Color secondaryColor;
	final Color borderColor;
	final Color surfaceColor;
	final bool isDark;

	@override
	Widget build(BuildContext context) {
		final destructiveColor = const Color(0xFFFF5A5F);

		return Container(
			padding: const EdgeInsets.all(22),
			decoration: BoxDecoration(
				color: surfaceColor,
				borderRadius: BorderRadius.circular(28),
				border: Border.all(color: borderColor),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Container(
						width: 92,
						height: 92,
						decoration: BoxDecoration(
							color: app.iconBackground,
							borderRadius: BorderRadius.circular(24),
						),
						child: Icon(
							Icons.abc,
							size: 48,
							color: isDark ? AppColors.darkBackground : AppColors.textPrimary,
						),
					),
					const SizedBox(height: 18),
					Wrap(
						crossAxisAlignment: WrapCrossAlignment.center,
						spacing: 6,
						runSpacing: 4,
						children: [
							Text(
								app.name,
								style: AppTextStyles.titleMediumNormal.copyWith(
									color: titleColor,
									fontSize: 24,
								),
							),
							const Icon(Icons.verified_outlined, size: 16, color: AppColors.accent),
						],
					),
					const SizedBox(height: 4),
					Text(
						'"${app.tagline}"',
						style: AppTextStyles.bodyLargeItalic.copyWith(
							color: secondaryColor,
							height: 1.35,
						),
					),
					const SizedBox(height: 20),
					SizedBox(
						width: double.infinity,
						child: FilledButton.icon(
							onPressed: () {},
							style: FilledButton.styleFrom(
								backgroundColor: AppColors.accent,
								foregroundColor: Colors.white,
								padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
							),
							icon: const Icon(Icons.open_in_new_rounded, size: 18),
							label: const Text('Abrir aplicativo'),
						),
					),
					const SizedBox(height: 10),
					SizedBox(
						width: double.infinity,
						child: OutlinedButton.icon(
							onPressed: () {},
							style: OutlinedButton.styleFrom(
								foregroundColor: destructiveColor,
								side: BorderSide(color: destructiveColor.withValues(alpha: 0.4)),
								padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
							),
							icon: const Icon(Icons.delete_outline_rounded, size: 18),
							label: const Text('Remover'),
						),
					),
					const SizedBox(height: 18),
					Divider(color: borderColor),
					const SizedBox(height: 14),
					SummaryRow(label: 'Versão', value: app.version),
					SummaryRow(label: 'Tamanho', value: app.size),
					SummaryRow(label: 'Licença', value: app.license),
					SummaryRow(label: 'Categoria', value: app.category),
					SummaryRow(label: 'Flatpak', value: app.packageName, monospace: true),
				],
			),
		);
	}
}