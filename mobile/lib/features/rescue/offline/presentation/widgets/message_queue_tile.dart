import 'package:flutter/material.dart';
import '../../domain/entities/offline_entities.dart';

/// Tile displaying an item in the Store-and-Forward offline transmission queue.
class MessageQueueTile extends StatelessWidget {
  final OfflineMessage message;
  final VoidCallback? onRetry;
  final VoidCallback? onTap;

  const MessageQueueTile({
    super.key,
    required this.message,
    this.onRetry,
    this.onTap,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = message.status.color;
    final priorityColor = message.priority.color;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: message.priority == MessagePriority.critical
              ? Colors.red.withValues(alpha: 0.4)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Type Icon, Priority, Status Badge & Time
              Row(
                children: [
                  Icon(message.type.icon, size: 16, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    message.type.displayName,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      message.priority.displayName,
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(message.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Payload Snippet
              Text(
                message.payload,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Footer: Sender, Status Badge, Retry Count & Manual Retry Action
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'From: ${message.senderName} (${message.district})',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(message.status.icon, size: 11, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          message.status.displayName,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (message.retryCount > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      '(${message.retryCount}/${message.maxRetries})',
                      style: TextStyle(
                        fontSize: 10,
                        color: message.retryCount >= message.maxRetries
                            ? Colors.red
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  if (message.status == MessageQueueStatus.failed && onRetry != null) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      onPressed: onRetry,
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Retry transmission',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
