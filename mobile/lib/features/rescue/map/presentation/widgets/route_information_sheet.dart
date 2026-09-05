import 'package:flutter/material.dart';
import '../../domain/entities/city_risk_entity.dart';

/// Tactical route planning preview and dispatch trigger sheet.
class RouteInformationSheet extends StatelessWidget {
  final CityRiskEntity destinationCity;
  final VoidCallback onStartDispatch;
  final VoidCallback onClose;

  const RouteInformationSheet({
    super.key,
    required this.destinationCity,
    required this.onStartDispatch,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Tactical route information to ${destinationCity.name}',
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_car_filled_rounded, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Tactical Route Overview',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Route Points
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildRouteNode(
                    icon: Icons.my_location_rounded,
                    color: Colors.blue,
                    label: 'Origin',
                    value: 'District Command HQ (Central)',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(height: 12),
                  ),
                  _buildRouteNode(
                    icon: Icons.location_on_rounded,
                    color: Colors.red,
                    label: 'Destination',
                    value: '${destinationCity.name}, ${destinationCity.district}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Telemetry Estimates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEstimateTile(context, 'Distance', '128 km', Icons.straighten_rounded),
                _buildEstimateTile(context, 'Est. Time', '1h 45m', Icons.timer_rounded),
                _buildEstimateTile(context, 'Hazard Check', 'Clear Corridor', Icons.verified_rounded),
              ],
            ),
            const SizedBox(height: 20),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: onStartDispatch,
                icon: const Icon(Icons.send_rounded),
                label: Text('Confirm Dispatch to ${destinationCity.name}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteNode({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEstimateTile(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
