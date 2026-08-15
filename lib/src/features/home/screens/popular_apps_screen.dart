import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/l10n/l10n.dart';
import 'package:pakmart/src/core/preferences/app_preferences_cubit.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/home/bloc/popular_apps_bloc.dart';
import 'package:pakmart/src/features/home/bloc/popular_apps_event.dart';
import 'package:pakmart/src/features/home/bloc/popular_apps_state.dart';
import 'package:pakmart/src/features/home/models/home_popular_app_data.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class PopularAppsScreen extends StatelessWidget {
  const PopularAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final showUnverifiedApps = context
        .watch<AppPreferencesCubit>()
        .state
        .showUnverifiedApps;
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
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
            child: BlocBuilder<PopularAppsBloc, PopularAppsState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.popularAppsEyebrow,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 4,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _collectionLabel(context, state.collection),
                      style: AppTextStyles.titleLargeNormal.copyWith(
                        color: titleColor,
                        fontSize: 54,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _collectionDescription(context, state.collection),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: secondaryColor),
                    ),
                    const SizedBox(height: 26),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 270,
                          child: DropdownButtonFormField<HomePopularCollection>(
                            initialValue: state.collection,
                            decoration: InputDecoration(
                              labelText: context.l10n.sortBy,
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
                            items: HomePopularCollection.values
                                .map(
                                  (item) =>
                                      DropdownMenuItem<HomePopularCollection>(
                                        value: item,
                                        child: Text(
                                          _collectionLabel(context, item),
                                        ),
                                      ),
                                )
                                .toList(growable: false),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              context.read<PopularAppsBloc>().add(
                                PopularAppsCollectionChanged(value),
                              );
                            },
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: state.status == PopularAppsStatus.loading
                              ? null
                              : () => context.read<PopularAppsBloc>().add(
                                  const PopularAppsRetried(),
                                ),
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(context.l10n.refresh),
                        ),
                        if (showUnverifiedApps && state.totalHits > 0)
                          Text(
                            context.l10n.appsFound(state.totalHits),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: secondaryColor),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (state.status == PopularAppsStatus.loading &&
                        state.apps.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 56),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.status == PopularAppsStatus.failure &&
                        state.apps.isEmpty)
                      _ErrorPanel(
                        message: context.l10n.popularFailure,
                        onRetry: () => context.read<PopularAppsBloc>().add(
                          const PopularAppsRetried(),
                        ),
                        titleColor: titleColor,
                        secondaryColor: secondaryColor,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                      )
                    else ...[
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final columns = width >= 1220
                              ? 3
                              : width >= 840
                              ? 2
                              : 1;
                          const spacing = 14.0;
                          final cardWidth =
                              (width - ((columns - 1) * spacing)) / columns;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: [
                              for (final app in state.apps)
                                SizedBox(
                                  width: cardWidth,
                                  child: _PopularAppCard(
                                    app: app,
                                    collection: state.collection,
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
                            onPressed:
                                state.canGoPrevious &&
                                    state.status != PopularAppsStatus.loading
                                ? () => context.read<PopularAppsBloc>().add(
                                    PopularAppsPageChanged(state.page - 1),
                                  )
                                : null,
                            icon: const Icon(Icons.chevron_left_rounded),
                            label: Text(context.l10n.previous),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              context.l10n.pageOf(state.page, state.totalPages),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: titleColor),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed:
                                state.canGoNext &&
                                    state.status != PopularAppsStatus.loading
                                ? () => context.read<PopularAppsBloc>().add(
                                    PopularAppsPageChanged(state.page + 1),
                                  )
                                : null,
                            icon: const Icon(Icons.chevron_right_rounded),
                            label: Text(context.l10n.next),
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

class _PopularAppCard extends StatelessWidget {
  const _PopularAppCard({
    required this.app,
    required this.collection,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.isDark,
  });

  final HomePopularAppData app;
  final HomePopularCollection collection;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRoutes.APP_INFO,
          pathParameters: {AppRoutes.appIdParam: app.appId},
        ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A2D40)
                      : const Color(0xFFE8F3FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: app.iconUrl == null
                      ? Icon(Icons.apps_rounded, color: titleColor, size: 28)
                      : Image.network(
                          app.iconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.apps_rounded, color: titleColor),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        Text(
                          app.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: titleColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (app.verified)
                          const Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: AppColors.accent,
                          )
                        else
                          Tooltip(
                            message: context.l10n.unverifiedApp,
                            child: const Icon(
                              Icons.gpp_maybe_outlined,
                              size: 14,
                              color: Color(0xFFD69A16),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.developerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: secondaryColor),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      app.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: secondaryColor,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _metricLabel(context, collection, app),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _metricLabel(
    BuildContext context,
    HomePopularCollection collection,
    HomePopularAppData app,
  ) {
    switch (collection) {
      case HomePopularCollection.popular:
        final installs = app.installsLastMonth;
        if (installs == null) {
          return context.l10n.noInstallMetrics;
        }

        return context.l10n.lastMonthInstalls(_formatNumber(installs));
      case HomePopularCollection.trending:
        final score = app.trendingScore;
        if (score == null) {
          return context.l10n.noTrendingScore;
        }

        return context.l10n.trendingScoreLabel(score.toStringAsFixed(2));
      case HomePopularCollection.favorites:
        final favorites = app.favoritesCount;
        if (favorites == null) {
          return context.l10n.noFavoritesCount;
        }

        return context.l10n.favoritesCount(_formatNumber(favorites));
    }
  }

  String _formatNumber(int value) {
    final digits = value.toString();
    if (digits.length <= 3) {
      return digits;
    }

    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      final reverseIndex = digits.length - index;
      buffer.write(digits[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({
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
            context.l10n.listLoadFailure,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: secondaryColor),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}

String _collectionLabel(
  BuildContext context,
  HomePopularCollection collection,
) {
  return switch (collection) {
    HomePopularCollection.popular => context.l10n.collectionPopular,
    HomePopularCollection.trending => context.l10n.collectionTrending,
    HomePopularCollection.favorites => context.l10n.collectionFavorites,
  };
}

String _collectionDescription(
  BuildContext context,
  HomePopularCollection collection,
) {
  return switch (collection) {
    HomePopularCollection.popular => context.l10n.collectionPopularDescription,
    HomePopularCollection.trending =>
      context.l10n.collectionTrendingDescription,
    HomePopularCollection.favorites =>
      context.l10n.collectionFavoritesDescription,
  };
}
