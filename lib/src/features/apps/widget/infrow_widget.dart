


import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, 
    required this.label,
    required this.value,
    required this.titleColor,
    required this.secondaryColor,
    this.monospace = false,
  });

  final String label;
  final String value;
  final Color titleColor;
  final Color secondaryColor;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
            ),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: (monospace ? Theme.of(context).textTheme.bodySmall : Theme.of(context).textTheme.bodyMedium)
                  ?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}