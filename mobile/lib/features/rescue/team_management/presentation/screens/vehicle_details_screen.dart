import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';

/// Detailed view for a single fleet vehicle asset.
class VehicleDetailsScreen extends StatelessWidget {
  final VehicleEntity vehicle;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicle,
  });

  static const String routeName = '/rescue/fleet/details';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.vehicleNumber),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vehicle.typeName,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: vehicle.isAvailable ? Colors.green.withValues(alpha: 0.12) : Colors.orange.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            vehicle.status.name.toUpperCase(),
                            style: TextStyle(
                              color: vehicle.isAvailable ? Colors.green.shade800 : Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Registration: ${vehicle.vehicleNumber} • District: ${vehicle.district}',
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Gauges Row
              Row(
                children: [
                  Expanded(
                    child: _buildGaugeCard(
                      context,
                      title: 'Fuel Level',
                      value: '${vehicle.fuelPercentage}%',
                      icon: Icons.local_gas_station_rounded,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGaugeCard(
                      context,
                      title: 'Battery Level',
                      value: '${vehicle.batteryPercentage}%',
                      icon: Icons.battery_charging_full_rounded,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGaugeCard(
                      context,
                      title: 'Capacity',
                      value: '${vehicle.capacity} seats',
                      icon: Icons.people_alt_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Operations & Driver
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asset Telemetry & Stationing', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildInfoRow('Designated Driver', vehicle.currentDriver, Icons.person_rounded),
                    const Divider(height: 16),
                    _buildInfoRow('Stationed Depot', '${vehicle.location}, ${vehicle.district}', Icons.location_on_rounded),
                    const Divider(height: 16),
                    _buildInfoRow('Maintenance Status', vehicle.maintenanceStatus, Icons.build_circle_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGaugeCard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
