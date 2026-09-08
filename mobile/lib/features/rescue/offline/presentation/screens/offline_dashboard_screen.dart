import 'package:flutter/material.dart';
import '../../domain/entities/offline_entities.dart';
import '../providers/offline_provider.dart';
import '../providers/offline_state.dart';
import '../widgets/offline_status_badge.dart';
import '../widgets/offline_skeleton_loader.dart';
import '../widgets/mesh_device_card.dart';
import '../widgets/message_queue_tile.dart';
import 'mesh_network_monitor_screen.dart';
import 'connected_devices_screen.dart';
import 'message_queue_screen.dart';
import 'synchronization_center_screen.dart';
import 'offline_settings_screen.dart';

/// Central Command Center Dashboard for Offline Communication & Mesh Operations.
class OfflineDashboardScreen extends StatefulWidget {
  const OfflineDashboardScreen({super.key});

  @override
  State<OfflineDashboardScreen> createState() => _OfflineDashboardScreenState();
}

class _OfflineDashboardScreenState extends State<OfflineDashboardScreen> {
  final _notifier = OfflineDependencies.notifier;

  @override
  void initState() {
    super.initState();
    if (_notifier.state.status == OfflineViewStatus.initial) {
      _notifier.loadDashboard();
    }
  }

  void _showBroadcastDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.cell_tower_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Broadcast Distress Beacon'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This message packet will be transmitted over all nearby BLE and mesh hops immediately.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter emergency distress payload...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  _notifier.broadcastDistressBeacon(textController.text.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Emergency beacon broadcasted over BLE mesh.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('Broadcast Now'),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Offline Command Center'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Offline Settings',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OfflineSettingsScreen()),
                ),
              ),
            ],
          ),
          body: _buildBody(context, state),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showBroadcastDialog(context),
            icon: const Icon(Icons.emergency_rounded),
            label: const Text('Broadcast Beacon'),
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, OfflineState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.isLoading) {
      return const OfflineSkeletonLoader();
    }

    if (state.isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Offline System Error',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'Unknown hardware error',
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => _notifier.refresh(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry Hardware Link'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _notifier.refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Connectivity and Telemetry Badge
          OfflineStatusBadge(
            status: state.systemStatus,
            onToggleMode: () {
              final nextMode = state.systemStatus.networkMode.isOnline
                  ? NetworkMode.meshOnly
                  : NetworkMode.onlineWiFi;
              _notifier.switchNetworkMode(nextMode);
            },
          ),
          const SizedBox(height: 16),

          // 2. Sub-Modules Hub Grid
          Text(
            'Offline Communication Hub',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.45,
            children: [
              _HubCard(
                title: 'Mesh Network',
                subtitle: '${state.allDevices.length} Nodes Discovered',
                icon: Icons.hub_rounded,
                color: Colors.blue.shade700,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MeshNetworkMonitorScreen()),
                ),
              ),
              _HubCard(
                title: 'Connected Peers',
                subtitle: '${state.connectedDevices.length} Active BLE Links',
                icon: Icons.link_rounded,
                color: Colors.green.shade700,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConnectedDevicesScreen()),
                ),
              ),
              _HubCard(
                title: 'Message Queue',
                subtitle: '${state.systemStatus.queuedMessagesCount} Store & Forward',
                icon: Icons.mark_chat_unread_rounded,
                color: Colors.orange.shade800,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MessageQueueScreen()),
                ),
              ),
              _HubCard(
                title: 'Sync Center',
                subtitle: '${state.systemStatus.pendingSyncCount} Pending Cloud Upload',
                icon: Icons.sync_rounded,
                color: Colors.purple.shade700,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SynchronizationCenterScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Nearby Peer Nodes Preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Mesh Nodes',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MeshNetworkMonitorScreen()),
                ),
                child: const Text('View All (15)'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (final device in state.allDevices.take(3)) ...[
            MeshDeviceCard(
              device: device,
              onConnect: () => _notifier.connectDevice(device.id),
              onDisconnect: () => _notifier.disconnectDevice(device.id),
            ),
          ],
          const SizedBox(height: 16),

          // 4. Transmission Queue Preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Store & Forward Queue',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MessageQueueScreen()),
                ),
                child: const Text('View Queue (100)'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (final msg in state.allMessages.take(3)) ...[
            MessageQueueTile(
              message: msg,
              onRetry: () => _notifier.retryMessage(msg.id),
            ),
          ],
          const SizedBox(height: 60), // Spacing for FAB
        ],
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HubCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
