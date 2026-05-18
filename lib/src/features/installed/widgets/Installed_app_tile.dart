




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/installed/data/installed_apps_data.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class InstalledAppTile extends StatelessWidget {
	const InstalledAppTile({super.key, required this.app});

	final InstalledAppData app;

	@override
	Widget build(BuildContext context) {
		final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
		final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
		final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
		final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
		final iconColor = isDark ? AppColors.darkBackground : AppColors.textPrimary;

		return Material(
			color: Colors.transparent,
			child: InkWell(
				onTap: () => context.pushNamed(
					AppRoutes.INSTALLED_DETAILS,
					pathParameters: {AppRoutes.appIdParam: app.id},
				),
				borderRadius: BorderRadius.circular(28),
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
					child: LayoutBuilder(
						builder: (context, constraints) {
							final compact = constraints.maxWidth < 700;

							return Row(
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
									Container(
										width: app.icon?.width.toDouble() ?? 48,
										height: app.icon?.height.toDouble() ?? 48,
										decoration: BoxDecoration(
											color: Colors.transparent,
											borderRadius: BorderRadius.circular(20),
										),
										child: app.icon != null && app.icon!.url.isNotEmpty ? Image.network( 
                      scale: app.icon?.scale?.toDouble() ?? 2.0,
                      app.icon!.url,
                      width: app.icon?.width.toDouble() ?? 48,
                      height: app.icon?.height.toDouble() ?? 48,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.nearby_error,
                        size: 48,
                        color: iconColor,
                      ),
                    ) : Image.asset('assets/flathub.png', scale: 2.0, width: 48, height: 48),
									),
									const SizedBox(width: 16),
									Expanded(
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Wrap(
													crossAxisAlignment: WrapCrossAlignment.center,
													spacing: 6,
													runSpacing: 4,
													children: [
														Text(
															app.name,
															style: Theme.of(context).textTheme.titleLarge?.copyWith(
																		color: titleColor,
																		fontWeight: FontWeight.w700,
																	),
														),
														Icon(Icons.verified_outlined, size: 16, color: AppColors.accent),
													],
												),
												const SizedBox(height: 4),
												Text(
													app.description,
													maxLines: compact ? 2 : 1,
													overflow: TextOverflow.ellipsis,
													style: Theme.of(context).textTheme.bodyLarge?.copyWith(
																color: secondaryColor,
																fontSize: 15,
															),
												),
												const SizedBox(height: 4),
												Wrap(
													spacing: 8,
													runSpacing: 4,
													children: [
														Text(
															app.packageName,
															style: Theme.of(context).textTheme.bodyMedium?.copyWith(
																		color: mutedColor,
																		fontSize: 14,
																	),
														),
														Text(
															'•',
															style: Theme.of(context).textTheme.bodyMedium?.copyWith(
																		color: mutedColor,
																		fontSize: 14,
																	),
														),
														Text(
															app.version,
															style: Theme.of(context).textTheme.bodyMedium?.copyWith(
																		color: mutedColor,
																		fontSize: 14,
																	),
														),
														Text(
															'•',
															style: Theme.of(context).textTheme.bodyMedium?.copyWith(
																		color: mutedColor,
																		fontSize: 14,
																	),
														),
														Text(
															app.size,
															style: Theme.of(context).textTheme.bodyMedium?.copyWith(
																		color: mutedColor,
																		fontSize: 14,
																	),
														),
													],
												),
											],
										),
									),
									const SizedBox(width: 16),
									Icon(Icons.chevron_right_rounded, color: secondaryColor, size: 28),
								],
							);
						},
					),
				),
			),
		);
	}
}
