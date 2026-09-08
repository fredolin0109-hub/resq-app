import 'package:flutter/material.dart';
import '../../domain/entities/digital_twin_entities.dart';
import '../providers/digital_twin_provider.dart';
import '../widgets/simulation_control_panel.dart';

/// Full interactive disaster simulation sandbox for predictive evacuation planning.
class SimulationPanelScreen extends StatefulWidget {
  const SimulationPanelScreen({super.key});

  @override
  State<SimulationPanelScreen> createState() => _SimulationPanelScreenState();
}

class _SimulationPanelScreenState extends State<SimulationPanelScreen> {
  final _notifier = DigitalTwinDependencies.notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final simulation = state.activeSimulation;

        if (simulation == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Disaster Simulation Lab')),
            body: const Center(child: Text('No active simulation scenario.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Disaster Simulation Lab'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. Interactive Control Panel & Scrub Slider
              SimulationControlPanel(
                simulation: simulation,
                onTogglePlay: () => _notifier.togglePlaySimulation(),
                onScrubProgress: (p) => _notifier.scrubSimulation(p),
                onSpeedChanged: (s) => _notifier.setSimulationSpeed(s),
                onReset: () => _notifier.resetSimulation(),
                onSelectSimulationType: (t) => _notifier.selectSimulation(t),
              ),
              const SizedBox(height: 16),

              // 2. Simulated Visual Hazard Spatial Canvas Preview
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Stack(
                  children: [
                    // Simulated Grid lines
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _SimulationGridPainter(
                          progress: simulation.progress,
                          simColor: simulation.type.icon == Icons.flood_rounded
                              ? Colors.blue
                              : (simulation.type.icon == Icons.local_fire_department_rounded
                                  ? Colors.red
                                  : Colors.orange),
                        ),
                      ),
                    ),

                    // Top Status Overlay
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              simulation.isPlaying ? Icons.play_arrow_rounded : Icons.pause_rounded,
                              size: 14,
                              color: simulation.isPlaying ? Colors.greenAccent : Colors.amberAccent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${simulation.type.displayName.toUpperCase()} • ${(simulation.progress * 100).toInt()}% INUNDATION',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Center Dynamic Hotspot Node
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60 + (simulation.progress * 50),
                            height: 60 + (simulation.progress * 50),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withValues(alpha: 0.2 + (simulation.progress * 0.3)),
                              border: Border.all(
                                color: Colors.redAccent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                simulation.type.icon,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Epicenter: ${simulation.district}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Detailed Scenario Telemetry Breakdown
              Container(
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
                    Text(
                      'Scenario Operational Intelligence',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _TelemetryRow(
                      label: 'Target District & Sector',
                      value: '${simulation.district} Emergency Sector',
                    ),
                    _TelemetryRow(
                      label: 'Simulation Elapsed Speed',
                      value: '${simulation.speedMultiplier.toInt()}x Realtime Factor',
                    ),
                    _TelemetryRow(
                      label: 'Predicted Casualties Averted',
                      value: '${simulation.simulatedCasualtiesPrevented} Civilians',
                      isHighlight: true,
                    ),
                    _TelemetryRow(
                      label: 'Estimated Evacuees Guided',
                      value: '${simulation.estimatedEvacuated} People',
                    ),
                    _TelemetryRow(
                      label: 'Hydraulic / Wind Field State',
                      value: simulation.statusDescription,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TelemetryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _TelemetryRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isHighlight ? Colors.green.shade700 : null,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _SimulationGridPainter extends CustomPainter {
  final double progress;
  final Color simColor;

  _SimulationGridPainter({
    required this.progress,
    required this.simColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    const step = 25.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final wavePaint = Paint()
      ..color = simColor.withValues(alpha: 0.15 + (progress * 0.2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 40 * progress + 20, wavePaint);
    canvas.drawCircle(center, 80 * progress + 40, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _SimulationGridPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.simColor != simColor;
  }
}
