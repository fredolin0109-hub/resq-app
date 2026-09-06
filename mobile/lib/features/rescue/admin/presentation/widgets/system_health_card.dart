import 'package:flutter/material.dart';
import '../../domain/entities/admin_entities.dart';

/// Top system operational health telemetry card.
class SystemHealthCard extends StatelessWidget {
  final SystemHealthMetrics health;
  final VoidCallback? onRefresh;

  const SystemHealthCard({
    super.key,
    required this.health,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isHealthy = health.systemStatus == 'Operational';
    final statusColor = isHealthy ? Colors.green : Colors.red;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isHealthy
              ? colorScheme.outlineVariant.withValues(alpha: 0.5)
              : Colors.red.withValues(alpha: 0.6),
          width: isHealthy ? 1.0 : 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Status Bar
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isHealthy
                        ? Icons.verified_user_rounded
                        : Icons.warning_amber_rounded,
                    color: statusColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'System Status: ',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            health.systemStatus.toUpperCase(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'ResQLink AI Core ${health.appVersion} (Build ${health.buildNumber})',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onRefresh != null)
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    tooltip: 'Refresh Telemetry',
                    onPressed: onRefresh,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Hardware Subsystems Grid
            Row(
              children: [
                Expanded(
                  child: _StatusPill(
                    label: 'API Core',
                    status: health.isApiHealthy
                        ? '${health.apiLatencyMs}ms'
                        : 'OFFLINE',
                    isOk: health.isApiHealthy,
                    icon: Icons.cloud_done_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatusPill(
                    label: 'SQLite DB',
                    status: health.isDatabaseConnected ? 'ONLINE' : 'ERROR',
                    isOk: health.isDatabaseConnected,
                    icon: Icons.storage_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatusPill(
                    label: 'BLE Mesh',
                    status: health.isBleServiceActive ? 'ACTIVE' : 'INACTIVE',
                    isOk: health.isBleServiceActive,
                    icon: Icons.bluetooth_audio_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatusPill(
                    label: 'GNSS / GPS',
                    status: health.isGpsLocked ? 'LOCKED' : 'NO FIX',
                    isOk: health.isGpsLocked,
                    icon: Icons.gps_fixed_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatusPill(
                    label: 'Internet',
                    status: health.isInternetConnected ? 'ONLINE' : 'OFFLINE',
                    isOk: health.isInternetConnected,
                    icon: Icons.wifi_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatusPill(
                    label: 'Battery',
                    status:
                        '${health.batteryPercent}% (${health.isCharging ? "Chg" : "Dis"})',
                    isOk: health.batteryPercent > 20,
                    icon: health.isCharging
                        ? Icons.battery_charging_full_rounded
                        : Icons.battery_5_bar_rounded,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Telemetry resource load bars
            _ResourceLoadBar(
              title: 'Storage Capacity',
              usedText:
                  '${health.storageUsedGb.toStringAsFixed(1)} / ${health.storageTotalGb} GB',
              percent: health.storagePercent,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 8),
            _ResourceLoadBar(
              title: 'Memory Utilization',
              usedText:
                  '${health.memoryUsageMb.toInt()} / ${health.memoryTotalMb.toInt()} MB',
              percent: health.memoryPercent,
              color: Colors.teal,
            ),
            const SizedBox(height: 8),
            _ResourceLoadBar(
              title: 'CPU Load',
              usedText: '${health.cpuLoadPercent}%',
              percent: health.cpuLoadPercent,
              color: health.cpuLoadPercent > 80 ? Colors.red : Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final String status;
  final bool isOk;
  final IconData icon;

  const _StatusPill({
    required this.label,
    required this.status,
    required this.isOk,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = isOk ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
                Text(
                  status,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isOk ? colorScheme.onSurface : color,
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

class _ResourceLoadBar extends StatelessWidget {
  final String title;
  final String usedText;
  final double percent;
  final Color color;

  const _ResourceLoadBar({
    required this.title,
    required this.usedText,
    required this.percent,
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
                fontSize: 11,
              ),
            ),
            Text(
              '$usedText (${percent.toStringAsFixed(1)}%)',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (percent / 100.0).clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
