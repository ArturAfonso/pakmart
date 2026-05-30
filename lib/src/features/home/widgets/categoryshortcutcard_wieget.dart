

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/features/categories/models/category_remote_models.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class CategoryShortcutCard extends StatelessWidget {
  const CategoryShortcutCard({super.key, 
    required this.category,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  final CategoryShelfData category;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRoutes.CATEGORY_DETAILS,
          pathParameters: {AppRoutes.categoryIdParam: category.id},
        ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 116,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(category.icon, size: 34, color: category.iconColor),
              Text(
                category.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}