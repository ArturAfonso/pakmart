



import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';

class PermissionToggleCard extends StatelessWidget {
	const PermissionToggleCard({super.key, 
		required this.data,
		required this.value,
		required this.onChanged,
		required this.borderColor,
		required this.titleColor,
		required this.secondaryColor,
		required this.isDark,
	});

	final InstalledPermissionToggleData data;
	final bool value;
	final ValueChanged<bool> onChanged;
	final Color borderColor;
	final Color titleColor;
	final Color secondaryColor;
	final bool isDark;

	@override
	Widget build(BuildContext context) {
		final leadingIcon = switch (data.severity) {
			PermissionSeverity.warning => Icons.warning_amber_rounded,
			PermissionSeverity.danger => Icons.warning_rounded,
			PermissionSeverity.normal => null,
		};

		final leadingColor = switch (data.severity) {
			PermissionSeverity.warning => const Color(0xFFF0B14A),
			PermissionSeverity.danger => const Color(0xFFFF5A5F),
			PermissionSeverity.normal => secondaryColor,
		};

		final lines = data.subtitle.split('\n');
		final description = lines.first;
		final permissionKeyLabel = lines.length > 1 ? lines.last : null;

		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(22),
				border: Border.all(color: borderColor),
			),
			child: Row(
				children: [
					if (leadingIcon != null) ...[
						Icon(leadingIcon, size: 18, color: leadingColor),
						const SizedBox(width: 10),
					],
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									data.title,
									style: Theme.of(context).textTheme.titleSmall?.copyWith(
												color: titleColor,
												fontWeight: FontWeight.w700,
											),
								),
								const SizedBox(height: 2),
								Text(
									description,
									style: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondaryColor),
								),
								if (permissionKeyLabel != null) ...[
									const SizedBox(height: 2),
									Text(
										permissionKeyLabel,
										style: Theme.of(context).textTheme.bodySmall?.copyWith(
													color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
													fontFamily: 'monospace',
												),
									),
								],
							],
						),
					),
					const SizedBox(width: 16),
					Switch.adaptive(
						value: value,
						onChanged: onChanged,
						activeThumbColor: AppColors.accent,
						activeTrackColor: AppColors.accent.withValues(alpha: 0.35),
					),
				],
			),
		);
	}
}