import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';

/// Distinctive operational status badge (Available = Green, Busy = Orange, Emergency = Red, Offline = Grey).
class TeamStatusBadge extends StatelessWidget {
  final TeamStatus status;

  const TeamStatusBadge({
    super.key,
    required this.status,
  });

  static Color getStatusColor(TeamStatus s) {
    switch (s) {
      case TeamStatus.available:
        return Colors.green.shade700;
      case TeamStatus.busy:
        return Colors.orange.shade800;
      case TeamStatus.emergency:
        return Colors.red.shade700;
      case TeamStatus.offline:
      default:
        return Colors.blueGrey.shade600;
    }
  }

  static String getStatusLabel(TeamStatus s) {
    switch (s) {
      case TeamStatus.available:
        return 'Available';
      case TeamStatus.busy:
        return 'Busy';
      case TeamStatus.emergency:
        return 'Emergency';
      case TeamStatus.offline:
      default:
        return 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(status);
    final label = getStatusLabel(status);

    return Semantics(
      label: 'Team Status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
