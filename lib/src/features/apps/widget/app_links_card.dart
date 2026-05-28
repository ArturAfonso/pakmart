import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/apps/models/app_detail_data.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLinksCard extends StatelessWidget {
  const AppLinksCard({
    super.key,
    required this.links,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  final List<AppDetailLinkData> links;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Links uteis', style: AppTextStyles.titleMediumNormal.copyWith(color: titleColor, fontSize: 24)),
          const SizedBox(height: 14),
          Column(
            children: [
              for (var index = 0; index < links.length; index++) ...[
                _LinkTile(link: links[index], titleColor: titleColor, secondaryColor: secondaryColor),
                if (index != links.length - 1) const SizedBox(height: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.link, required this.titleColor, required this.secondaryColor});

  final AppDetailLinkData link;
  final Color titleColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: secondaryColor.withValues(alpha: 0.06),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link.label,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: titleColor, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      link.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.open_in_new_rounded, color: titleColor, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final uri = Uri.tryParse(link.url);
    if (uri == null) {
      return;
    }

    final didLaunch = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!didLaunch && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nao foi possivel abrir ${link.label}.')));
    }
  }
}
