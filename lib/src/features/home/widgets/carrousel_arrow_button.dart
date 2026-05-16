

import 'package:flutter/material.dart';

class CarouselArrowButton extends StatelessWidget {
  const CarouselArrowButton({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.12),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
      ),
      icon: Icon(icon),
    );
  }
}