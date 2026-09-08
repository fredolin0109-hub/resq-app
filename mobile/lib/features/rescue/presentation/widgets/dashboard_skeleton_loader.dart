import 'package:flutter/material.dart';

/// Shimmer/Skeleton loading placeholders for tactical dashboard.
class DashboardSkeletonLoader extends StatelessWidget {
  const DashboardSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Skeleton
          _buildSkeletonBox(height: 84, color: baseColor),
          const SizedBox(height: 20),

          // 2x2 Metric Cards Skeleton
          Row(
            children: [
              Expanded(child: _buildSkeletonBox(height: 110, color: baseColor)),
              const SizedBox(width: 12),
              Expanded(child: _buildSkeletonBox(height: 110, color: baseColor)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSkeletonBox(height: 110, color: baseColor)),
              const SizedBox(width: 12),
              Expanded(child: _buildSkeletonBox(height: 110, color: baseColor)),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Action Header & Grid Skeleton
          _buildSkeletonBox(width: 140, height: 20, color: baseColor),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSkeletonBox(height: 80, color: baseColor)),
              const SizedBox(width: 10),
              Expanded(child: _buildSkeletonBox(height: 80, color: baseColor)),
              const SizedBox(width: 10),
              Expanded(child: _buildSkeletonBox(height: 80, color: baseColor)),
              const SizedBox(width: 10),
              Expanded(child: _buildSkeletonBox(height: 80, color: baseColor)),
            ],
          ),
          const SizedBox(height: 24),

          // Live Feed Header & Card Skeletons
          _buildSkeletonBox(width: 180, height: 20, color: baseColor),
          const SizedBox(height: 12),
          _buildSkeletonBox(height: 100, color: baseColor),
          const SizedBox(height: 12),
          _buildSkeletonBox(height: 100, color: baseColor),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({
    double? width,
    required double height,
    required Color color,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
