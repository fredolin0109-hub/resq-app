import 'package:flutter/material.dart';

/// Friendly empty state placeholder when no active SOS incidents exist.
class SosEmptyView extends StatelessWidget {
  final VoidCallback onRefresh;

  const SosEmptyView({
    super.key,
    required this.onRefresh,
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
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                size: 58,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No active SOS alerts',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'All monitored disaster zones are currently stable. Any new incoming civilian distress beacons will stream in immediately.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh Distress Feed'),
            ),
          ],
        ),
      ),
    );
  }
}
