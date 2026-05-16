import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_colors.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/core/theme/theme_cubit.dart';
import 'package:pakmart/src/features/categories/data/categories_data.dart';
import 'package:pakmart/src/features/home/widgets/categoryshortcutcard_wieget.dart';
import 'package:pakmart/src/features/home/widgets/compact_appcard_widget.dart';
import 'package:pakmart/src/features/home/widgets/home_carrousel_widget.dart';
import 'package:pakmart/src/features/home/widgets/info_promo_card.dart';
import 'package:pakmart/src/features/home/widgets/responsive_gride_widget.dart';
import 'package:pakmart/src/features/home/widgets/section_header.dart';
import 'package:pakmart/src/features/home/widgets/tophated_section_widget.dart';
import 'package:pakmart/src/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final _featuredApps = [
    CategoriesData.appById('flowstudio')!,
    CategoriesData.appById('teleframe')!,
    CategoriesData.appById('gimp')!,
  ];

  static final _popularApps = [
    CategoriesData.appById('gimp')!,
    CategoriesData.appById('vscodium')!,
    CategoriesData.appById('teleframe')!,
    CategoriesData.appById('north-browser')!,
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

  @override
  void dispose() {
    _pageController.dispose();
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
                Text(
                  'BOAS-VINDAS, LEITOR',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 4,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: secondaryColor,
                      ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Apps escolhidos a dedo,\n',
                        style: AppTextStyles.titleLargeNormal.copyWith(
                          color: titleColor,
                          fontSize: 58,
                          height: 1.02,
                        ),
                      ),
                      TextSpan(
                        text: 'como livros em uma estante.',
                        style: AppTextStyles.titleLargeItalic.copyWith(
                          color: AppColors.accent,
                          fontSize: 58,
                          height: 1.02,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                HomeCarousel(
                  apps: _featuredApps,
                  currentPage: _currentPage,
                  controller: _pageController,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  onOpenExternal: _openPlaceholderUrl,
                ),
                const SizedBox(height: 46),
                SectionHeader(
                  title: 'Mais populares',
                  subtitle: 'Os preferidos da comunidade',
                  actionLabel: 'Ver tudo',
                  onAction: () => context.goNamed(AppRoutes.CATEGORIES),
                  titleColor: titleColor,
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 18),
                ResponsiveGrid(
                  minItemWidth: 230,
                  spacing: 14,
                  children: [
                    for (final app in _popularApps)
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

  Future<void> _openPlaceholderUrl() async {
    final uri = Uri.parse('https://www.google.com');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}










