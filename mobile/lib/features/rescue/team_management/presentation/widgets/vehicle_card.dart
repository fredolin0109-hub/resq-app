import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';

/// Card component rendering a single fleet vehicle asset.
class VehicleCard extends StatelessWidget {
  final VehicleEntity vehicle;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onTap,
  });

  Color _getStatusColor(VehicleStatus s) {
    switch (s) {
      case VehicleStatus.available:
        return Colors.green.shade700;
      case VehicleStatus.dispatched:
        return Colors.orange.shade800;
      case VehicleStatus.maintenance:
        return Colors.amber.shade900;
      case VehicleStatus.offline:
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(VehicleType t) {
    switch (t) {
      case VehicleType.ambulance:
        return Icons.medical_services_rounded;
      case VehicleType.fireTruck:
        return Icons.local_fire_department_rounded;
      case VehicleType.rescueBoat:
        return Icons.sailing_rounded;
      case VehicleType.drone:
        return Icons.flight_rounded;
      case VehicleType.earthMover:
        return Icons.construction_rounded;
      case VehicleType.supportVehicle:
      default:
        return Icons.airport_shuttle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(vehicle.status);
    final typeIcon = _getTypeIcon(vehicle.type);

    return Semantics(
      button: true,
      label: '${vehicle.vehicleNumber}: ${vehicle.typeName}. Status: ${vehicle.status.name}. Driver: ${vehicle.currentDriver}.',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Number & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(typeIcon, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          vehicle.vehicleNumber,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        vehicle.status.name.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Text(
                  vehicle.typeName,
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),

                // Metrics Row: Fuel, Capacity, Driver, Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetric(Icons.local_gas_station_rounded, 'Fuel ${vehicle.fuelPercentage}%', Colors.amber.shade900),
                    _buildMetric(Icons.battery_charging_full_rounded, 'Bat ${vehicle.batteryPercentage}%', Colors.green.shade700),
                    _buildMetric(Icons.people_alt_rounded, 'Cap ${vehicle.capacity}', colorScheme.primary),
                  ],
                ),
                const Divider(height: 20),

                // Driver & Location
                Row(
                  children: [
                    Icon(Icons.person_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(vehicle.currentDriver, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 14),
                    Icon(Icons.location_on_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${vehicle.location}, ${vehicle.district}',
                        style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
