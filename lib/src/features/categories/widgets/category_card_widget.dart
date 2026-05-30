


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/categories/models/category_remote_models.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class CategoryCard extends StatelessWidget {
	const CategoryCard({super.key, 
		required this.data,
		required this.titleColor,
		required this.secondaryColor,
		required this.surfaceColor,
		required this.borderColor,
	});

	final CategoryShelfData data;
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
					pathParameters: {AppRoutes.categoryIdParam: data.id},
				),
				borderRadius: BorderRadius.circular(24),
				child: Container(
					constraints: const BoxConstraints(minHeight: 180),
					padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
					decoration: BoxDecoration(
						color: surfaceColor,
						borderRadius: BorderRadius.circular(24),
						border: Border.all(color: borderColor),
					),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Icon(data.icon, size: 40, color: data.iconColor),
									const SizedBox(height: 18),
									Text(
										data.title,
										maxLines: 1,
										overflow: TextOverflow.ellipsis,
										style: AppTextStyles.titleMediumNormal.copyWith(
											color: titleColor,
											fontSize: 24,
										),
									),
									const SizedBox(height: 6),
									Text(
										data.description,
										maxLines: 2,
										overflow: TextOverflow.ellipsis,
										style: Theme.of(context).textTheme.bodyMedium?.copyWith(
											color: secondaryColor,
											height: 1.35,
										),
									),
								],
							),
							const SizedBox(height: 18),
							Text(
								'Ver aplicativos',
								style: Theme.of(context).textTheme.bodySmall?.copyWith(
										color: AppColors.accent,
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
