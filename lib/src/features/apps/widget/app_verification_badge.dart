import 'package:flutter/material.dart';
import 'package:pakmart/l10n/l10n.dart';

class UnverifiedAppBadge extends StatelessWidget {
  const UnverifiedAppBadge({super.key});

  static const _warningColor = Color(0xFFD69A16);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _warningColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _warningColor.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.gpp_maybe_outlined, size: 14, color: _warningColor),
          const SizedBox(width: 5),
          Text(
            context.l10n.unverifiedApp,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _warningColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
