


import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';

class InfoPromoCard extends StatelessWidget {
  const InfoPromoCard({super.key, 
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.onPressed,
  });

  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saiba mais',
          style: AppTextStyles.titleMediumNormal.copyWith(color: titleColor, fontSize: 30),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surfaceColor.withValues(alpha: 0.74),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SANDBOX FLATPAK',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: secondaryColor,
                      letterSpacing: 2.4,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cada app vive em sua\nprópria sala silenciosa.',
                style: AppTextStyles.titleMediumNormal.copyWith(color: titleColor, height: 1.2),
              ),
              const SizedBox(height: 14),
              Text(
                'Veja e gerencie as permissões de cada aplicativo instalado — rede, arquivos, dispositivos — com clareza e tranquilidade.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor, height: 1.45),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: onPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver instalados',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.accent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}