import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/categories/data/categories_data.dart';
import 'package:pakmart/src/features/home/bloc/home_featured_bloc.dart';
import 'package:pakmart/src/features/home/bloc/home_featured_event.dart';
import 'package:pakmart/src/features/home/bloc/home_featured_state.dart';
import 'package:pakmart/src/features/home/bloc/home_popular_bloc.dart';
import 'package:pakmart/src/features/home/bloc/popular_apps_state.dart';
import 'package:pakmart/src/features/home/models/home_featured_app_data.dart';
import 'package:pakmart/src/features/home/widgets/categoryshortcutcard_wieget.dart';
import 'package:pakmart/src/features/home/widgets/compact_appcard_widget.dart';
import 'package:pakmart/src/features/home/widgets/home_carrousel_widget.dart';
import 'package:pakmart/src/features/home/widgets/home_popular_app_card.dart';
import 'package:pakmart/src/features/home/widgets/info_promo_card.dart';
import 'package:pakmart/src/features/home/widgets/responsive_gride_widget.dart';
import 'package:pakmart/src/features/home/widgets/section_header.dart';
import 'package:pakmart/src/features/home/widgets/tophated_section_widget.dart';
import 'package:pakmart/src/routes/app_routes.dart';
import 'package:pakmart/src/di/injector.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final _featuredAppsFallback = [
    CategoriesData.appById('flowstudio')!,
    CategoriesData.appById('teleframe')!,
    CategoriesData.appById('gimp')!,
  ];

  static final _weeklyApps = [
    CategoriesData.appById('teleframe')!,
    CategoriesData.appById('obsidiana')!,
    CategoriesData.appById('vscodium')!,
    CategoriesData.appById('gimp')!,
    CategoriesData.appById('echo-player')!,
    CategoriesData.appById('atlas-learn')!,
  ];

  static final _topRatedApps = [
    CategoriesData.appById('flowstudio')!,
    CategoriesData.appById('teleframe')!,
    CategoriesData.appById('obsidiana')!,
    CategoriesData.appById('vivid-studio')!,
    CategoriesData.appById('echo-player')!,
    CategoriesData.appById('vscodium')!,
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final List<HomeFeaturedAppData> _fallbackFeaturedApps;
  late final HomePopularBloc _homePopularBloc;

  @override
  void initState() {
    super.initState();
    _fallbackFeaturedApps = _featuredAppsFallback.map(HomeFeaturedAppData.fromCategoryApp).toList(growable: false);
    _homePopularBloc = HomePopularBloc(sl());
    _homePopularBloc.add(const HomePopularRequested());
    context.read<HomeFeaturedBloc>().add(const HomeFeaturedRequested());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _homePopularBloc.close();
    super.dispose();
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 56),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<HomeFeaturedBloc, HomeFeaturedState>(
                  builder: (context, state) {
                    final featuredApps = state.apps.isNotEmpty ? state.apps : _fallbackFeaturedApps;

                    return HomeCarousel(
                      apps: featuredApps,
                      currentPage: _currentPage,
                      controller: _pageController,
                      onPageChanged: (page) => setState(() => _currentPage = page),
                      onOpenExternal: _openFlathubApp,
                      autoAdvanceInterval: const Duration(seconds: 10),
                    );
                  },
                ),
                const SizedBox(height: 46),
                SectionHeader(
                  title: 'Mais populares',
                  subtitle: 'Os preferidos da comunidade',
                  actionLabel: 'Ver tudo',
                  onAction: () => context.goNamed(AppRoutes.POPULAR_APPS),
                  titleColor: titleColor,
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 18),
                BlocProvider.value(
                  value: _homePopularBloc,
                  child: BlocBuilder<HomePopularBloc, PopularAppsState>(
                    builder: (context, state) {
                      if (state.status == PopularAppsStatus.loading && state.apps.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (state.status == PopularAppsStatus.failure && state.apps.isEmpty) {
                        return _HomeInlineError(
                          message: state.errorMessage ?? 'Não conseguimos carregar os apps populares agora.',
                          onRetry: () => context.read<HomePopularBloc>().add(const HomePopularRetried()),
                          titleColor: titleColor,
                          secondaryColor: secondaryColor,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                        );
                      }

                      final apps = state.apps;
                      return ResponsiveGrid(
                        minItemWidth: 230,
                        spacing: 14,
                        children: [
                          for (final app in apps)
                            HomePopularAppCard(
                              app: app,
                              titleColor: titleColor,
                              secondaryColor: secondaryColor,
                              surfaceColor: surfaceColor,
                              borderColor: borderColor,
                              isDark: isDark,
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 48),
                SectionHeader(
                  title: 'Navegar por prateleira',
                  subtitle: 'Encontre por área de interesse',
                  actionLabel: 'Ver tudo',
                  onAction: () => context.goNamed(AppRoutes.CATEGORIES),
                  titleColor: titleColor,
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 18),
                ResponsiveGrid(
                  minItemWidth: 110,
                  spacing: 12,
                  children: [
                    for (final category in CategoriesData.categories)
                      CategoryShortcutCard(
                        category: category,
                        titleColor: titleColor,
                        secondaryColor: secondaryColor,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                      ),
                  ],
                ),
                const SizedBox(height: 48),
                SectionHeader(
                  title: 'Em destaque esta semana',
                  subtitle: 'Curadoria editorial',
                  titleColor: titleColor,
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 18),
                ResponsiveGrid(
                  minItemWidth: 300,
                  spacing: 14,
                  children: [
                    for (final app in _weeklyApps)
                      CompactAppCard(
                        app: app,
                        titleColor: titleColor,
                        secondaryColor: secondaryColor,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        isDark: isDark,
                      ),
                  ],
                ),
                const SizedBox(height: 52),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 980;

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopRatedSection(
                            apps: _topRatedApps,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 24),
                          InfoPromoCard(
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            onPressed: () => context.goNamed(AppRoutes.INSTALLED),
                          ),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TopRatedSection(
                            apps: _topRatedApps,
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 42),
                        Expanded(
                          flex: 1,
                          child: InfoPromoCard(
                            titleColor: titleColor,
                            secondaryColor: secondaryColor,
                            surfaceColor: surfaceColor,
                            onPressed: () => context.goNamed(AppRoutes.INSTALLED),
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

  Future<void> _openFlathubApp(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _HomeInlineError extends StatelessWidget {
  const _HomeInlineError({
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Não conseguimos carregar os populares agora.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: titleColor, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: secondaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
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
