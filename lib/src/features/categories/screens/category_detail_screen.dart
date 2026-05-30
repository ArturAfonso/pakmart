import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/categories/bloc/category_apps_bloc.dart';
import 'package:pakmart/src/features/categories/models/category_remote_models.dart';
import 'package:pakmart/src/features/categories/widgets/category_app_card_widget.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key, required this.categoryId});

  final String categoryId;

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
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 56),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: BlocBuilder<CategoryAppsBloc, CategoryAppsState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.goNamed(AppRoutes.CATEGORIES);
                        }
                      },
                      icon: Icon(Icons.arrow_back_rounded, color: secondaryColor, size: 18),
                      label: Text(
                        'Categorias',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(state.presentation.icon, size: 58, color: state.presentation.iconColor),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PRATELEIRA',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: secondaryColor,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                state.presentation.title,
                                style: AppTextStyles.titleLargeNormal.copyWith(
                                  color: titleColor,
                                  fontSize: 54,
                                  height: 1.05,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                state.presentation.description,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          child: DropdownButtonFormField<CategorySortBy>(
                            initialValue: state.sortBy,
                            decoration: InputDecoration(
                              labelText: 'Ordenar por',
                              filled: true,
                              fillColor: surfaceColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: borderColor),
                              ),
                            ),
                            items: CategorySortBy.values
                                .map((item) => DropdownMenuItem<CategorySortBy>(value: item, child: Text(item.label)))
                                .toList(growable: false),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              context.read<CategoryAppsBloc>().add(CategoryAppsSortChanged(value));
                            },
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: state.status == CategoryAppsStatus.loading
                              ? null
                              : () => context.read<CategoryAppsBloc>().add(const CategoryAppsRetried()),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Atualizar'),
                        ),
                        if (state.totalHits > 0)
                          Text(
                            '${state.totalHits} apps',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    if (state.status == CategoryAppsStatus.loading && state.apps.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 56),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.status == CategoryAppsStatus.failure && state.apps.isEmpty)
                      _InlineError(
                        message: state.errorMessage ?? 'Não foi possível carregar os apps da categoria.',
                        onRetry: () => context.read<CategoryAppsBloc>().add(const CategoryAppsRetried()),
                        titleColor: titleColor,
                        secondaryColor: secondaryColor,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                      )
                    else ...[
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final columns = width >= 960 ? 2 : 1;
                          const spacing = 16.0;
                          final cardWidth = (width - ((columns - 1) * spacing)) / columns;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: [
                              for (final app in state.apps)
                                SizedBox(
                                  width: cardWidth,
                                  child: CategoryAppCard(
                                    app: app,
                                    titleColor: titleColor,
                                    secondaryColor: secondaryColor,
                                    surfaceColor: surfaceColor,
                                    borderColor: borderColor,
                                    isDark: isDark,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: state.canGoPrevious && state.status != CategoryAppsStatus.loading
                                ? () => context.read<CategoryAppsBloc>().add(CategoryAppsPageChanged(state.page - 1))
                                : null,
                            icon: const Icon(Icons.chevron_left_rounded),
                            label: const Text('Anterior'),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              'Página ${state.page} de ${state.totalPages}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: titleColor),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: state.canGoNext && state.status != CategoryAppsStatus.loading
                                ? () => context.read<CategoryAppsBloc>().add(CategoryAppsPageChanged(state.page + 1))
                                : null,
                            icon: const Icon(Icons.chevron_right_rounded),
                            label: const Text('Próxima'),
                          ),
                        ],
                      ),
                    ],
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
            'Não conseguimos carregar esta categoria.',
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
