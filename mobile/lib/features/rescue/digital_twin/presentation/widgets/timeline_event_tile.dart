import 'package:flutter/material.dart';
import '../../domain/entities/digital_twin_entities.dart';

/// Chronological event item in disaster operational history stream.
class TimelineEventTile extends StatelessWidget {
  final TimelineEvent event;
  final bool isLast;
  final VoidCallback? onTap;

  const TimelineEventTile({
    super.key,
    required this.event,
    this.isLast = false,
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
    final eventColor = event.eventType.color;

    return InkWell(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Column
            SizedBox(
              width: 50,
              child: Text(
                _formatTime(event.timestamp),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 12),

            // Timeline Spine & Node
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: eventColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: eventColor, width: 2),
                  ),
                  child: Icon(
                    event.eventType.icon,
                    size: 14,
                    color: eventColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Event Content Card
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: eventColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            event.eventType.displayName,
                            style: TextStyle(
                              color: eventColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.district,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (event.affectedCount > 0) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.people_outline_rounded,
                            size: 13,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${event.affectedCount} impacted',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          'By: ${event.loggedBy}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
