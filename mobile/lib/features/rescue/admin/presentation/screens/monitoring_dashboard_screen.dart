import 'package:flutter/material.dart';
import '../providers/admin_provider.dart';
import '../providers/admin_state.dart';
import '../widgets/metric_gauge_card.dart';
import '../widgets/admin_skeleton_loader.dart';

/// Screen for live server telemetry, latency metrics, synchronization queue, and memory load.
class MonitoringDashboardScreen extends StatefulWidget {
  const MonitoringDashboardScreen({super.key});

  @override
  State<MonitoringDashboardScreen> createState() =>
      _MonitoringDashboardScreenState();
}

class _MonitoringDashboardScreenState extends State<MonitoringDashboardScreen> {
  final _notifier = AdminDependencies.notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final health = state.health;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Live Monitoring & Telemetry'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Poll Live Telemetry',
                onPressed: () => _notifier.refresh(),
              ),
            ],
          ),
          body: state.status == AdminViewStatus.loading &&
                  health.memoryUsageMb == 0
              ? const AdminSkeletonLoader(itemCount: 4)
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    // Top Live Status Banner
                    _buildTopStatusBanner(context, health),
                    const SizedBox(height: 16),

                    // Metric Gauges
                    MetricGaugeCard(
                      title: 'API Server Latency',
                      currentVal: '${health.apiLatencyMs} ms',
                      subTitle: 'Target: < 100 ms • Uptime: 99.98%',
                      percent: (health.apiLatencyMs / 200.0 * 100).clamp(0, 100),
                      color: Colors.green,
                      icon: Icons.speed_rounded,
                    ),
                    const SizedBox(height: 8),

                    MetricGaugeCard(
                      title: 'Sync Queue Load',
                      currentVal: '${health.syncQueueLength} items',
                      subTitle: 'Outbound BLE/LoRa/Cloud telemetry queue',
                      percent: (health.syncQueueLength / 50.0 * 100).clamp(0, 100),
                      color: Colors.blueAccent,
                      icon: Icons.sync_alt_rounded,
                    ),
                    const SizedBox(height: 8),

                    MetricGaugeCard(
                      title: 'Device Memory (RAM)',
                      currentVal:
                          '${health.memoryUsageMb.toInt()} / ${health.memoryTotalMb.toInt()} MB',
                      subTitle:
                          '${health.memoryPercent.toStringAsFixed(1)}% Allocated by App & Map Tile Cache',
                      percent: health.memoryPercent,
                      color: Colors.teal,
                      icon: Icons.memory_rounded,
                    ),
                    const SizedBox(height: 8),

                    MetricGaugeCard(
                      title: 'Disk Storage Volume',
                      currentVal:
                          '${health.storageUsedGb.toStringAsFixed(1)} / ${health.storageTotalGb} GB',
                      subTitle:
                          '${health.storagePercent.toStringAsFixed(1)}% utilized (Vector offline tiles & DB)',
                      percent: health.storagePercent,
                      color: Colors.orangeAccent,
                      icon: Icons.storage_rounded,
                    ),
                    const SizedBox(height: 8),

                    MetricGaugeCard(
                      title: 'CPU Core Utilization',
                      currentVal: '${health.cpuLoadPercent}%',
                      subTitle: 'Cryptographic BLE Mesh Verification & UI',
                      percent: health.cpuLoadPercent,
                      color: health.cpuLoadPercent > 75
                          ? Colors.red
                          : Colors.indigoAccent,
                      icon: Icons.developer_board_rounded,
                    ),
                    const SizedBox(height: 16),

                    // Subsystems health checklist
                    _buildSubsystemsChecklist(context, health),
                    const SizedBox(height: 24),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildTopStatusBanner(
      BuildContext context, dynamic health) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ALL SYSTEMS OPERATIONAL',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Zero critical service interruptions. Hardware mesh and cloud uplink responsive.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsystemsChecklist(
      BuildContext context, dynamic health) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subsystem Health Checklist',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildCheckItem('REST / WebSocket Telemetry API', true, '38ms'),
            const Divider(height: 16),
            _buildCheckItem('Encrypted Local SQLite Database', true, 'OK'),
            const Divider(height: 16),
            _buildCheckItem('Bluetooth Low Energy (BLE) Mesh Driver', true, 'Running'),
            const Divider(height: 16),
            _buildCheckItem('Global Navigation Satellite System (GNSS)', true, 'Locked 3D'),
            const Divider(height: 16),
            _buildCheckItem('Crash & Exception Log Watchdog', true, '0 Crashes'),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String name, bool isHealthy, String note) {
    return Row(
      children: [
        Icon(
          isHealthy ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: isHealthy ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          note,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
