import 'package:flutter/material.dart';

/// Shimmer/Skeleton placeholder loader for asynchronous data states in Resource & Shelter screens.
class ResourceSkeletonLoader extends StatefulWidget {
  final int itemCount;
  final bool isGrid;

  const ResourceSkeletonLoader({
    super.key,
    this.itemCount = 5,
    this.isGrid = false,
  });

  @override
  State<ResourceSkeletonLoader> createState() => _ResourceSkeletonLoaderState();
}

class _ResourceSkeletonLoaderState extends State<ResourceSkeletonLoader>
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
        final color = baseColor.withValues(alpha: _animation.value);

        if (widget.isGrid) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: widget.itemCount,
            itemBuilder: (_, __) => _buildSkeletonCard(color, isDark),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: widget.itemCount,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSkeletonCard(color, isDark),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonCard(Color shimmerColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 160, height: 14, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 6),
                    Container(width: 90, height: 10, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(width: double.infinity, height: 8, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 80, height: 12, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4))),
              Container(width: 60, height: 12, decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4))),
            ],
          ),
        ],
      ),
    );
  }
}
