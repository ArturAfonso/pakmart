import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/search/bloc/search_bloc.dart';
import 'package:pakmart/src/features/search/bloc/search_event.dart';
import 'package:pakmart/src/features/search/bloc/search_state.dart';
import 'package:pakmart/src/features/search/models/search_app_data.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _lastQuery = '';
  String _lastRunToken = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final uri = GoRouterState.of(context).uri;
    final routeQuery = (uri.queryParameters['q'] ?? '').trim();
    final run = uri.queryParameters['run'] == '1';
    final runToken = uri.queryParameters['t'] ?? '';

    if (routeQuery != _lastQuery) {
      _lastQuery = routeQuery;
      context.read<SearchBloc>().add(SearchQueryChanged(routeQuery));
    }

    if (run && runToken.isNotEmpty && runToken != _lastRunToken) {
      _lastRunToken = runToken;
      context.read<SearchBloc>().add(const SearchSubmitted());
    }
  }

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
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 56),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            final router = GoRouter.of(context);
                            if (router.routerDelegate.canPop()) {
                              context.pop();
                              return;
                            }

                            context.goNamed(AppRoutes.HOME);
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                          tooltip: 'Voltar',
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Buscar aplicativos',
                          style: AppTextStyles.titleLargeNormal.copyWith(color: titleColor, fontSize: 38, height: 1.1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    /* Text(
                      'Use a busca global no topo para digitar e refinar os resultados.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                    ),
                    const SizedBox(height: 12), */
                    if (state.hasQuery)
                      Text(
                        '${state.totalHits} resultados para "${state.query}"',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                      ),
                    const SizedBox(height: 16),
                    if (!state.hasQuery)
                      _EmptySearchHint(secondaryColor: secondaryColor)
                    else if (state.status == SearchStatus.loading && state.results.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 56),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.status == SearchStatus.failure && state.results.isEmpty)
                      _ErrorSearchPanel(
                        message: state.errorMessage ?? 'Falha ao buscar resultados.',
                        onRetry: () => context.read<SearchBloc>().add(const SearchRetried()),
                        titleColor: titleColor,
                        secondaryColor: secondaryColor,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                      )
                    else if (state.status == SearchStatus.success && state.results.isEmpty)
                      _NoResultsHint(secondaryColor: secondaryColor)
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
                          final cardWidth = (width - ((columns - 1) * spacing)) / columns;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: [
                              for (final app in state.results)
                                SizedBox(
                                  width: cardWidth,
                                  child: _SearchResultCard(
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
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: state.canGoPrevious && state.status != SearchStatus.loading
                                ? () => context.read<SearchBloc>().add(SearchPageChanged(state.page - 1))
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
                            onPressed: state.canGoNext && state.status != SearchStatus.loading
                                ? () => context.read<SearchBloc>().add(SearchPageChanged(state.page + 1))
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

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.app,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.isDark,
  });

  final SearchAppData app;
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
        onTap: () => context.pushNamed(AppRoutes.APP_INFO, pathParameters: {AppRoutes.appIdParam: app.appId}),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2D40) : const Color(0xFFE8F3FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: app.iconUrl == null
                      ? Icon(Icons.apps_rounded, size: 30, color: titleColor)
                      : Image.network(
                          app.iconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.apps_rounded, size: 30, color: titleColor),
                        ),
                ),
              ),
              const SizedBox(width: 16),
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
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: titleColor, fontWeight: FontWeight.w700),
                        ),
                        if (app.verified) const Icon(Icons.verified_outlined, size: 15, color: AppColors.accent),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.publisher,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      app.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: secondaryColor, height: 1.35),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.download_rounded, size: 16, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          app.installsLastMonth == null ? 'Sem dados' : _formatNumber(app.installsLastMonth!),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: titleColor),
                        ),
                        const SizedBox(width: 8),
                        Text('·', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            app.mainCategory ?? 'Geral',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                          ),
                        ),
                      ],
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

class _EmptySearchHint extends StatelessWidget {
  const _EmptySearchHint({required this.secondaryColor});

  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          'Digite um termo para começar a busca.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor),
        ),
      ),
    );
  }
}

class _NoResultsHint extends StatelessWidget {
  const _NoResultsHint({required this.secondaryColor});

  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          'Nenhum app encontrado para esse termo.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor),
        ),
      ),
    );
  }
}

class _ErrorSearchPanel extends StatelessWidget {
  const _ErrorSearchPanel({
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
            'Busca indisponível',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: titleColor, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor)),
          const SizedBox(height: 12),
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
