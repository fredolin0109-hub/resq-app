import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';
import '../../data/datasources/analytics_mock_datasource.dart';
import '../providers/analytics_provider.dart';
import '../providers/analytics_state.dart';
import '../widgets/resource_utilization_card.dart';
import '../widgets/analytics_skeleton_loader.dart';

/// Screen for deep resource utilization analytics, fleet telemetry, rations, and logistics.
class ResourceUtilizationScreen extends StatefulWidget {
  const ResourceUtilizationScreen({super.key});

  @override
  State<ResourceUtilizationScreen> createState() =>
      _ResourceUtilizationScreenState();
}

class _ResourceUtilizationScreenState extends State<ResourceUtilizationScreen> {
  final _notifier = AnalyticsDependencies.notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final res = state.resourceAnalytics;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Resource Utilization'),
            centerTitle: true,
          ),
          body: state.status == AnalyticsViewStatus.loading &&
                  res.totalVehiclesActive == 0
              ? const AnalyticsSkeletonLoader(itemCount: 4)
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    // District selector
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outlineVariant
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,
                                  color: colorScheme.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Telemetry Jurisdiction:',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: state.selectedResourceDistrict,
                              isDense: true,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              items: [
                                'All',
                                ...AnalyticsMockDataSource.tnDistricts
                              ]
                                  .map((d) => DropdownMenuItem(
                                        value: d,
                                        child: Text(
                                            d == 'All' ? 'Statewide' : d),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  _notifier.setResourceDistrict(val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Primary Telemetry Card
                    ResourceUtilizationCard(
                      resources: res,
                      district: state.selectedResourceDistrict,
                    ),
                    const SizedBox(height: 16),

                    // Detailed Fleet Logistics
                    _buildSectionHeader(
                      context,
                      'Rescue Fleet & Equipment Telemetry',
                      Icons.directions_bus_rounded,
                      Colors.blueAccent,
                    ),
                    const SizedBox(height: 8),
                    _buildFleetDetailCard(context, res),
                    const SizedBox(height: 16),

                    // Medical & Relief Rations
                    _buildSectionHeader(
                      context,
                      'Relief Supplies & Aid Inventory',
                      Icons.volunteer_activism_rounded,
                      Colors.pinkAccent,
                    ),
                    const SizedBox(height: 8),
                    _buildReliefSuppliesCard(context, res),
                    const SizedBox(height: 16),

                    // Shelters & Hospitals
                    _buildSectionHeader(
                      context,
                      'Capacity & Shelter Operations',
                      Icons.health_and_safety_rounded,
                      Colors.teal,
                    ),
                    const SizedBox(height: 8),
                    _buildInfrastructureLoadCard(context, res),
                    const SizedBox(height: 24),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFleetDetailCard(
      BuildContext context, ResourceUsageAnalytics res) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMetricRow(
              'Active Rescue Boats',
              '${(res.totalVehiclesActive * 0.4).round()} units',
              Icons.directions_boat_rounded,
              Colors.cyan,
            ),
            const Divider(height: 16),
            _buildMetricRow(
              'Heavy 4x4 Evacuation Trucks',
              '${(res.totalVehiclesActive * 0.35).round()} units',
              Icons.fire_truck_rounded,
              Colors.orange,
            ),
            const Divider(height: 16),
            _buildMetricRow(
              'Ambulances & Mobile ICUs',
              '${(res.totalVehiclesActive * 0.25).round()} units',
              Icons.emergency_rounded,
              Colors.redAccent,
            ),
            const Divider(height: 16),
            _buildMetricRow(
              'Fuel Burn Efficiency',
              '${(res.fuelConsumptionLitres / (res.totalVehiclesActive == 0 ? 1 : res.totalVehiclesActive)).toStringAsFixed(1)} L / vehicle',
              Icons.speed_rounded,
              Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReliefSuppliesCard(
      BuildContext context, ResourceUsageAnalytics res) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMetricRow(
              'Trauma & First Aid Kits',
              '${res.medicalKitsUsed} deployed',
              Icons.medication_rounded,
              Colors.pinkAccent,
            ),
            const Divider(height: 16),
            _buildMetricRow(
              'Food Rations (Dry/Packaged)',
              '${res.foodRationsDistributedKg} kg distributed',
              Icons.rice_bowl_rounded,
              Colors.brown,
            ),
            const Divider(height: 16),
            _buildMetricRow(
              'Potable Drinking Water',
              '${res.waterPacketsDistributedLitres} Litres',
              Icons.water_drop_rounded,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfrastructureLoadCard(
      BuildContext context, ResourceUsageAnalytics res) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Community Shelters Occupancy',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${res.shelterOccupancyPercent}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: res.shelterOccupancyPercent > 80
                        ? Colors.red
                        : Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (res.shelterOccupancyRatio).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  res.shelterOccupancyPercent > 80 ? Colors.red : Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'District Hospital Bed Load',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${res.hospitalCapacityPercent}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: res.hospitalCapacityPercent > 80
                        ? Colors.red
                        : Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (res.hospitalCapacityRatio).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  res.hospitalCapacityPercent > 80 ? Colors.red : Colors.indigo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
