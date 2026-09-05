import 'package:flutter/material.dart';
import '../../domain/entities/sos_incident_entity.dart';

/// Status indicator with distinct color, icon, and label.
class SosStatusBadge extends StatelessWidget {
  final SosStatus status;

  const SosStatusBadge({
    super.key,
    required this.status,
  });

  static Color getStatusColor(SosStatus s) {
    switch (s) {
      case SosStatus.received:
        return Colors.blue.shade700;
      case SosStatus.assigned:
        return Colors.indigo.shade700;
      case SosStatus.enRoute:
        return Colors.orange.shade800;
      case SosStatus.onScene:
        return Colors.teal.shade700;
      case SosStatus.rescueCompleted:
        return Colors.green.shade700;
      case SosStatus.closed:
      default:
        return Colors.blueGrey.shade600;
    }
  }

  static IconData getStatusIcon(SosStatus s) {
    switch (s) {
      case SosStatus.received:
        return Icons.radio_button_checked_rounded;
      case SosStatus.assigned:
        return Icons.assignment_ind_rounded;
      case SosStatus.enRoute:
        return Icons.directions_car_filled_rounded;
      case SosStatus.onScene:
        return Icons.location_on_rounded;
      case SosStatus.rescueCompleted:
        return Icons.check_circle_rounded;
      case SosStatus.closed:
      default:
        return Icons.lock_outline_rounded;
    }
  }

  static String getStatusLabel(SosStatus s) {
    switch (s) {
      case SosStatus.received:
        return 'Received';
      case SosStatus.assigned:
        return 'Assigned';
      case SosStatus.enRoute:
        return 'En Route';
      case SosStatus.onScene:
        return 'On Scene';
      case SosStatus.rescueCompleted:
        return 'Completed';
      case SosStatus.closed:
      default:
        return 'Closed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(status);
    final icon = getStatusIcon(status);
    final label = getStatusLabel(status);

    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
