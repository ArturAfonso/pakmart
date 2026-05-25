import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/features/installed/widgets/summary_row.dart';

class InstalledAppSummaryCard extends StatelessWidget {
  const InstalledAppSummaryCard({
    super.key,
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.borderColor,
    required this.surfaceColor,
    required this.isDark,
    this.onUninstalled,
  });

  final InstalledAppData app;
  final Color titleColor;
  final Color secondaryColor;
  final Color borderColor;
  final Color surfaceColor;
  final bool isDark;
  final Future<void> Function(InstalledAppData app)? onUninstalled;

  Future<void> openApp(InstalledAppData app) async {
    try {
      await Process.start('flatpak', [
        'run',
        app.packageName,
      ], mode: ProcessStartMode.detached);
    } catch (e) {
      debugPrint('Erro: $e');
    }
  }

  Future<bool> uninstallApp(InstalledAppData app) async {
    try {
      final result = await Process.run('flatpak', [
        'uninstall',
        '--noninteractive',
        app.packageName,
      ]);

      if (result.exitCode == 0) {
        debugPrint('App desinstalado com sucesso');
        return true;
      } else {
        debugPrint('Erro ao desinstalar: ${result.stderr}');
        return false;
      }
    } catch (e) {
      debugPrint('Erro: $e');
      return false;
    }
  }

  Future<void> onDeletePressed(
    BuildContext context,
    InstalledAppData contextApp,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Desinstalar app?'),
        content: Text('Deseja remover ${contextApp.name} do sistema?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Desinstalar'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    final wasUninstalled = await uninstallApp(contextApp);

    if (!context.mounted) {
      return;
    }

    if (wasUninstalled) {
      await onUninstalled?.call(contextApp);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nao foi possivel desinstalar ${contextApp.name}.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final destructiveColor = const Color(0xFFFF5A5F);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: app.iconBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: _buildAppIcon(),
          ),
          const SizedBox(height: 18),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              Text(
                app.name,
                style: AppTextStyles.titleMediumNormal.copyWith(
                  color: titleColor,
                  fontSize: 24,
                ),
              ),
              const Icon(
                Icons.verified_outlined,
                size: 16,
                color: AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '"${app.tagline}"',
            style: AppTextStyles.bodyLargeItalic.copyWith(
              color: secondaryColor,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                openApp(app);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: const Text('Abrir aplicativo'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                onDeletePressed(context, app);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: destructiveColor,
                side: BorderSide(
                  color: destructiveColor.withValues(alpha: 0.4),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Remover'),
            ),
          ),
          const SizedBox(height: 18),
          Divider(color: borderColor),
          const SizedBox(height: 14),
          SummaryRow(label: 'Versão', value: app.version),
          SummaryRow(label: 'Tamanho', value: app.size),
          SummaryRow(label: 'Licença', value: app.license),
          SummaryRow(label: 'Categoria', value: app.category),
          SummaryRow(label: 'Flatpak', value: app.packageName, monospace: true),
        ],
      ),
    );
  }

  Widget _buildAppIcon() {
    final url = app.icon?.url;
    final fallback = Icon(
      Icons.abc,
      size: 48,
      color: isDark ? AppColors.darkBackground : AppColors.textPrimary,
    );

    if (url == null || url.isEmpty) {
      return fallback;
    }

    final isSvg = url.toLowerCase().endsWith('.svg');

    if (url.startsWith('file://')) {
      if (isSvg) {
        return SvgPicture.file(
          File.fromUri(Uri.parse(url)),
          fit: BoxFit.contain,
          placeholderBuilder: (context) => fallback,
        );
      }

      return Image.file(
        File.fromUri(Uri.parse(url)),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }

    if (isSvg) {
      return SvgPicture.network(
        url,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => fallback,
      );
    }

    return Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }
}
