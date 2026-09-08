import 'package:flutter/material.dart';

/// Skeleton loader cards during telemetry fetches.
class SosSkeletonLoader extends StatelessWidget {
  const SosSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.45);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Metric cards row
          Row(
            children: [
              Expanded(child: _buildBox(height: 70, color: baseColor)),
              const SizedBox(width: 8),
              Expanded(child: _buildBox(height: 70, color: baseColor)),
              const SizedBox(width: 8),
              Expanded(child: _buildBox(height: 70, color: baseColor)),
            ],
          ),
          const SizedBox(height: 18),
          _buildBox(height: 130, color: baseColor),
          const SizedBox(height: 12),
          _buildBox(height: 130, color: baseColor),
          const SizedBox(height: 12),
          _buildBox(height: 130, color: baseColor),
        ],
      ),
    );
  }

  Widget _buildBox({required double height, required Color color}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
