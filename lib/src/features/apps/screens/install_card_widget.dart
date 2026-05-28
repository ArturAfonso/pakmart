import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/features/apps/models/app_detail_data.dart';
import 'package:pakmart/src/features/apps/widget/infrow_widget.dart';

class InstallCard extends StatelessWidget {
  const InstallCard({
    super.key,
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.isInstalled,
    required this.isBusy,
    required this.isInstalling,
    required this.isUninstalling,
    required this.onInstallPressed,
    required this.onOpenPressed,
    required this.onUninstallPressed,
  });

  final AppDetailData app;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final bool isInstalled;
  final bool isBusy;
  final bool isInstalling;
  final bool isUninstalling;
  final VoidCallback onInstallPressed;
  final VoidCallback onOpenPressed;
  final VoidCallback onUninstallPressed;

  @override
  Widget build(BuildContext context) {
    final canInstall = !isBusy;
    final displayInstalledState = isInstalled || isUninstalling;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (displayInstalledState)
            Center(child: Image.asset('assets/icons/installed_icon.png', width: 100, height: 100))
          else
            Center(child: Image.asset('assets/icons/dlownlod icon.png', width: 100, height: 100)),
          const SizedBox(height: 5),
          !displayInstalledState
              ? Center(
                  child: Text(
                    'Disponível para download.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor, height: 1.45),
                  ),
                )
              : Center(
                  child: Text(
                    isUninstalling ? 'Desinstalando aplicativo...' : 'Aplicativo instalado.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor, height: 1.45),
                  ),
                ),
          const SizedBox(height: 8),
          if (displayInstalledState)
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: isBusy ? null : onOpenPressed,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text('Abrir app'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: isBusy ? null : onUninstallPressed,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5A5F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    icon: isUninstalling
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(isUninstalling ? 'Desinstalando...' : 'Desinstalar'),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: canInstall ? onInstallPressed : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                icon: isInstalling
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.download_rounded, size: 18),
                label: Text(isInstalling ? 'Instalando...' : 'Instalar'),
              ),
            ),
          const SizedBox(height: 18),
          InfoRow(
            label: 'Desenvolvedor',
            value: app.developerName,
            titleColor: titleColor,
            secondaryColor: secondaryColor,
          ),
          if (app.version != null)
            InfoRow(label: 'Versao', value: app.version!, titleColor: titleColor, secondaryColor: secondaryColor),
          if (app.downloadSizeLabel != null)
            InfoRow(
              label: 'Download',
              value: app.downloadSizeLabel!,
              titleColor: titleColor,
              secondaryColor: secondaryColor,
            ),
          if (app.installedSizeLabel != null)
            InfoRow(
              label: 'Instalado',
              value: app.installedSizeLabel!,
              titleColor: titleColor,
              secondaryColor: secondaryColor,
            ),
          if (app.runtimeInstalledSizeLabel != null)
            InfoRow(
              label: 'Runtime',
              value: app.runtimeInstalledSizeLabel!,
              titleColor: titleColor,
              secondaryColor: secondaryColor,
            ),
          if (app.license != null)
            InfoRow(label: 'Licenca', value: app.license!, titleColor: titleColor, secondaryColor: secondaryColor),
          InfoRow(
            label: 'Flatpak ID',
            value: app.flatpakRef ?? app.appId,
            titleColor: titleColor,
            secondaryColor: secondaryColor,
            monospace: true,
          ),
        ],
      ),
    );
  }
}
