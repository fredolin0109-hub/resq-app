import 'package:flutter/material.dart';

/// Skeleton placeholder loader for offline communication views.
class OfflineSkeletonLoader extends StatefulWidget {
  const OfflineSkeletonLoader({super.key});

  @override
  State<OfflineSkeletonLoader> createState() => _OfflineSkeletonLoaderState();
}

class _OfflineSkeletonLoaderState extends State<OfflineSkeletonLoader>
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
            // Status Header Skeleton
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),

            // Grid Cards Skeleton
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Items Skeleton List
            for (int i = 0; i < 4; i++) ...[
              Container(
                height: 100,
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
