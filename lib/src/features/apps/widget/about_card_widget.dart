import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/apps/models/app_detail_data.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({
    super.key,
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  final AppDetailData app;
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
          Text('Sobre', style: AppTextStyles.titleMediumNormal.copyWith(color: titleColor, fontSize: 24)),
          const SizedBox(height: 10),
          Text(
            app.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor, height: 1.55),
          ),
          if (app.latestReleaseVersion != null || app.latestReleaseDescription != null) ...[
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surfaceColor.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.latestReleaseVersion == null ? 'Release recente' : 'Release ${app.latestReleaseVersion}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: titleColor, fontWeight: FontWeight.w700),
                  ),
                  if (app.latestReleaseDescription != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      app.latestReleaseDescription!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor, height: 1.5),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
