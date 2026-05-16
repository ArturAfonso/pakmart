


import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/widgets/permission_section.dart';

class PermissionsCard extends StatelessWidget {
	const PermissionsCard({super.key, 
		required this.app,
		required this.titleColor,
		required this.secondaryColor,
		required this.borderColor,
		required this.surfaceColor,
		required this.toggleValues,
		required this.onToggleChanged,
		required this.isDark,
	});

	final InstalledAppData app;
	final Color titleColor;
	final Color secondaryColor;
	final Color borderColor;
	final Color surfaceColor;
	final Map<String, bool> toggleValues;
	final void Function(String key, bool value) onToggleChanged;
	final bool isDark;

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				color: surfaceColor,
				borderRadius: BorderRadius.circular(28),
				border: Border.all(color: borderColor),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Padding(
						padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Expanded(
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(
												'Permissões',
												style: AppTextStyles.titleMediumNormal.copyWith(
													color: titleColor,
													fontSize: 24,
												),
											),
											const SizedBox(height: 4),
											Text(
												'Controle o que ${app.name} pode acessar no seu sistema',
												style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
											),
										],
									),
								),
								Container(
									padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
									decoration: BoxDecoration(
										color: AppColors.success.withValues(alpha: 0.18),
										borderRadius: BorderRadius.circular(999),
									),
									child: Text(
										app.sandboxLabel,
										style: Theme.of(context).textTheme.labelSmall?.copyWith(
													color: AppColors.success,
													fontWeight: FontWeight.w700,
													letterSpacing: 1.4,
												),
									),
								),
							],
						),
					),
					Divider(height: 1, color: borderColor),
					Padding(
						padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								for (var sectionIndex = 0; sectionIndex < app.permissionSections.length; sectionIndex++) ...[
									PermissionSection(
										section: app.permissionSections[sectionIndex],
										borderColor: borderColor,
										titleColor: titleColor,
										secondaryColor: secondaryColor,
										toggleValues: toggleValues,
										onToggleChanged: onToggleChanged,
										isDark: isDark,
									),
									if (sectionIndex != app.permissionSections.length - 1)
										const SizedBox(height: 28),
								],
							],
						),
					),
				],
			),
		);
	}
}