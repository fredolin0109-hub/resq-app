import 'package:flutter/material.dart';
import '../../domain/entities/offline_entities.dart';

/// Top system status bar displaying Internet mode, BLE state, GPS fix, Battery, and Signal.
class OfflineStatusBadge extends StatelessWidget {
  final OfflineSystemStatus status;
  final VoidCallback? onToggleMode;

  const OfflineStatusBadge({
    super.key,
    required this.status,
    this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final modeColor = status.networkMode.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: modeColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Connection Mode & Battery
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: modeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  status.networkMode.icon,
                  color: modeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.networkMode.displayName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      status.bleState.displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Battery & Low Power Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      status.batteryPercent > 20
                          ? Icons.battery_charging_full_rounded
                          : Icons.battery_alert_rounded,
                      size: 16,
                      color: status.batteryPercent > 20
                          ? Colors.green.shade600
                          : Colors.red.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${status.batteryPercent}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 2: GPS, Active Mesh Nodes, Queued, Signal Status Pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusPill(
                icon: Icons.gps_fixed_rounded,
                label: 'GPS ${status.gpsAccuracyMeters.toStringAsFixed(1)}m',
                color: Colors.teal.shade700,
              ),
              _StatusPill(
                icon: Icons.hub_rounded,
                label: '${status.activeMeshNodesCount} Mesh Nodes',
                color: Colors.blue.shade700,
              ),
              _StatusPill(
                icon: Icons.mark_chat_unread_rounded,
                label: '${status.queuedMessagesCount} Queued',
                color: Colors.orange.shade800,
              ),
              _StatusPill(
                icon: Icons.signal_cellular_alt_rounded,
                label: '${status.signalDbm} dBm',
                color: Colors.indigo.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
