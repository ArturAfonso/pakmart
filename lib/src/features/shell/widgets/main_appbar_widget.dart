import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
          Text('Pakmart', style: AppTextStyles.titleLargeItalic.copyWith(color: AppColors.accent)),
          const SizedBox(width: 24),
          Flexible(
            child: SingleChildScrollView(
               scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MenuButton(
                    label: 'Explorar',
                    selected: currentLocation == AppRoutes.homePath,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () => context.goNamed(AppRoutes.HOME),
                  ),
                  MenuButton(
                    label: 'Categorias',
                    selected: currentLocation.startsWith(AppRoutes.categoriesPath),
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () => context.goNamed(AppRoutes.CATEGORIES),
                  ),
                  MenuButton(
                    label: 'Instalados',
                    selected: currentLocation.startsWith(AppRoutes.installedPath),
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () => context.goNamed(AppRoutes.INSTALLED),
                  ),
                  MenuButton(
                    label: 'Preferências',
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
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
