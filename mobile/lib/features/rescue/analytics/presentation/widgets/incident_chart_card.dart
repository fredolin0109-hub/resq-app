import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';

/// Visual breakdown card showcasing category distribution and severity matrix.
class IncidentChartCard extends StatelessWidget {
  final List<IncidentStatItem> incidents;
  final VoidCallback? onViewDetails;

  const IncidentChartCard({
    super.key,
    required this.incidents,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate category distribution
    final categoryCounts = <DisasterCategory, int>{};
    for (final inc in incidents) {
      categoryCounts[inc.disasterCategory] =
          (categoryCounts[inc.disasterCategory] ?? 0) + 1;
    }

    // Calculate severity distribution
    final severityCounts = <SeverityLevel, int>{};
    for (final inc in incidents) {
      severityCounts[inc.severity] = (severityCounts[inc.severity] ?? 0) + 1;
    }

    final total = incidents.isEmpty ? 1 : incidents.length;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pie_chart_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Disaster Breakdown Matrix',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (onViewDetails != null)
                  TextButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Category Distribution ($total records)',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            // Progress Bar Stack
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: DisasterCategory.values.map((cat) {
                    final count = categoryCounts[cat] ?? 0;
                    if (count == 0) return const SizedBox.shrink();
                    final flex = (count / total * 100).round();
                    return Expanded(
                      flex: flex > 0 ? flex : 1,
                      child: Container(
                        color: cat.color,
                        height: 12,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Category Chips Grid
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: DisasterCategory.values.map((cat) {
                final count = categoryCounts[cat] ?? 0;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: cat.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: cat.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(cat.icon, size: 13, color: cat.color),
                      const SizedBox(width: 4),
                      Text(
                        '${cat.displayName}: $count',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 24),
            Text(
              'Severity Assessment',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: SeverityLevel.values.map((sev) {
                final count = severityCounts[sev] ?? 0;
                final pct = (count / total * 100).toInt();
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: sev.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: sev.color.withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$count',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: sev.color,
                          ),
                        ),
                        Text(
                          sev.displayName,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '$pct%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: sev.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
