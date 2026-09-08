import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';

/// Card showing district disaster profile, risk tier, shelter status, and active operations.
class DistrictAnalyticsCard extends StatelessWidget {
  final DistrictAnalyticsItem district;
  final VoidCallback? onTap;

  const DistrictAnalyticsCard({
    super.key,
    required this.district,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final riskColor = district.riskTier.color;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: district.riskTier == RiskTier.critical
              ? Colors.red.withValues(alpha: 0.6)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: district.riskTier == RiskTier.critical ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: riskColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_city_rounded,
                          color: riskColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        district.district,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: riskColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      district.riskTier.displayName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Metrics Grid
              Row(
                children: [
                  Expanded(
                    child: _MiniMetric(
                      label: 'Incidents',
                      value: district.incidentCount.toString(),
                      icon: Icons.warning_amber_rounded,
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _MiniMetric(
                      label: 'Impacted Pop',
                      value: '${(district.populationImpacted / 1000).toStringAsFixed(1)}k',
                      icon: Icons.people_outline_rounded,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                    child: _MiniMetric(
                      label: 'Shelters Open',
                      value: '${district.sheltersOpen}/${district.totalShelters}',
                      icon: Icons.roofing_rounded,
                      color: Colors.teal,
                    ),
                  ),
                  Expanded(
                    child: _MiniMetric(
                      label: 'Active Ops',
                      value: district.activeMissionsCount.toString(),
                      icon: Icons.emergency_share_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 9,
            color: colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
