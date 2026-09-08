import 'package:flutter/material.dart';
import '../../domain/entities/digital_twin_entities.dart';

/// Control panel for Interactive Disaster Simulation.
class SimulationControlPanel extends StatelessWidget {
  final DisasterSimulation simulation;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onScrubProgress;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onReset;
  final ValueChanged<SimulationType> onSelectSimulationType;

  const SimulationControlPanel({
    super.key,
    required this.simulation,
    required this.onTogglePlay,
    required this.onScrubProgress,
    required this.onSpeedChanged,
    required this.onReset,
    required this.onSelectSimulationType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scenario Type Selector Bar
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: SimulationType.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final type = SimulationType.values[index];
                final isSelected = simulation.type == type;

                return ChoiceChip(
                  avatar: Icon(
                    type.icon,
                    size: 14,
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                  ),
                  label: Text(
                    type.displayName.replaceAll(' Simulation', ''),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: colorScheme.primary,
                  onSelected: (_) => onSelectSimulationType(type),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Simulation Scenario Title & District
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      simulation.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Target Zone: ${simulation.district} • ${simulation.statusDescription}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Simulation Scrub Slider & Timestamp
          Row(
            children: [
              Text(
                'T-00:00',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: Slider(
                  value: simulation.progress,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  activeColor: colorScheme.primary,
                  onChanged: onScrubProgress,
                ),
              ),
              Text(
                'T+${(simulation.progress * 6).toStringAsFixed(1)}h',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),

          // Playback Buttons & Speed Selector
          Row(
            children: [
              IconButton.filled(
                onPressed: onTogglePlay,
                icon: Icon(
                  simulation.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 22,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                onPressed: onReset,
                icon: const Icon(Icons.replay_rounded, size: 20),
                tooltip: 'Reset Simulation',
              ),
              const Spacer(),

              // Speed Chips
              for (final speed in [1.0, 2.0, 5.0, 10.0]) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: InkWell(
                    onTap: () => onSpeedChanged(speed),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: simulation.speedMultiplier == speed
                            ? colorScheme.secondaryContainer
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: simulation.speedMultiplier == speed
                              ? colorScheme.secondary
                              : colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        '${speed.toInt()}x',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: simulation.speedMultiplier == speed
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Casualty & Evacuation Impact Metric Pills
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.health_and_safety_rounded,
                        size: 16,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${simulation.simulatedCasualtiesPrevented}',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const Text(
                              'Casualties Averted',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_walk_rounded,
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${simulation.estimatedEvacuated}',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const Text(
                              'Evacuees Guided',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
