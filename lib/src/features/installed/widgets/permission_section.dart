


import 'package:flutter/material.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/widgets/permission_tags_card.dart';
import 'package:pakmart/src/features/installed/widgets/permission_toggle_card.dart';

class PermissionSection extends StatelessWidget {
	const PermissionSection({super.key, 
		required this.section,
		required this.borderColor,
		required this.titleColor,
		required this.secondaryColor,
		required this.toggleValues,
		required this.onToggleChanged,
		required this.isDark,
	});

	final InstalledPermissionSectionData section;
	final Color borderColor;
	final Color titleColor;
	final Color secondaryColor;
	final Map<String, bool> toggleValues;
	final void Function(String key, bool value) onToggleChanged;
	final bool isDark;

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(
					'${section.index} ${section.title}',
					style: Theme.of(context).textTheme.labelSmall?.copyWith(
								color: secondaryColor,
								fontWeight: FontWeight.w700,
								letterSpacing: 3,
							),
				),
				const SizedBox(height: 14),
				Column(
					children: [
						for (var index = 0; index < section.entries.length; index++) ...[
							if (section.entries[index] case final InstalledPermissionToggleData toggle)
								PermissionToggleCard(
									data: toggle,
									value: toggleValues[toggle.permissionKey] ?? toggle.enabled,
									onChanged: (value) => onToggleChanged(toggle.permissionKey, value),
									borderColor: borderColor,
									titleColor: titleColor,
									secondaryColor: secondaryColor,
									isDark: isDark,
								)
							else if (section.entries[index] case final InstalledPermissionTagsData tags)
								PermissionTagsCard(
									data: tags,
									borderColor: borderColor,
									titleColor: titleColor,
									secondaryColor: secondaryColor,
								),
							if (index != section.entries.length - 1)
								const SizedBox(height: 10),
						],
					],
				),
			],
		);
	}
}