import 'package:flutter/material.dart';
import 'package:pakmart/src/features/apps/models/app_detail_data.dart';

class AppScreenshotCarousel extends StatefulWidget {
  const AppScreenshotCarousel({
    super.key,
    required this.screenshots,
    required this.titleColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  final List<AppDetailScreenshotData> screenshots;
  final Color titleColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color borderColor;

  @override
  State<AppScreenshotCarousel> createState() => _AppScreenshotCarouselState();
}

class _AppScreenshotCarouselState extends State<AppScreenshotCarousel> {
  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.96);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.screenshots.isEmpty) {
      return const SizedBox.shrink();
    }

    final activeScreenshot = widget.screenshots[_currentIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: widget.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Capturas de tela',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: widget.titleColor, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Clique para ampliar e navegar em tela cheia.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: widget.secondaryColor),
          ),
          const SizedBox(height: 18),
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.screenshots.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final screenshot = widget.screenshots[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => _openViewer(index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: widget.surfaceColor),
                            child: _NetworkScreenshot(imageUrl: screenshot.imageUrl, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (widget.screenshots.length > 1) ...[
                Positioned(
                  left: 8,
                  child: _ArrowButton(icon: Icons.chevron_left_rounded, onPressed: () => _jumpTo(_currentIndex - 1)),
                ),
                Positioned(
                  right: 8,
                  child: _ArrowButton(icon: Icons.chevron_right_rounded, onPressed: () => _jumpTo(_currentIndex + 1)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  activeScreenshot.caption ?? 'Tela ${_currentIndex + 1}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: widget.secondaryColor),
                ),
              ),
              if (widget.screenshots.length > 1)
                Wrap(
                  spacing: 8,
                  children: List.generate(widget.screenshots.length, (index) {
                    final isActive = index == _currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: isActive ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: (isActive ? widget.titleColor : widget.secondaryColor).withValues(
                          alpha: isActive ? 1 : 0.28,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _jumpTo(int index) {
    final itemCount = widget.screenshots.length;
    if (itemCount == 0) {
      return;
    }

    final nextIndex = (index + itemCount) % itemCount;
    _controller.animateToPage(nextIndex, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
  }

  Future<void> _openViewer(int initialIndex) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (dialogContext) {
        return _FullscreenScreenshotViewer(screenshots: widget.screenshots, initialIndex: initialIndex);
      },
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.36),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(width: 42, height: 42, child: Icon(icon, color: Colors.white)),
      ),
    );
  }
}

class _NetworkScreenshot extends StatelessWidget {
  const _NetworkScreenshot({required this.imageUrl, this.fit = BoxFit.contain});

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (_, _, _) {
        return const Center(child: Icon(Icons.broken_image_outlined, color: Colors.white70));
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress.expectedTotalBytes == null
                  ? null
                  : progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
            ),
          ),
        );
      },
    );
  }
}

class _FullscreenScreenshotViewer extends StatefulWidget {
  const _FullscreenScreenshotViewer({required this.screenshots, required this.initialIndex});

  final List<AppDetailScreenshotData> screenshots;
  final int initialIndex;

  @override
  State<_FullscreenScreenshotViewer> createState() => _FullscreenScreenshotViewerState();
}

class _FullscreenScreenshotViewerState extends State<_FullscreenScreenshotViewer> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenshot = widget.screenshots[_currentIndex];

    return Dialog.fullscreen(
      backgroundColor: const Color(0xFF0C0B0B),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      screenshot.caption ?? 'Captura ${_currentIndex + 1}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: widget.screenshots.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = widget.screenshots[index];
                      return InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: _NetworkScreenshot(imageUrl: item.imageUrl),
                          ),
                        ),
                      );
                    },
                  ),
                  if (widget.screenshots.length > 1) ...[
                    Positioned(
                      left: 20,
                      child: _ArrowButton(
                        icon: Icons.chevron_left_rounded,
                        onPressed: () => _jumpTo(_currentIndex - 1),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      child: _ArrowButton(
                        icon: Icons.chevron_right_rounded,
                        onPressed: () => _jumpTo(_currentIndex + 1),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_currentIndex + 1} / ${widget.screenshots.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _jumpTo(int index) {
    final itemCount = widget.screenshots.length;
    final nextIndex = (index + itemCount) % itemCount;
    _controller.animateToPage(nextIndex, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
  }
}
