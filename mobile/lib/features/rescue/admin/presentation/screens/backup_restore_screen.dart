import 'package:flutter/material.dart';
import '../../domain/entities/admin_entities.dart';
import '../providers/admin_provider.dart';
import '../providers/admin_state.dart';
import '../widgets/admin_empty_view.dart';
import '../widgets/admin_skeleton_loader.dart';

/// Screen for creating snapshots, restoring state, importing/exporting configurations.
class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final _notifier = AdminDependencies.notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final backups = state.backups;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Backup & Disaster Recovery'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: state.isCreatingBackup
                ? null
                : () => _showCreateBackupDialog(context),
            icon: state.isCreatingBackup
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.add_to_photos_rounded),
            label: Text(state.isCreatingBackup
                ? 'Creating Snapshot...'
                : 'Create Backup'),
          ),
          body: state.status == AdminViewStatus.loading && backups.isEmpty
              ? const AdminSkeletonLoader(itemCount: 4)
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    // Banner card
                    _buildBannerCard(context),
                    const SizedBox(height: 16),

                    // Quick Configuration Export & Import Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _exportSettingsModal(context),
                            icon: const Icon(Icons.file_upload_outlined, size: 18),
                            label: const Text('Export JSON'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _importSettingsModal(context),
                            icon: const Icon(Icons.file_download_outlined, size: 18),
                            label: const Text('Import JSON'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Snapshot Archive (${backups.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (backups.isEmpty)
                      AdminEmptyView(
                        title: 'No Backups Found',
                        message:
                            'Tap "Create Backup" to generate a full snapshot.',
                        actionLabel: 'Create Snapshot',
                        onAction: () => _showCreateBackupDialog(context),
                      )
                    else
                      ...backups.map((b) => _buildBackupTile(context, b)),
                    const SizedBox(height: 80),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildBannerCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.security_update_good_rounded,
                color: colorScheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Immutable System State Snapshots',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Preserves all user RBAC assignments, team telemetry, offline mesh routing tables, and audit trail logs.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupTile(BuildContext context, BackupSnapshot backup) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade800.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_rounded,
                color: Colors.amber.shade800,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    backup.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${backup.id} • ${backup.recordsCount} items • ${backup.sizeKb} KB',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    backup.createdAt.toLocal().toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings_backup_restore_rounded),
              tooltip: 'Restore This Snapshot',
              color: colorScheme.primary,
              onPressed: () => _confirmRestore(context, backup),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateBackupDialog(BuildContext context) {
    final controller = TextEditingController(
      text: 'Manual State Snapshot (${DateTime.now().day}/${DateTime.now().month})',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Create New Snapshot'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Snapshot Label',
              hintText: 'e.g. Pre-Cyclone Preparedness Backup',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                final b = await _notifier.createBackup(controller.text);
                if (mounted && b != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Backup ${b.name} created successfully!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Create Snapshot'),
            ),
          ],
        );
      },
    );
  }

  void _confirmRestore(BuildContext context, BackupSnapshot backup) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Restore System State?'),
          content: Text(
            'Restoring from snapshot "${backup.name}" will revert local registries, hardware sync indexes, and configurations to ${backup.createdAt.toLocal()}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                final ok = await _notifier.restoreBackup(backup.id);
                if (mounted && ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Restored system state from ${backup.id}.'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Confirm Restore'),
            ),
          ],
        );
      },
    );
  }

  void _exportSettingsModal(BuildContext context) {
    final jsonStr = _notifier.exportSettingsJson();
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Exported Application Settings JSON',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  jsonStr,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings JSON copied to clipboard.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Copy JSON Configuration'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _importSettingsModal(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Import Configuration JSON'),
          content: TextField(
            controller: controller,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: 'Paste settings JSON payload here...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                final ok = await _notifier.importSettingsJson(controller.text);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok
                          ? 'Configuration imported successfully!'
                          : 'Invalid JSON format. Import failed.'),
                      backgroundColor: ok ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }
}
