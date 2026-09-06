import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';
import 'team_status_badge.dart';

/// Card component rendering an individual rescue team squad.
class TeamCard extends StatelessWidget {
  final RescueTeamDetailEntity team;
  final VoidCallback onTap;

  const TeamCard({
    super.key,
    required this.team,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = TeamStatusBadge.getStatusColor(team.status);

    return Semantics(
      button: true,
      label: '${team.id}: ${team.name} in ${team.district}. Status: ${team.status.name}. Leader: ${team.leaderName}. Members: ${team.membersCount}.',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Team ID, District & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            team.id,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${team.district} District',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    TeamStatusBadge(status: team.status),
                  ],
                ),
                const SizedBox(height: 10),

                // Team Name
                Text(
                  team.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Leader & Members Count
                Row(
                  children: [
                    Icon(Icons.person_pin_rounded, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Leader: ${team.leaderName}',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 14),
                    Icon(Icons.groups_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      '${team.membersCount} Members',
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Vehicle Assigned
                Row(
                  children: [
                    Icon(Icons.directions_car_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        team.assignedVehicle != null
                            ? '${team.assignedVehicle!.typeName} (${team.assignedVehicle!.vehicleNumber})'
                            : 'No dedicated vehicle assigned',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: team.assignedVehicle != null ? colorScheme.onSurface : Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Current Mission Banner if Busy/Emergency
                if (team.currentMission != null && team.currentMission!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.crisis_alert_rounded, size: 14, color: statusColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Active Mission: ${team.currentMission}',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
