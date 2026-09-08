import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';
import '../providers/team_management_provider.dart';
import '../widgets/team_status_badge.dart';
import 'dispatch_team_screen.dart';
import 'team_members_screen.dart';

/// Comprehensive detailed telemetry dossier for an individual rescue squad.
class TeamDetailsScreen extends StatelessWidget {
  final RescueTeamDetailEntity team;
  final TeamManagementNotifier? notifier;

  const TeamDetailsScreen({
    super.key,
    required this.team,
    this.notifier,
  });

  static const String routeName = '/rescue/teams/details';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeNotifier = notifier ?? TeamManagementDependencies.notifier;

    return Scaffold(
      appBar: AppBar(
        title: Text(team.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.groups_rounded),
            tooltip: 'View Members',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: TeamMembersScreen.routeName),
                  builder: (_) => TeamMembersScreen(team: team),
                ),
              );
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
              // Header Card
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
                          team.id,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TeamStatusBadge(status: team.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      team.name,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Stationed District: ${team.district} • GPS: ${team.gpsCoordinates}',
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Squad Leadership & Roster Bar
              _buildSectionCard(
                context,
                title: 'Squad Leadership & Personnel (${team.membersCount})',
                icon: Icons.shield_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(team.leaderName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(team.leaderPhone, style: TextStyle(color: colorScheme.primary, fontSize: 12)),
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                settings: const RouteSettings(name: TeamMembersScreen.routeName),
                                builder: (_) => TeamMembersScreen(team: team),
                              ),
                            );
                          },
                          icon: const Icon(Icons.people_alt_rounded, size: 16),
                          label: const Text('Roster'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Assigned Vehicle & Battery/Fuel Gauges
              _buildSectionCard(
                context,
                title: 'Assigned Vehicle & Fleet Assets',
                icon: Icons.directions_car_filled_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (team.assignedVehicle != null) ...[
                      Text(
                        '${team.assignedVehicle!.typeName} (${team.assignedVehicle!.vehicleNumber})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildGauge('Fuel', '${team.fuelLevel}%', Colors.amber.shade900),
                          const SizedBox(width: 20),
                          _buildGauge('Battery', '${team.batteryLevel}%', Colors.green.shade700),
                        ],
                      ),
                    ] else
                      const Text('No vehicle assigned to squad.'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Equipment & Medical Gear
              _buildSectionCard(
                context,
                title: 'Equipment & Medical Gear',
                icon: Icons.inventory_2_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Field Gear:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: team.equipment.map((e) => Chip(label: Text(e, style: const TextStyle(fontSize: 10)))).toList(),
                    ),
                    const SizedBox(height: 8),
                    const Text('Medical Kits:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: team.medicalKits.map((m) => Chip(label: Text(m, style: const TextStyle(fontSize: 10)))).toList(),
                    ),
                    const SizedBox(height: 8),
                    const Text('Communication Devices:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: team.communicationDevices.map((c) => Chip(label: Text(c, style: const TextStyle(fontSize: 10)))).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Past Missions
              _buildSectionCard(
                context,
                title: 'Mission History (${team.missionHistoryCount} Operations)',
                icon: Icons.history_rounded,
                child: Column(
                  children: team.pastMissions.map((pm) {
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.check_circle_outline_rounded, size: 16, color: Colors.green),
                      title: Text(pm, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Dispatch Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: DispatchTeamScreen.routeName),
                        builder: (_) => DispatchTeamScreen(
                          preselectedTeam: team,
                          notifier: activeNotifier,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Dispatch / Reassign Squad'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildGauge(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
