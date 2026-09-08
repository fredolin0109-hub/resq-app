import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';

/// Card showing individual team performance scorecard with metrics and score badge.
class TeamPerformanceCard extends StatelessWidget {
  final TeamPerformanceItem team;
  final int rank;
  final VoidCallback? onTap;

  const TeamPerformanceCard({
    super.key,
    required this.team,
    required this.rank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color rankColor;
    if (rank == 1) {
      rankColor = const Color(0xFFFFD700); // Gold
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Silver
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32); // Bronze
    } else {
      rankColor = colorScheme.outline;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: rank <= 3
              ? rankColor.withValues(alpha: 0.6)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: rank <= 3 ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Rank Badge
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: rankColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: rankColor, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '#$rank',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: rank <= 3 ? rankColor : colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Team Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            team.teamName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            team.district,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Leader: ${team.leaderName}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Quick stats
                    Row(
                      children: [
                        _SmallTag(
                          icon: Icons.shield_rounded,
                          label: '${team.rescuesCompleted} Rescued',
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        _SmallTag(
                          icon: Icons.timer_outlined,
                          label: '${team.avgResponseTimeMinutes}m resp',
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 8),
                        _SmallTag(
                          icon: Icons.check_circle_outline_rounded,
                          label: '${team.successRatePercent}% win',
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Score pill
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.purple.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${team.performanceScore}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          'SCORE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
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
    );
  }
}

class _SmallTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SmallTag({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
