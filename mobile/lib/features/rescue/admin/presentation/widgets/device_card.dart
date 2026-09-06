import 'package:flutter/material.dart';
import '../../domain/entities/admin_entities.dart';

/// Card showing hardware device node, battery, connection state, and storage telemetry.
class DeviceCard extends StatelessWidget {
  final ManagedDevice device;
  final VoidCallback? onTap;

  const DeviceCard({
    super.key,
    required this.device,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final connColor = device.isConnected ? Colors.green : Colors.red;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      device.type.icon,
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Paired: ${device.pairedTeam}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: connColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: connColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: connColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          device.isConnected ? 'ONLINE' : 'OFFLINE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: connColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Telemetry stats row
              Row(
                children: [
                  _DeviceMiniStat(
                    icon: Icons.battery_charging_full_rounded,
                    value: '${device.batteryPercent}%',
                    label: 'Battery',
                    color: device.batteryPercent < 20 ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _DeviceMiniStat(
                    icon: Icons.network_check_rounded,
                    value: '${device.signalStrengthDbm} dBm',
                    label: 'Signal',
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 12),
                  _DeviceMiniStat(
                    icon: Icons.map_outlined,
                    value: '${device.mapCacheMb.toInt()} MB',
                    label: 'Map Cache',
                    color: Colors.teal,
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      device.firmwareVersion,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        color: colorScheme.onSurfaceVariant,
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
}

class _DeviceMiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _DeviceMiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
