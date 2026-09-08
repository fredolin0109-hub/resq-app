import 'package:flutter/material.dart';
import '../../domain/entities/offline_entities.dart';

/// Card for displaying a peer node in the BLE / LoRa mesh network.
class MeshDeviceCard extends StatelessWidget {
  final MeshDevice device;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;
  final VoidCallback? onTap;

  const MeshDeviceCard({
    super.key,
    required this.device,
    this.onConnect,
    this.onDisconnect,
    this.onTap,
  });

  String _formatLastSeen(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typeColor = device.type.color;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: device.isConnected
              ? Colors.green.withValues(alpha: 0.5)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon, Name, Type Badge & Connection Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(device.type.icon, size: 20, color: typeColor),
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
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${device.id} • ${device.district}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (device.isConnected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'LINKED',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Signal, Battery & Hops Metrics Row
              Row(
                children: [
                  // Signal Bar
                  Row(
                    children: [
                      Icon(
                        Icons.signal_cellular_alt_rounded,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${device.rssiDbm} dBm (${device.signalBarLabel})',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Battery
                  Row(
                    children: [
                      Icon(
                        Icons.battery_std_rounded,
                        size: 14,
                        color: device.batteryPercent > 30
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${device.batteryPercent}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Hops Count
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${device.hopsCount} Hop${device.hopsCount > 1 ? 's' : ''}',
                      style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Last seen & Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last seen: ${_formatLastSeen(device.lastSeen)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                  if (device.isConnected)
                    OutlinedButton(
                      onPressed: onDisconnect,
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text('Disconnect', style: TextStyle(fontSize: 11)),
                    )
                  else
                    FilledButton.icon(
                      onPressed: onConnect,
                      icon: const Icon(Icons.link_rounded, size: 14),
                      label: const Text('Connect Link', style: TextStyle(fontSize: 11)),
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
