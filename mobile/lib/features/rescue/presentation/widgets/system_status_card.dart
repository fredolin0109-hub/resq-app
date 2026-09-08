import 'package:flutter/material.dart';
import '../../domain/entities/rescue_dashboard_data.dart';

/// Infrastructure, Mesh network, and telemetry health monitor widget.
class SystemStatusCard extends StatelessWidget {
  final SystemStatus status;

  const SystemStatusCard({
    super.key,
    required this.status,
  });

  Color _getIndicatorColor(SystemHealthStatus health) {
    switch (health) {
      case SystemHealthStatus.operational:
        return Colors.green;
      case SystemHealthStatus.degraded:
        return Colors.amber.shade700;
      case SystemHealthStatus.offline:
      default:
        return Colors.red;
    }
  }

  String _getHealthLabel(SystemHealthStatus health) {
    switch (health) {
      case SystemHealthStatus.operational:
        return 'Active';
      case SystemHealthStatus.degraded:
        return 'Degraded';
      case SystemHealthStatus.offline:
      default:
        return 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      container: true,
      label: 'System Status: Server, GPS, Internet, Mesh with ${status.meshNodeCount} nodes, and Database all monitored.',
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.hub_rounded,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'System & Mesh Health',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${status.meshNodeCount} Nodes Active',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.spaceBetween,
              children: [
                _buildStatusItem(context, 'Server', status.server, Icons.dns_rounded),
                _buildStatusItem(context, 'GPS', status.gps, Icons.gps_fixed_rounded),
                _buildStatusItem(context, 'Internet', status.internet, Icons.wifi_rounded),
                _buildStatusItem(context, 'Mesh', status.mesh, Icons.bluetooth_audio_rounded),
                _buildStatusItem(context, 'Database', status.database, Icons.storage_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String name,
    SystemHealthStatus health,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final indicatorColor = _getIndicatorColor(health);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            name,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _getHealthLabel(health),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: indicatorColor,
            ),
          ),
        ],
      ),
    );
  }
}
