import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';

/// Telemetry card showing vehicle deployment, fuel, rations, medical supplies, and shelter load.
class ResourceUtilizationCard extends StatelessWidget {
  final ResourceUsageAnalytics resources;
  final String? district;
  final VoidCallback? onViewDetails;

  const ResourceUtilizationCard({
    super.key,
    required this.resources,
    this.district,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                      Icons.inventory_2_rounded,
                      color: Colors.teal,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resource Utilization Telemetry',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (district != null && district != 'All')
                          Text(
                            'Zone: $district',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (onViewDetails != null)
                  TextButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('Manage'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Vehicles & Fuel row
            Row(
              children: [
                Expanded(
                  child: _ResourceMetricTile(
                    title: 'Active Fleet',
                    value: '${resources.totalVehiclesActive} / ${resources.totalVehiclesDeployed}',
                    icon: Icons.directions_car_filled_rounded,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ResourceMetricTile(
                    title: 'Fuel Burn',
                    value: '${resources.fuelConsumptionLitres} L',
                    icon: Icons.local_gas_station_rounded,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Medical & Supplies row
            Row(
              children: [
                Expanded(
                  child: _ResourceMetricTile(
                    title: 'Medical Kits',
                    value: '${resources.medicalKitsUsed} deployed',
                    icon: Icons.medical_services_rounded,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ResourceMetricTile(
                    title: 'Food Relief',
                    value: '${(resources.foodRationsDistributedKg / 1000).toStringAsFixed(1)}k kg',
                    icon: Icons.fastfood_rounded,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Shelter & Hospital Capacities
            _CapacityProgressBar(
              title: 'Shelter Capacity',
              percentage: resources.shelterOccupancyPercent,
              color: resources.shelterOccupancyPercent > 85 ? Colors.red : Colors.teal,
            ),
            const SizedBox(height: 10),
            _CapacityProgressBar(
              title: 'Hospital Bed Load',
              percentage: resources.hospitalCapacityPercent,
              color: resources.hospitalCapacityPercent > 85 ? Colors.red : Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceMetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ResourceMetricTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CapacityProgressBar extends StatelessWidget {
  final String title;
  final int percentage;
  final Color color;

  const _CapacityProgressBar({
    required this.title,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$percentage%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (percentage / 100.0).clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
