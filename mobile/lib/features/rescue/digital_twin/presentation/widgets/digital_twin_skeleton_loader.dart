import 'package:flutter/material.dart';

/// Skeleton placeholder loader for Digital Twin Command Center views.
class DigitalTwinSkeletonLoader extends StatefulWidget {
  const DigitalTwinSkeletonLoader({super.key});

  @override
  State<DigitalTwinSkeletonLoader> createState() =>
      _DigitalTwinSkeletonLoaderState();
}

class _DigitalTwinSkeletonLoaderState extends State<DigitalTwinSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
    final baseColor = colorScheme.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final shimmerColor = baseColor.withValues(alpha: _animation.value);

        return ListView(
          padding: const EdgeInsets.all(16.0),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Top Banner Skeleton
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 14),

            // 4 Grid Metric Cards Skeleton
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section Header Skeleton
            Container(
              width: 160,
              height: 20,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 12),

            // Item Cards Skeleton
            for (int i = 0; i < 3; i++) ...[
              Container(
                height: 110,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
