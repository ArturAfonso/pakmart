



import 'package:flutter/material.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/widgets/permission_tag_chip.dart';

class PermissionTagsCard extends StatelessWidget {
	const PermissionTagsCard({super.key, 
		required this.data,
		required this.borderColor,
		required this.titleColor,
		required this.secondaryColor,
	});

	final InstalledPermissionTagsData data;
	final Color borderColor;
	final Color titleColor;
	final Color secondaryColor;

	@override
	Widget build(BuildContext context) {
		return Container(
			width: double.infinity,
			padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(22),
				border: Border.all(color: borderColor),
			),
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
						data.subtitle,
						style: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondaryColor),
					),
					const SizedBox(height: 12),
					Wrap(
						spacing: 8,
						runSpacing: 8,
						children: [
							for (final tag in data.tags) PermissionTagChip(label: tag),
							OutlinedButton.icon(
								onPressed: () {},
								style: OutlinedButton.styleFrom(
									side: BorderSide(color: borderColor),
									shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
									foregroundColor: secondaryColor,
								),
								icon: const Icon(Icons.add_rounded, size: 16),
								label: Text(data.addButtonLabel),
							),
						],
					),
				],
			),
		);
	}
}