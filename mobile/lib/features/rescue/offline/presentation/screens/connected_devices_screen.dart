import 'package:flutter/material.dart';
import '../../domain/entities/offline_entities.dart';
import '../providers/offline_provider.dart';
import '../widgets/mesh_device_card.dart';
import '../widgets/offline_empty_view.dart';

/// Screen displaying active connected peer links with direct packet transmission and signal diagnostics.
class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  State<ConnectedDevicesScreen> createState() => _ConnectedDevicesScreenState();
}

class _ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  final _notifier = OfflineDependencies.notifier;

  void _showSendDirectPacketDialog(BuildContext context, MeshDevice device) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.send_rounded, color: device.type.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Send Direct P2P to ${device.name}',
                  style: const TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transmits an unencrypted point-to-point BLE L2CAP packet directly to ${device.id}.',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter direct tactical message...',
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
                  _notifier.enqueueMessage(
                    OfflineMessage(
                      id: 'DIRECT-${DateTime.now().millisecondsSinceEpoch}',
                      type: OfflineMessageType.chatMessage,
                      priority: MessagePriority.high,
                      status: MessageQueueStatus.sending,
                      senderId: 'DEV-COMMANDER-01',
                      senderName: 'Officer In Charge',
                      recipientId: device.id,
                      payload: textController.text.trim(),
                      timestamp: DateTime.now(),
                      retryCount: 0,
                      maxRetries: 3,
                      isRelayed: false,
                      ttlSeconds: 3600,
                      district: device.district,
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('P2P message sent to ${device.name}'),
                      backgroundColor: Colors.green.shade700,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('Send Packet'),
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
        final connected = state.connectedDevices;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Active Connected Peers'),
            centerTitle: true,
          ),
          body: connected.isEmpty
              ? OfflineEmptyView(
                  title: 'No Connected Peer Links',
                  message: 'Scan the mesh network to discover and connect with nearby rescue nodes.',
                  icon: Icons.link_off_rounded,
                  onResetFilters: () => _notifier.startBleScan(),
                )
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Active Link Info Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.green.shade700, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${connected.length} Established BLE Mesh Links',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'High-throughput relaying active. Zero internet required.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.green.shade800,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Connected Nodes List
                    for (final device in connected) ...[
                      MeshDeviceCard(
                        device: device,
                        onDisconnect: () => _notifier.disconnectDevice(device.id),
                        onTap: () => _showSendDirectPacketDialog(context, device),
                      ),
                    ],
                  ],
                ),
        );
      },
    );
  }
}
