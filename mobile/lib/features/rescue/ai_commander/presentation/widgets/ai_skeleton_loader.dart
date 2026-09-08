import 'package:flutter/material.dart';

/// Shimmer skeleton loader for AI Commander loading states.
class AISkeletonLoader extends StatefulWidget {
  final int itemCount;

  const AISkeletonLoader({
    super.key,
    this.itemCount = 4,
  });

  @override
  State<AISkeletonLoader> createState() => _AISkeletonLoaderState();
}

class _AISkeletonLoaderState extends State<AISkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final shimmerColor = baseColor.withValues(alpha: _animation.value);

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: widget.itemCount,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 100, height: 16, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4))),
                      Container(width: 60, height: 16, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(width: double.infinity, height: 12, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 6),
                  Container(width: 220, height: 12, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 14),
                  Container(width: double.infinity, height: 36, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(8))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
