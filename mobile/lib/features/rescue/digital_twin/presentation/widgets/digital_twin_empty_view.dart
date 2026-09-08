import 'package:flutter/material.dart';

/// Clean state widget shown when no Digital Twin data matches filters or queries.
class DigitalTwinEmptyView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onResetFilters;

  const DigitalTwinEmptyView({
    super.key,
    this.title = 'No Digital Twin Data Found',
    this.message = 'No active points, infrastructure, or predictions match the selected district or criteria.',
    this.icon = Icons.sensors_off_rounded,
    this.onResetFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (onResetFilters != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onResetFilters,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reset All Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
