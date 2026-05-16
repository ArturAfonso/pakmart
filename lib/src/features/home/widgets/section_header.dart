


import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, 
    required this.title,
    required this.subtitle,
    required this.titleColor,
    required this.secondaryColor,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color titleColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleMediumNormal.copyWith(
                  color: titleColor,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
      ],
    );
  }
}