
import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key, 
    required this.about,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  final String about;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sobre',
            style: AppTextStyles.titleMediumNormal.copyWith(color: titleColor, fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            about,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor, height: 1.45),
          ),
        ],
      ),
    );
  }
}