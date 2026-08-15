import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/l10n/l10n.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/shell/widgets/appbar_search_widget.dart';
import 'package:pakmart/src/features/shell/widgets/menu_button.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, required this.isDark});

  final bool isDark;

  @override
  Size get preferredSize => const Size.fromHeight(82.0);

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final selectedColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final unselectedColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /*    Container(
            child: Column(
              children: [
               
                Row(
                  children: [
                     Text('Pak', style: AppTextStyles.titleSmallItalic.copyWith(color: AppColors.accent)),
                              Text('mart', style: AppTextStyles.titleSmallItalic.copyWith(color: const Color.fromARGB(255, 157, 107, 68))),
                  ],
                ),
              ],
            ),
          ),  */
          InkWell(
            onTap: () => context.goNamed(AppRoutes.HOME),
            child: Row(
              children: [
                Text('Pakmart', style: AppTextStyles.titleMediumItalic.copyWith(color: AppColors.accent)),
                Image.asset('assets/icons/logo.png', height: 30),
              ],
            ),
          ),

          const SizedBox(width: 24),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MenuButton(
                    label: context.l10n.explore,
                    selected: currentLocation == AppRoutes.homePath,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () => context.goNamed(AppRoutes.HOME),
                  ),
                  MenuButton(
                    label: context.l10n.categories,
                    selected: currentLocation.startsWith(AppRoutes.categoriesPath),
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () => context.goNamed(AppRoutes.CATEGORIES),
                  ),
                  MenuButton(
                    label: context.l10n.installed,
                    selected: currentLocation.startsWith(AppRoutes.installedPath),
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () => context.goNamed(AppRoutes.INSTALLED),
                  ),
                  MenuButton(
                    label: context.l10n.preferences,
                    selected: currentLocation == AppRoutes.preferencesPath,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () => context.goNamed(AppRoutes.PREFERENCES),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        const AppBarSearchWidget(),
        const SizedBox(width: 30),
        IconButton(
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
          tooltip: context.l10n.themeToggleTooltip,
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
