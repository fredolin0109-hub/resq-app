import 'package:flutter/material.dart';
import '../../domain/entities/sos_incident_entity.dart';

/// Distinctive priority indicator (Critical = Red, High = Orange, Medium = Yellow, Low = Green).
class SosPriorityBadge extends StatelessWidget {
  final SosPriority priority;

  const SosPriorityBadge({
    super.key,
    required this.priority,
  });

  static Color getPriorityColor(SosPriority p) {
    switch (p) {
      case SosPriority.critical:
        return Colors.red.shade700;
      case SosPriority.high:
        return Colors.orange.shade800;
      case SosPriority.medium:
        return Colors.amber.shade800;
      case SosPriority.low:
      default:
        return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getPriorityColor(priority);

    return Semantics(
      label: 'Priority: ${priority.name}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color.withValues(alpha: 0.5),
            width: 1,
          ),
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
              priority.name.toUpperCase(),
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
