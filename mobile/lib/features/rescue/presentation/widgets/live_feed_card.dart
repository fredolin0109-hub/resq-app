import 'package:flutter/material.dart';
import '../../domain/entities/rescue_dashboard_data.dart';

/// Card rendering live emergency incident details with priority & status badges.
class LiveFeedCard extends StatelessWidget {
  final EmergencyIncident incident;
  final VoidCallback? onTap;

  const LiveFeedCard({
    super.key,
    required this.incident,
    this.onTap,
  });

  Color _getPriorityColor(IncidentPriority priority) {
    switch (priority) {
      case IncidentPriority.critical:
        return Colors.redAccent.shade700;
      case IncidentPriority.high:
        return Colors.orange.shade800;
      case IncidentPriority.medium:
        return Colors.amber.shade800;
      case IncidentPriority.low:
      default:
        return Colors.blueGrey;
    }
  }

  Color _getStatusColor(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.dispatched:
        return Colors.blue.shade700;
      case IncidentStatus.inProgress:
        return Colors.amber.shade900;
      case IncidentStatus.enRoute:
        return Colors.purple.shade700;
      case IncidentStatus.triaged:
        return Colors.teal.shade700;
      case IncidentStatus.resolved:
      default:
        return Colors.green.shade700;
    }
  }

  String _formatStatus(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.dispatched:
        return 'Dispatched';
      case IncidentStatus.inProgress:
        return 'In Progress';
      case IncidentStatus.enRoute:
        return 'En Route';
      case IncidentStatus.triaged:
        return 'Triaged';
      case IncidentStatus.resolved:
      default:
        return 'Resolved';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final priorityColor = _getPriorityColor(incident.priority);
    final statusColor = _getStatusColor(incident.status);

    return Semantics(
      button: onTap != null,
      label: '${incident.type} at ${incident.location}. Priority: ${incident.priority.name}. Status: ${_formatStatus(incident.status)}.',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Type & Priority Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        incident.type,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: priorityColor.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        incident.priority.name.toUpperCase(),
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Middle Row: Location with pin icon
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        incident.location,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bottom Row: Time and Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          incident.timeAgo,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                          ),
                        ),
                        if (incident.victimsCount > 0) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.people_alt_rounded,
                            size: 14,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${incident.victimsCount} victims',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatStatus(incident.status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
