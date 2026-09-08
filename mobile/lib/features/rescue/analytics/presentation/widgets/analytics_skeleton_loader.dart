import 'package:flutter/material.dart';

/// Shimmer skeleton loader placeholder while telemetry metrics are being computed.
class AnalyticsSkeletonLoader extends StatefulWidget {
  final int itemCount;

  const AnalyticsSkeletonLoader({
    super.key,
    this.itemCount = 4,
  });

  @override
  State<AnalyticsSkeletonLoader> createState() =>
      _AnalyticsSkeletonLoaderState();
}

class _AnalyticsSkeletonLoaderState extends State<AnalyticsSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.3 + (_controller.value * 0.4);
        final baseColor =
            colorScheme.surfaceContainerHighest.withValues(alpha: opacity);

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: widget.itemCount,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Container(
              height: 110,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 160,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 220,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
