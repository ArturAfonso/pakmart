import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/shell/widgets/main_appbar_widget.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      backgroundColor:   isDark ? AppColors.darkBackground : AppColors.background,
      appBar: MainAppBar(isDark: isDark ),
      body: child,
    );
  }
}