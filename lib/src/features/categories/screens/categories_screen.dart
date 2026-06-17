import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/categories/bloc/categories_bloc.dart';
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
						child: BlocBuilder<CategoriesBloc, CategoriesState>(
							builder: (context, state) {
								return Column(
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
											'Todas as categorias',
											style: AppTextStyles.titleLargeNormal.copyWith(
												color: titleColor,
												fontSize: 54,
												height: 1.05,
											),
										),
										const SizedBox(height: 36),
										if (state.status == CategoriesStatus.loading && state.categories.isEmpty)
											const Padding(
												padding: EdgeInsets.symmetric(vertical: 56),
												child: Center(child: CircularProgressIndicator()),
											)
										else if (state.status == CategoriesStatus.failure && state.categories.isEmpty)
											_InlineError(
												message: state.errorMessage ?? 'Não foi possível carregar as categorias.',
												onRetry: () => context.read<CategoriesBloc>().add(const CategoriesRetried()),
												titleColor: titleColor,
												secondaryColor: secondaryColor,
												surfaceColor: surfaceColor,
												borderColor: borderColor,
											)
										else
											LayoutBuilder(
												builder: (context, constraints) {
													final width = constraints.maxWidth;
													final columns = width >= 1080
															? 3
															: width >= 720
																	? 2
																	: 1;
													const spacing = 18.0;
													final cardWidth = (width - ((columns - 1) * spacing)) / columns;

													return Wrap(
														spacing: spacing,
														runSpacing: spacing,
														children: [
															for (final category in state.categories)
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
								);
							},
						),
					),
				),
			),
		);
	}
}

class _InlineError extends StatelessWidget {
	const _InlineError({
		required this.message,
		required this.onRetry,
		required this.titleColor,
		required this.secondaryColor,
		required this.surfaceColor,
		required this.borderColor,
	});

	final String message;
	final VoidCallback onRetry;
	final Color titleColor;
	final Color secondaryColor;
	final Color surfaceColor;
	final Color borderColor;

	@override
	Widget build(BuildContext context) {
		return Container(
			width: double.infinity,
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				color: surfaceColor,
				borderRadius: BorderRadius.circular(20),
				border: Border.all(color: borderColor),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(
						'Não conseguimos carregar as categorias.',
						style: Theme.of(context).textTheme.titleMedium?.copyWith(color: titleColor, fontWeight: FontWeight.w700),
					),
					const SizedBox(height: 8),
					Text(
						message,
						style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
					),
					const SizedBox(height: 14),
					FilledButton.icon(
						onPressed: onRetry,
						icon: const Icon(Icons.refresh_rounded),
						label: const Text('Tentar novamente'),
					),
				],
			),
		);
	}
}
