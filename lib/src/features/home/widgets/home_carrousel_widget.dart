


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';
import 'package:pakmart/src/features/home/widgets/carrousel_arrow_button.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({super.key, 
    required this.apps,
    required this.currentPage,
    required this.controller,
    required this.onPageChanged,
    required this.onOpenExternal,
  });

  final List<CategoryAppData> apps;
  final int currentPage;
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final Future<void> Function() onOpenExternal;


    static const _heroGradients = [
    [Color(0xFFB25748), Color(0xFF5C2203)],
    [Color(0xFF0C4A5B), Color(0xFF04232D)],
    [Color(0xFF6A5143), Color(0xFF23150E)],
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: PageView.builder(
                controller: controller,
                onPageChanged: onPageChanged,
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps[index];
                  final colors = _heroGradients[index % _heroGradients.length];

                  return InkWell(
                    onTap: () => context.pushNamed(
                      AppRoutes.APP_INFO,
                      pathParameters: {AppRoutes.appIdParam: app.id},
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: colors,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(36, 28, 36, 24),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxWidth < 820;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.16),
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              child: Text(
                                                'EM DESTAQUE',
                                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                      letterSpacing: 1.2,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(height: 18),
                                            Text(
                                              app.name,
                                              style: AppTextStyles.titleLarge.copyWith(
                                                color: Colors.white,
                                                fontSize: compact ? 42 : 54,
                                                height: 1,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(maxWidth: 480),
                                              child: Text(
                                                app.tagline,
                                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                      color: Colors.white.withValues(alpha: 0.9),
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.4,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            FilledButton.icon(
                                              onPressed: onOpenExternal,
                                              style: FilledButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: const Color(0xFF2D2926),
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                              ),
                                              icon: const Icon(Icons.download_rounded, size: 18),
                                              label: const Text('Ver no Flathub'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!compact) ...[
                                        const SizedBox(width: 24),
                                        Container(
                                          width: 172,
                                          height: 172,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(32),
                                          ),
                                          child: Icon(app.icon, size: 86, color: Colors.white.withValues(alpha: 0.9)),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    CarouselArrowButton(
                                      icon: Icons.chevron_left_rounded,
                                      onPressed: () {
                                        final previous = currentPage == 0 ? apps.length - 1 : currentPage - 1;
                                        controller.animateToPage(
                                          previous,
                                          duration: const Duration(milliseconds: 280),
                                          curve: Curves.easeOutCubic,
                                        );
                                      },
                                    ),
                                    const Spacer(),
                                    for (var index = 0; index < apps.length; index++) ...[
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        width: index == currentPage ? 22 : 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: index == currentPage ? 1 : 0.38),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                      ),
                                      if (index != apps.length - 1) const SizedBox(width: 6),
                                    ],
                                    const Spacer(),
                                    CarouselArrowButton(
                                      icon: Icons.chevron_right_rounded,
                                      onPressed: () {
                                        final next = currentPage == apps.length - 1 ? 0 : currentPage + 1;
                                        controller.animateToPage(
                                          next,
                                          duration: const Duration(milliseconds: 280),
                                          curve: Curves.easeOutCubic,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}