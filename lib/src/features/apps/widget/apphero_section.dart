import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/apps/models/app_detail_data.dart';

class AppHeroSection extends StatelessWidget {
  const AppHeroSection({
    super.key,
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.isDark,
  });

  final AppDetailData app;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final gradientStart = (app.heroGradientStart ?? app.iconBackground).withValues(alpha: isDark ? 0.2 : 0.16);
    final gradientEnd = (app.heroGradientEnd ?? surfaceColor).withValues(alpha: isDark ? 0.12 : 0.92);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gradientStart, gradientEnd],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final icon = Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(color: app.iconBackground, borderRadius: BorderRadius.circular(28)),
            child: _AppIconArt(imageUrl: app.iconUrl, fallbackIcon: app.fallbackIcon, isDark: isDark),
          );

          final text = _AppDetailsText(app: app, titleColor: titleColor, secondaryColor: secondaryColor);

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [icon, const SizedBox(height: 18), text],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: 22),
              Expanded(child: text),
            ],
          );
        },
      ),
    );
  }
}

class _AppDetailsText extends StatelessWidget {
  const _AppDetailsText({required this.app, required this.titleColor, required this.secondaryColor});

  final AppDetailData app;
  final Color titleColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Text(
              app.name,
              style: AppTextStyles.titleLargeNormal.copyWith(color: titleColor, fontSize: 42, height: 1.02),
            ),
            if (app.verified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_outlined, size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      'VERIFICADO',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              app.developerName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: titleColor, fontWeight: FontWeight.w700),
            ),
            if (app.categoryLabel != null) _TagBadge(label: app.categoryLabel!, color: secondaryColor),
            if (app.version != null) _TagBadge(label: 'v${app.version}', color: secondaryColor),
          ],
        ),
        const SizedBox(height: 14),
        Text('"${app.tagline}"', style: AppTextStyles.bodyLargeItalic.copyWith(color: secondaryColor, height: 1.4)),
      ],
    );
  }
}

class _TagBadge extends StatelessWidget {
  const _TagBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(999)),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _AppIconArt extends StatelessWidget {
  const _AppIconArt({required this.imageUrl, required this.fallbackIcon, required this.isDark});

  final String? imageUrl;
  final IconData? fallbackIcon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback(),
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }

            return Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.expectedTotalBytes == null
                      ? null
                      : progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
                ),
              ),
            );
          },
        ),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Icon(
      fallbackIcon ?? Icons.apps_rounded,
      size: 48,
      color: isDark ? AppColors.darkBackground : AppColors.textPrimary,
    );
  }
}
