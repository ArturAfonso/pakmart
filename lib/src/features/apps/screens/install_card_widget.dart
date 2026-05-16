

import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/features/apps/widget/infrow_widget.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';

class InstallCard extends StatelessWidget {
  const InstallCard({super.key, 
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  final CategoryAppData app;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Instalar'),
            ),
          ),
          const SizedBox(height: 18),
          InfoRow(label: 'Desenvolvedor', value: app.publisher, titleColor: titleColor, secondaryColor: secondaryColor),
          InfoRow(label: 'Versão', value: app.version, titleColor: titleColor, secondaryColor: secondaryColor),
          InfoRow(label: 'Tamanho', value: app.size, titleColor: titleColor, secondaryColor: secondaryColor),
          InfoRow(label: 'Licença', value: app.license, titleColor: titleColor, secondaryColor: secondaryColor),
          InfoRow(label: 'Flatpak ID', value: app.flatpakId, titleColor: titleColor, secondaryColor: secondaryColor, monospace: true),
        ],
      ),
    );
  }
}