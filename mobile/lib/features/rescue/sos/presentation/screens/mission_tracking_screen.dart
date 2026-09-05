import 'package:flutter/material.dart';
import '../../domain/entities/sos_incident_entity.dart';
import '../providers/sos_provider.dart';
import '../widgets/sos_status_badge.dart';
import '../widgets/sos_timeline_widget.dart';

/// Real-time mission tracking timeline and operational status manager.
class MissionTrackingScreen extends StatelessWidget {
  final SosIncidentEntity incident;
  final SosNotifier? notifier;

  const MissionTrackingScreen({
    super.key,
    required this.incident,
    this.notifier,
  });

  static const String routeName = '/rescue/alerts/tracking';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeNotifier = notifier ?? SosDependencies.notifier;

    // Use current updated incident from notifier state if matching ID
    final currentIncident = activeNotifier.state.allIncidents.firstWhere(
      (i) => i.id == incident.id,
      orElse: () => incident,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Tracking • ${currentIncident.id}'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            tooltip: 'View in Map',
            onPressed: () => Navigator.of(context).pushNamed('/rescue/map'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mission Overview Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentIncident.emergencyType,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SosStatusBadge(status: currentIncident.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Civilian: ${currentIncident.civilianName} (${currentIncident.civilianPhone})',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Location: ${currentIncident.locationAddress}, ${currentIncident.district}',
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    if (currentIncident.assignedTeam != null) ...[
                      const Divider(height: 16),
                      Text(
                        'Assigned Squad: ${currentIncident.assignedTeam!.name}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Vehicle: ${currentIncident.assignedTeam!.vehicle}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Status Progression Control Bar
              _buildStatusProgressionSection(context, currentIncident, activeNotifier),
              const SizedBox(height: 28),

              // Chronological Lifecycle Timeline
              SosTimelineWidget(timeline: currentIncident.timeline),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusProgressionSection(
    BuildContext context,
    SosIncidentEntity current,
    SosNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    SosStatus? nextStatus;
    String actionLabel = '';
    IconData actionIcon = Icons.arrow_forward_rounded;

    switch (current.status) {
      case SosStatus.received:
        nextStatus = SosStatus.assigned;
        actionLabel = 'Assign Squad';
        actionIcon = Icons.group_add_rounded;
        break;
      case SosStatus.assigned:
        nextStatus = SosStatus.enRoute;
        actionLabel = 'Mark Team En Route';
        actionIcon = Icons.directions_car_filled_rounded;
        break;
      case SosStatus.enRoute:
        nextStatus = SosStatus.onScene;
        actionLabel = 'Mark Team On Scene';
        actionIcon = Icons.location_on_rounded;
        break;
      case SosStatus.onScene:
        nextStatus = SosStatus.rescueCompleted;
        actionLabel = 'Mark Rescue Completed';
        actionIcon = Icons.check_circle_rounded;
        break;
      case SosStatus.rescueCompleted:
        nextStatus = SosStatus.closed;
        actionLabel = 'Close Mission Archive';
        actionIcon = Icons.archive_rounded;
        break;
      case SosStatus.closed:
        nextStatus = null;
        break;
    }

    if (nextStatus == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
        ),
        child: const Center(
          child: Text(
            'Mission Completed and Archived',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operational Actions',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: () async {
                await notifier.advanceStatus(current.id, nextStatus!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Status advanced to ${nextStatus.name.toUpperCase()}')),
                  );
                }
              },
              icon: Icon(actionIcon),
              label: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}
