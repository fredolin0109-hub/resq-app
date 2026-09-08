import 'package:flutter/material.dart';
import '../../domain/entities/sos_incident_entity.dart';
import '../providers/sos_provider.dart';
import 'mission_tracking_screen.dart';

/// Screen listing available rescue squads for instant emergency dispatch.
class AssignTeamScreen extends StatelessWidget {
  final SosIncidentEntity incident;
  final SosNotifier? notifier;

  const AssignTeamScreen({
    super.key,
    required this.incident,
    this.notifier,
  });

  static const String routeName = '/rescue/alerts/assign';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeNotifier = notifier ?? SosDependencies.notifier;
    final teams = activeNotifier.state.availableTeams;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Rescue Squad'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Target Incident Summary Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mission: ${incident.id} • ${incident.emergencyType}',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Target: ${incident.locationAddress}, ${incident.district}',
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Available Field Units (${teams.length})',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Available Teams Cards List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  final team = teams[index];
                  final isCurrentlyAssigned = incident.assignedTeam?.id == team.id;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCurrentlyAssigned ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.4),
                        width: isCurrentlyAssigned ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                team.name,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${team.distanceKm} km • ETA ${team.estimatedArrivalMinutes}m',
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Vehicle & Members
                        Row(
                          children: [
                            Icon(Icons.directions_car_rounded, size: 16, color: colorScheme.primary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                team.vehicle,
                                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.people_alt_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                team.members,
                                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Equipment
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: team.equipment.map((e) {
                            return Chip(
                              label: Text(e, style: const TextStyle(fontSize: 10)),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),

                        // Assign Button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () async {
                              final success = await activeNotifier.assignTeam(incident.id, team);
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${team.name} assigned and deployed!'),
                                    backgroundColor: Colors.teal.shade700,
                                  ),
                                );
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    settings: const RouteSettings(name: MissionTrackingScreen.routeName),
                                    builder: (_) => MissionTrackingScreen(
                                      incident: activeNotifier.state.selectedIncident ?? incident,
                                      notifier: activeNotifier,
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.send_rounded, size: 18),
                            label: Text(isCurrentlyAssigned ? 'Re-confirm Deployment' : 'Assign & Deploy Unit'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
