import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';

/// Responsive overview card displaying asset counts across all 6 vehicle types.
class FleetSummaryWidget extends StatelessWidget {
  final FleetSummaryMetrics fleet;
  final ValueChanged<VehicleType>? onTypeSelected;

  const FleetSummaryWidget({
    super.key,
    required this.fleet,
    this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Fleet Summary: ${fleet.totalVehicles} Total Vehicles',
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
                Row(
                  children: [
                    Icon(Icons.directions_car_filled_rounded, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Fleet Assets Overview',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '${fleet.totalVehicles} Total',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVehicleStat(context, 'Ambulances', fleet.ambulances, Icons.medical_services_rounded, Colors.red.shade600, VehicleType.ambulance),
                _buildVehicleStat(context, 'Fire Trucks', fleet.fireTrucks, Icons.local_fire_department_rounded, Colors.orange.shade700, VehicleType.fireTruck),
                _buildVehicleStat(context, 'Rescue Boats', fleet.rescueBoats, Icons.sailing_rounded, Colors.blue.shade700, VehicleType.rescueBoat),
                _buildVehicleStat(context, 'Drones', fleet.drones, Icons.flight_rounded, Colors.teal.shade700, VehicleType.drone),
                _buildVehicleStat(context, 'Earth Movers', fleet.earthMovers, Icons.construction_rounded, Colors.amber.shade900, VehicleType.earthMover),
                _buildVehicleStat(context, 'Support 4x4', fleet.supportVehicles, Icons.airport_shuttle_rounded, Colors.deepPurple.shade600, VehicleType.supportVehicle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleStat(
    BuildContext context,
    String label,
    int count,
    IconData icon,
    Color color,
    VehicleType type,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onTypeSelected?.call(type),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              count.toString(),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
