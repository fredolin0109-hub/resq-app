import 'package:flutter/material.dart';
import '../../domain/entities/city_risk_entity.dart';

/// Detailed Side Panel & Bottom Sheet displaying full city risk telemetry, hospitals, shelters, and roads.
class LocationInformationPanel extends StatelessWidget {
  final CityRiskEntity city;
  final VoidCallback onClose;
  final VoidCallback onNavigateRoute;
  final VoidCallback onAssignTeam;

  const LocationInformationPanel({
    super.key,
    required this.city,
    required this.onClose,
    required this.onNavigateRoute,
    required this.onAssignTeam,
  });

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.highRisk:
        return Colors.red.shade700;
      case RiskLevel.moderate:
        return Colors.amber.shade800;
      case RiskLevel.safe:
      default:
        return Colors.green.shade700;
    }
  }

  Color _getRoadColor(RoadStatus status) {
    switch (status) {
      case RoadStatus.blockedFlooded:
        return Colors.red.shade700;
      case RoadStatus.passableWithCaution:
        return Colors.orange.shade800;
      case RoadStatus.open:
      default:
        return Colors.green.shade700;
    }
  }

  String _formatRoadStatus(RoadStatus status) {
    switch (status) {
      case RoadStatus.blockedFlooded:
        return 'Blocked / Flooded';
      case RoadStatus.passableWithCaution:
        return 'Passable With Caution';
      case RoadStatus.open:
      default:
        return 'All Roads Open';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final riskColor = _getRiskColor(city.riskLevel);
    final roadColor = _getRoadColor(city.roadStatus);

    return Semantics(
      label: 'Location Information for ${city.name}',
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Drag Bar & Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${city.district} District • ${city.area}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close details',
                    onPressed: onClose,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Risk Level Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: riskColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: riskColor, size: 24),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Risk Level: ${city.riskLevel.name.toUpperCase()}',
                              style: TextStyle(
                                color: riskColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Disaster Severity: ${city.riskPercentage}%',
                              style: TextStyle(
                                color: riskColor.withValues(alpha: 0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${city.severityRadiusKm} km radius',
                      style: TextStyle(
                        color: riskColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Grid of Key Stats (Population, Weather, Road Status)
              Row(
                children: [
                  Expanded(
                    child: _buildStatTile(
                      context,
                      icon: Icons.people_alt_rounded,
                      label: 'Population',
                      value: city.population,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatTile(
                      context,
                      icon: Icons.cloud_rounded,
                      label: 'Weather',
                      value: city.weather,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Road Status Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: roadColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.alt_route_rounded, color: roadColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Road Access: ',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        _formatRoadStatus(city.roadStatus),
                        style: TextStyle(color: roadColor, fontWeight: FontWeight.bold, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Critical Resources (Hospitals, Shelters, Teams)
              _buildResourceRow(
                context,
                icon: Icons.local_hospital_rounded,
                iconColor: Colors.red,
                title: 'Hospitals (${city.hospitalsCount})',
                items: city.hospitalNames,
              ),
              const SizedBox(height: 10),
              _buildResourceRow(
                context,
                icon: Icons.night_shelter_rounded,
                iconColor: Colors.teal,
                title: 'Shelters & Relief Camps (${city.sheltersCount})',
                items: city.shelterNames,
              ),
              const SizedBox(height: 10),
              _buildResourceRow(
                context,
                icon: Icons.groups_rounded,
                iconColor: Colors.blueAccent,
                title: 'Available Rescue Teams (${city.availableRescueTeams})',
                items: city.assignedTeams,
              ),
              const SizedBox(height: 20),

              // 5. Action Buttons (Navigation & Assign Team)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onNavigateRoute,
                      icon: const Icon(Icons.navigation_rounded, size: 18),
                      label: const Text('Navigate'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onAssignTeam,
                      icon: const Icon(Icons.group_add_rounded, size: 18),
                      label: const Text('Assign Team'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
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

  Widget _buildStatTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> items,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: items.map((name) {
                return Chip(
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  label: Text(name, style: const TextStyle(fontSize: 10)),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
