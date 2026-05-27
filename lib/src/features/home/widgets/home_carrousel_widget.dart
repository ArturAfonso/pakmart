import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/core/theme/app_styles.dart';
import 'package:pakmart/src/features/home/models/home_featured_app_data.dart';
import 'package:pakmart/src/features/home/widgets/carrousel_arrow_button.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({
    super.key,
    required this.apps,
    required this.currentPage,
    required this.controller,
    required this.onPageChanged,
    required this.onOpenExternal,
    this.autoAdvanceInterval,
  });

  final List<HomeFeaturedAppData> apps;
  final int currentPage;
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final Future<void> Function(String url) onOpenExternal;
  final Duration? autoAdvanceInterval;

  static const _heroGradients = [
    [Color(0xFFB25748), Color(0xFF5C2203)],
    [Color(0xFF0C4A5B), Color(0xFF04232D)],
    [Color(0xFF6A5143), Color(0xFF23150E)],
  ];

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _setupAutoAdvance();
  }

  @override
  void didUpdateWidget(covariant HomeCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final intervalChanged = oldWidget.autoAdvanceInterval != widget.autoAdvanceInterval;
    final appsChanged = oldWidget.apps.length != widget.apps.length;

    if (intervalChanged || appsChanged) {
      _setupAutoAdvance();
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _setupAutoAdvance() {
    _autoAdvanceTimer?.cancel();

    final interval = widget.autoAdvanceInterval;
    if (interval == null || interval <= Duration.zero || widget.apps.length < 2) {
      return;
    }

    _autoAdvanceTimer = Timer.periodic(interval, (_) {
      if (!mounted || widget.apps.length < 2) {
        return;
      }

      final current = widget.controller.hasClients
          ? (widget.controller.page?.round() ?? widget.currentPage)
          : widget.currentPage;
      final next = (current + 1) % widget.apps.length;

      widget.controller.animateToPage(next, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.apps.isEmpty) {
      return const SizedBox(height: 430, child: Center(child: CircularProgressIndicator()));
    }

    return SizedBox(
      height: 430,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: PageView.builder(
                controller: widget.controller,
                onPageChanged: widget.onPageChanged,
                itemCount: widget.apps.length,
                itemBuilder: (context, index) {
                  final app = widget.apps[index];
                  final fallback = HomeCarousel._heroGradients[index % HomeCarousel._heroGradients.length];
                  final colors = <Color>[app.heroGradientStart ?? fallback[0], app.heroGradientEnd ?? fallback[1]];

                  return InkWell(
                    onTap: app.detailRouteAppId == null
                        ? null
                        : () => context.pushNamed(
                            AppRoutes.APP_INFO,
                            pathParameters: {AppRoutes.appIdParam: app.detailRouteAppId!},
                          ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          
                          begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: colors),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(36, 28, 36, 24),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxWidth < 820;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
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
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
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
                                              onPressed: () => widget.onOpenExternal(app.flathubUrl),
                                              style: FilledButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: const Color(0xFF2D2926),
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                              ),
                                              icon: const Icon(Icons.open_in_new, size: 18),
                                              label: const Text('Ver no Flathub'),
                                            ),
                                            const SizedBox(height: 24),
                                          ],
                                        ),
                                      ),
                                      if (!compact) ...[
                                        const SizedBox(width: 24),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.15,
                                          height: MediaQuery.of(context).size.width * 0.15,
                                          decoration: BoxDecoration(
                                            color: app.iconBackground,
                                            borderRadius: BorderRadius.circular(32),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(24),
                                            child: app.iconUrl == null
                                                ? Icon(
                                                    app.iconData ?? Icons.apps_rounded,
                                                    size: 86,
                                                    color: Colors.white.withValues(alpha: 0.9),
                                                  )
                                                : Image.network(
                                                    app.iconUrl!,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Icon(
                                                        app.iconData ?? Icons.apps_rounded,
                                                        size: 86,
                                                        color: Colors.white.withValues(alpha: 0.9),
                                                      );
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    CarouselArrowButton(
                                      icon: Icons.chevron_left_rounded,
                                      onPressed: () {
                                        final previous = widget.currentPage == 0
                                            ? widget.apps.length - 1
                                            : widget.currentPage - 1;
                                        widget.controller.animateToPage(
                                          previous,
                                          duration: const Duration(milliseconds: 280),
                                          curve: Curves.easeOutCubic,
                                        );
                                      },
                                    ),
                                    const Spacer(),
                                    for (var index = 0; index < widget.apps.length; index++) ...[
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        width: index == widget.currentPage ? 22 : 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: index == widget.currentPage ? 2 : 0.78),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                      ),
                                      if (index != widget.apps.length - 1) const SizedBox(width: 6),
                                    ],
                                    const Spacer(),
                                    CarouselArrowButton(
                                      icon: Icons.chevron_right_rounded,
                                      onPressed: () {
                                        final next = widget.currentPage == widget.apps.length - 1
                                            ? 0
                                            : widget.currentPage + 1;
                                        widget.controller.animateToPage(
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
