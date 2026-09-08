import 'package:flutter/material.dart';
import '../../data/datasources/offline_mock_datasource.dart';
import '../../domain/entities/offline_entities.dart';
import '../providers/offline_provider.dart';
import '../providers/offline_state.dart';
import '../widgets/message_queue_tile.dart';
import '../widgets/offline_empty_view.dart';

/// Monitoring and control center for the Store-and-Forward transmission queue.
class MessageQueueScreen extends StatefulWidget {
  const MessageQueueScreen({super.key});

  @override
  State<MessageQueueScreen> createState() => _MessageQueueScreenState();
}

class _MessageQueueScreenState extends State<MessageQueueScreen> {
  final _notifier = OfflineDependencies.notifier;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessageDetails(BuildContext context, OfflineMessage message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final statusColor = message.status.color;
        final priorityColor = message.priority.color;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(message.type.icon, color: priorityColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.type.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${message.id} • ${message.district}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      message.status.displayName,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Packet Payload:',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                message.payload,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sender Node:', style: TextStyle(fontSize: 12)),
                        Text(
                          message.senderName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Target Recipient:', style: TextStyle(fontSize: 12)),
                        Text(
                          message.recipientId,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Retries Attempted:', style: TextStyle(fontSize: 12)),
                        Text(
                          '${message.retryCount} / ${message.maxRetries}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mesh Relayed Packet:', style: TextStyle(fontSize: 12)),
                        Text(
                          message.isRelayed ? 'Yes (Multi-Hop)' : 'No (Direct)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  if (message.status == MessageQueueStatus.failed) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _notifier.retryMessage(message.id);
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Retry Now'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
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
        final filters = state.queueFilters;
        final messages = state.filteredMessages;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Message Transmission Queue'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.cleaning_services_rounded),
                tooltip: 'Purge Expired Messages',
                onPressed: () async {
                  final count = await _notifier.clearExpired();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Purged $count expired packets')),
                    );
                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Search & District Selector
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search payload, sender, district...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  _notifier.searchQueue('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (val) => _notifier.searchQueue(val),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          'District:',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: filters.district,
                                isDense: true,
                                borderRadius: BorderRadius.circular(12),
                                items: ['All', ...OfflineMockDatasource.tamilNaduDistricts]
                                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    _notifier.updateQueueFilters(filters.copyWith(district: val));
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Selector Chips
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ChoiceChip(
                      label: const Text('All Statuses'),
                      selected: filters.status == null,
                      onSelected: (_) => _notifier.setQueueStatus(null),
                    ),
                    for (final status in MessageQueueStatus.values) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        avatar: Icon(status.icon, size: 14),
                        label: Text(status.displayName),
                        selected: filters.status == status,
                        onSelected: (_) => _notifier.setQueueStatus(status),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Messages List
              Expanded(
                child: messages.isEmpty
                    ? OfflineEmptyView(
                        title: 'No Messages in Queue',
                        message: 'All offline packets have been acknowledged and synced.',
                        icon: Icons.mark_chat_read_rounded,
                        onResetFilters: () {
                          _searchController.clear();
                          _notifier.updateQueueFilters(QueueFilterOptions());
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          return MessageQueueTile(
                            message: msg,
                            onRetry: () => _notifier.retryMessage(msg.id),
                            onTap: () => _showMessageDetails(context, msg),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
