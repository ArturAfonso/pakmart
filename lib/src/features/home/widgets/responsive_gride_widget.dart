




import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key, 
    required this.minItemWidth,
    required this.spacing,
    required this.children,
  });

  final double minItemWidth;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / (minItemWidth + spacing)).floor().clamp(1, 6);
        final itemWidth = (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(
                width: itemWidth,
                child: child,
              ),
          ],
        );
      },
    );
  }
}