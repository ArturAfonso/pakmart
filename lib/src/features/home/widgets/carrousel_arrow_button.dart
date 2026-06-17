

import 'package:flutter/material.dart';

class CarouselArrowButton extends StatelessWidget {
  const CarouselArrowButton({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black38, // Cor da borda
          width: 0.3, // Espessura da borda
        ),
      ),
      child: IconButton.filledTonal(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withAlpha(15),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
        ),
        icon: Icon(icon, ),
      ),
    );
  }
}