import 'package:flutter/material.dart';

/// Skeleton loader placeholders for squads and fleet assets.
class TeamManagementSkeletonLoader extends StatelessWidget {
  const TeamManagementSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.45);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildBox(height: 75, color: baseColor)),
              const SizedBox(width: 8),
              Expanded(child: _buildBox(height: 75, color: baseColor)),
              const SizedBox(width: 8),
              Expanded(child: _buildBox(height: 75, color: baseColor)),
            ],
          ),
          const SizedBox(height: 18),
          _buildBox(height: 110, color: baseColor),
          const SizedBox(height: 14),
          _buildBox(height: 140, color: baseColor),
          const SizedBox(height: 12),
          _buildBox(height: 140, color: baseColor),
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
