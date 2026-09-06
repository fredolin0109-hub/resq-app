import 'package:flutter/material.dart';
import '../../domain/entities/offline_entities.dart';

/// Tile displaying an audit record in the Synchronization History stream.
class SyncRecordTile extends StatelessWidget {
  final SyncRecord record;

  const SyncRecordTile({
    super.key,
    required this.record,
  });

  String _formatDateTime(DateTime time) {
    return '${time.month}/${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSuccess = record.status == SyncStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: ID, Category & Status Badge
          Row(
            children: [
              Icon(
                isSuccess ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                size: 18,
                color: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                record.id,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSuccess
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isSuccess ? 'SYNCHRONIZED' : 'SYNC FAILED',
                  style: TextStyle(
                    color: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Items count, Deduplicated & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${record.itemCount} items (${record.syncType.displayName})',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (record.deduplicatedCount > 0)
                Text(
                  '${record.deduplicatedCount} deduplicated',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Strategy: ${record.resolutionApplied == ConflictResolutionStrategy.latestTimestampWins ? 'Latest Timestamp' : 'Server Default'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
              Text(
                _formatDateTime(record.startedAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          if (record.failureReason != null) ...[
            const SizedBox(height: 6),
            Text(
              'Reason: ${record.failureReason}',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
