import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';

/// Color-coded status badge indicating stock or operational availability.
/// Available = Green (#10B981)
/// Limited = Yellow (#F59E0B)
/// Critical = Orange (#F97316)
/// Out of Stock = Red (#EF4444)
class ResourceStatusBadge extends StatelessWidget {
  final ResourceStatus status;
  final bool isCompact;

  const ResourceStatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    final label = status.displayName;

    return Semantics(
      label: 'Resource Status: $label',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 6 : 9,
          vertical: isCompact ? 2 : 4,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isCompact ? 5 : 6,
              height: isCompact ? 5 : 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: isCompact ? 4 : 6),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: isCompact ? 9 : 11,
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
