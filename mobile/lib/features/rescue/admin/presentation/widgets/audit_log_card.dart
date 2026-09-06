import 'package:flutter/material.dart';
import '../../domain/entities/admin_entities.dart';

/// Card displaying audit trail entry with user attribution, IP, and outcome status.
class AuditLogCard extends StatelessWidget {
  final AuditLogItem log;
  final VoidCallback? onTap;

  const AuditLogCard({
    super.key,
    required this.log,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final successColor = log.isSuccess ? Colors.green : Colors.red;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  log.actionType.icon,
                  color: colorScheme.onPrimaryContainer,
                  size: 18,
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
                          log.actionType.displayName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: successColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            log.isSuccess ? 'SUCCESS' : 'FAILURE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: successColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      log.details,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 11,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          log.userName,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.computer_rounded,
                          size: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          log.ipAddress,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(log.timestamp),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
