import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/categories/data/categories_data.dart';
import 'package:pakmart/src/features/categories/widgets/category_card_widget.dart';

class CategoriesScreen extends StatelessWidget {
	const CategoriesScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
		final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
		final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
		final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
		final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

		return SafeArea(
			top: false,
			child: Align(
				alignment: Alignment.topCenter,
				child: SingleChildScrollView(
					padding: const EdgeInsets.fromLTRB(24, 40, 24, 56),
					child: ConstrainedBox(
						constraints: const BoxConstraints(maxWidth: 1180),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									'ACERVO',
									style: Theme.of(context).textTheme.labelSmall?.copyWith(
												letterSpacing: 4,
												fontWeight: FontWeight.w700,
												fontSize: 14,
												color: secondaryColor,
											),
								),
								const SizedBox(height: 8),
								Text(
									'Todas as prateleiras',
									style: AppTextStyles.titleLargeNormal.copyWith(
										color: titleColor,
										fontSize: 54,
										height: 1.05,
									),
								),
								const SizedBox(height: 36),
								LayoutBuilder(
									builder: (context, constraints) {
										final width = constraints.maxWidth;
										final columns = width >= 1080
												? 3
												: width >= 720
														? 2
														: 1;
										final spacing = 18.0;
										final cardWidth = (width - ((columns - 1) * spacing)) / columns;

										return Wrap(
											spacing: spacing,
											runSpacing: spacing,
											children: [
												for (final category in CategoriesData.categories)
													SizedBox(
														width: cardWidth,
														child: CategoryCard(
															data: category,
															titleColor: titleColor,
															secondaryColor: secondaryColor,
															surfaceColor: surfaceColor,
															borderColor: borderColor,
														),
													),
											],
										);
									},
								),
							],
						),
					),
				),
			),
		);
	}
}
