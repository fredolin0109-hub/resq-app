import 'package:flutter/material.dart';
import '../../domain/entities/offline_entities.dart';
import '../providers/offline_provider.dart';
import '../widgets/sync_record_tile.dart';

/// Screen for managing two-way synchronization, deduplication, conflict resolution, and audit history.
class SynchronizationCenterScreen extends StatefulWidget {
  const SynchronizationCenterScreen({super.key});

  @override
  State<SynchronizationCenterScreen> createState() =>
      _SynchronizationCenterScreenState();
}

class _SynchronizationCenterScreenState
    extends State<SynchronizationCenterScreen> {
  final _notifier = OfflineDependencies.notifier;
  ConflictResolutionStrategy _selectedStrategy =
      ConflictResolutionStrategy.latestTimestampWins;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final syncRecords = state.allSyncRecords;
        final pendingCount = state.systemStatus.pendingSyncCount;
        final isOnline = state.systemStatus.networkMode.isOnline;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Synchronization Center'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. Sync Action Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isOnline
                        ? Colors.green.withValues(alpha: 0.3)
                        : Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isOnline
                                ? Colors.green.withValues(alpha: 0.12)
                                : Colors.orange.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                            color: isOnline ? Colors.green.shade700 : Colors.orange.shade800,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isOnline ? 'Online Ready to Sync' : 'Mesh Standby (Offline)',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$pendingCount local deltas waiting for cloud upload',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Conflict Resolution Strategy Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Conflict Resolution:',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<ConflictResolutionStrategy>(
                            value: _selectedStrategy,
                            isDense: true,
                            borderRadius: BorderRadius.circular(10),
                            items: const [
                              DropdownMenuItem(
                                value: ConflictResolutionStrategy.latestTimestampWins,
                                child: Text('Latest Timestamp Wins'),
                              ),
                              DropdownMenuItem(
                                value: ConflictResolutionStrategy.serverAuthoritative,
                                child: Text('Server Authoritative'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedStrategy = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Manual Sync Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: state.isSyncing
                            ? null
                            : () async {
                                final res = await _notifier.triggerFullSync(
                                  strategy: _selectedStrategy,
                                );
                                if (context.mounted && res != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Synchronized ${res.itemCount} items (${res.deduplicatedCount} deduplicated)',
                                      ),
                                      backgroundColor: Colors.green.shade700,
                                    ),
                                  );
                                }
                              },
                        icon: state.isSyncing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.sync_rounded, size: 18),
                        label: Text(state.isSyncing ? 'Synchronizing Delays...' : 'Sync Now with Cloud'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Categories Sync Overview
              Text(
                'Sync Payload Categories',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _CategoryPill(icon: Icons.assignment_rounded, label: 'Mission Waypoints'),
                  _CategoryPill(icon: Icons.sos_rounded, label: 'SOS Reports'),
                  _CategoryPill(icon: Icons.inventory_2_rounded, label: 'Resource Stockpiles'),
                  _CategoryPill(icon: Icons.groups_rounded, label: 'Officer Vitals'),
                  _CategoryPill(icon: Icons.chat_bubble_rounded, label: 'Field Messages'),
                  _CategoryPill(icon: Icons.sensors_rounded, label: 'Sensor Telemetry'),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Sync Audit History
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sync Audit Log History',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${syncRecords.length} Records',
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (final record in syncRecords) ...[
                SyncRecordTile(record: record),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
