


import 'package:flutter/material.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, 
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodyLarge.copyWith(
          color: selected ? selectedColor : unselectedColor,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          fontSize: selected ? 20 : 18,
        ),
      ),
    );
  }
}
