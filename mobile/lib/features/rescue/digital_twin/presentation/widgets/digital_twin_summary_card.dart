import 'package:flutter/material.dart';
import '../../domain/entities/digital_twin_entities.dart';

/// Top metric cards for Digital Twin overview and telemetry.
class DigitalTwinSummaryCard extends StatelessWidget {
  final DigitalTwinSummary summary;
  final VoidCallback? onHeatmapTap;
  final VoidCallback? onInfrastructureTap;
  final VoidCallback? onPredictionsTap;
  final VoidCallback? onAnalyticsTap;

  const DigitalTwinSummaryCard({
    super.key,
    required this.summary,
    this.onHeatmapTap,
    this.onInfrastructureTap,
    this.onPredictionsTap,
    this.onAnalyticsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Top High-Risk Pulse Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer,
                colorScheme.surfaceContainerHighest,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sensors_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Digital Twin AI Core',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'LIVE SYNC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monitoring 13 Tamil Nadu districts • ${(summary.aiPredictionAccuracy * 100).toStringAsFixed(1)}% AI Accuracy',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Grid of 4 Core Key Metrics
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.orange.shade700,
                label: 'Active Incidents',
                value: '${summary.activeIncidents}',
                subtitle: '${summary.highRiskDistricts} High-Risk Districts',
                onTap: onHeatmapTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.groups_rounded,
                iconColor: Colors.blue.shade600,
                label: 'Rescue Teams',
                value: '${summary.activeRescueTeams}',
                subtitle: '${summary.availableResourcesCount} Resources Ready',
                onTap: onAnalyticsTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.night_shelter_rounded,
                iconColor: Colors.purple.shade600,
                label: 'Shelters Active',
                value: '${summary.sheltersOccupied} / ${summary.totalShelters}',
                subtitle: '${summary.populationAtRisk} Pop. at Risk',
                onTap: onInfrastructureTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.local_hospital_rounded,
                iconColor: Colors.teal.shade600,
                label: 'Hospitals Ready',
                value: '${summary.hospitalsAvailable} / ${summary.totalHospitals}',
                subtitle: 'Trauma Units Online',
                onTap: onPredictionsTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 20, color: iconColor),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
