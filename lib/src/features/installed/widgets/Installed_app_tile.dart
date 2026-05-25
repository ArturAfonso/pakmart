




import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          extra: app,
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
										width: 48,
										height: 48,
										decoration: BoxDecoration(
											color: Colors.transparent,
											borderRadius: BorderRadius.circular(20),
										),
										child: _buildAppIcon(app.icon?.url, iconColor),
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

	Widget _buildAppIcon(String? url, Color iconColor) {
		if (url == null || url.isEmpty) {
			return Image.asset('assets/flathub.png', scale: 2.0, width: 48, height: 48);
		}

		final isSvg = url.toLowerCase().endsWith('.svg');

		if (url.startsWith('file://')) {
			final file = File.fromUri(Uri.parse(url));
			if (isSvg) {
				return SvgPicture.file(
					file,
					width: 48,
					height: 48,
					fit: BoxFit.contain,
					placeholderBuilder: (context) => Icon(
						Icons.image_outlined,
						size: 32,
						color: iconColor,
					),
				);
			}

			return Image.file(
				file,
				width: 48,
				height: 48,
				errorBuilder: (context, error, stackTrace) => Icon(
					Icons.nearby_error,
					size: 48,
					color: iconColor,
				),
			);
		}

		if (isSvg) {
			return SvgPicture.network(
				url,
				width: 48,
				height: 48,
				fit: BoxFit.contain,
				placeholderBuilder: (context) => Icon(
					Icons.image_outlined,
					size: 32,
					color: iconColor,
				),
			);
		}

		return Image.network(
			url,
			scale: app.icon?.scale?.toDouble() ?? 2.0,
			width: 48,
			height: 48,
			errorBuilder: (context, error, stackTrace) => Icon(
				Icons.nearby_error,
				size: 48,
				color: iconColor,
			),
		);
	}
}
