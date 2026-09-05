import 'package:flutter/material.dart';
import '../../domain/entities/sos_incident_entity.dart';
import '../providers/sos_provider.dart';
import '../widgets/sos_priority_badge.dart';
import '../widgets/sos_status_badge.dart';
import 'assign_team_screen.dart';
import 'mission_tracking_screen.dart';

/// Comprehensive SOS details view with civilian telemetry, nearby resources, and command actions.
class SosDetailsScreen extends StatelessWidget {
  final SosIncidentEntity incident;
  final SosNotifier? notifier;

  const SosDetailsScreen({
    super.key,
    required this.incident,
    this.notifier,
  });

  static const String routeName = '/rescue/alerts/details';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeNotifier = notifier ?? SosDependencies.notifier;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          incident.id,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.timeline_rounded),
            tooltip: 'Track Mission',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: MissionTrackingScreen.routeName),
                  builder: (_) => MissionTrackingScreen(
                    incident: incident,
                    notifier: activeNotifier,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.map_rounded),
            tooltip: 'Open in Map',
            onPressed: () {
              Navigator.of(context).pushNamed('/rescue/map');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Badges & Emergency Type Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SosPriorityBadge(priority: incident.priority),
                      const SizedBox(width: 8),
                      SosStatusBadge(status: incident.status),
                    ],
                  ),
                  Text(
                    incident.timeAgo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                incident.emergencyType,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 2. Civilian Information Card with Action Buttons
              _buildCard(
                context,
                title: 'Civilian Information',
                icon: Icons.person_pin_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              incident.civilianName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              incident.civilianPhone,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton.filledTonal(
                              icon: const Icon(Icons.phone_rounded),
                              tooltip: 'Call Civilian',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Calling civilian: ${incident.civilianPhone}'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton.filledTonal(
                              icon: const Icon(Icons.sms_rounded),
                              tooltip: 'Send SMS',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Opening emergency SMS channel to ${incident.civilianPhone}'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        _buildSmallStat(context, 'Trapped Victims', '${incident.peopleCount} Persons', Icons.group_rounded),
                        const SizedBox(width: 20),
                        _buildSmallStat(context, 'Distance', '${incident.distanceKm} km', Icons.near_me_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Location & GPS Telemetry Card
              _buildCard(
                context,
                title: 'Location & Risk Telemetry',
                icon: Icons.location_on_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${incident.locationAddress}, ${incident.district}',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'GPS: ${incident.latitude.toStringAsFixed(4)}° N, ${incident.longitude.toStringAsFixed(4)}° E',
                      style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Risk Level: ${incident.riskLevel}',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4. Assigned Rescue Team Card
              _buildCard(
                context,
                title: 'Assigned Rescue Squad',
                icon: Icons.shield_rounded,
                child: incident.assignedTeam != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            incident.assignedTeam!.name,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Vehicle: ${incident.assignedTeam!.vehicle}',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            'Members: ${incident.assignedTeam!.members}',
                            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('No rescue team assigned yet.'),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  settings: const RouteSettings(name: AssignTeamScreen.routeName),
                                  builder: (_) => AssignTeamScreen(
                                    incident: incident,
                                    notifier: activeNotifier,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.group_add_rounded, size: 18),
                            label: const Text('Assign Team'),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 14),

              // 5. Nearby Hospitals & Shelters
              _buildCard(
                context,
                title: 'Nearby Infrastructure',
                icon: Icons.local_hospital_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hospitals:', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: incident.nearbyHospitals.map((h) => Chip(label: Text(h, style: const TextStyle(fontSize: 11)))).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text('Shelters:', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: incident.nearbyShelters.map((s) => Chip(label: Text(s, style: const TextStyle(fontSize: 11)))).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 6. Notes & Instructions
              if (incident.notes.isNotEmpty)
                _buildCard(
                  context,
                  title: 'Incident Notes & Field Intel',
                  icon: Icons.notes_rounded,
                  child: Text(
                    incident.notes,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),
                ),
              const SizedBox(height: 28),

              // 7. Action Buttons Bottom Bar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: const RouteSettings(name: AssignTeamScreen.routeName),
                            builder: (_) => AssignTeamScreen(
                              incident: incident,
                              notifier: activeNotifier,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.assignment_ind_rounded),
                      label: const Text('Assign / Reassign'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: const RouteSettings(name: MissionTrackingScreen.routeName),
                            builder: (_) => MissionTrackingScreen(
                              incident: incident,
                              notifier: activeNotifier,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.route_rounded),
                      label: const Text('Live Tracking'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Close Mission Button
              if (incident.status != SosStatus.closed)
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      await activeNotifier.advanceStatus(
                        incident.id,
                        SosStatus.closed,
                        note: 'Mission marked closed by Incident Commander.',
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mission successfully closed.')),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.green),
                    label: const Text('Close Mission (Mark Resolved)', style: TextStyle(color: Colors.green)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSmallStat(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
