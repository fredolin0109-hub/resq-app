import 'package:flutter/material.dart';
import '../../data/datasources/digital_twin_mock_datasource.dart';
import '../../domain/entities/digital_twin_entities.dart';
import '../providers/digital_twin_provider.dart';
import '../widgets/heatmap_layer_selector_widget.dart';
import '../widgets/digital_twin_empty_view.dart';

/// Screen for exploring 10 Geospatial Disaster Heatmap Layers and coordinate overlays.
class DisasterHeatmapScreen extends StatefulWidget {
  const DisasterHeatmapScreen({super.key});

  @override
  State<DisasterHeatmapScreen> createState() => _DisasterHeatmapScreenState();
}

class _DisasterHeatmapScreenState extends State<DisasterHeatmapScreen> {
  final _notifier = DigitalTwinDependencies.notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final filters = state.heatmapFilters;
        final points = state.filteredHeatmapPoints;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Disaster Heatmap Layers'),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 1. Heatmap Layer Multi-Select Bar
              HeatmapLayerSelectorWidget(
                activeLayers: filters.activeLayers,
                onToggleLayer: (l) => _notifier.toggleHeatmapLayer(l),
                onToggleAll: (all) => _notifier.setAllHeatmapLayers(all),
              ),
              const SizedBox(height: 12),

              // 2. District Filter Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.pin_drop_rounded,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'District Filter:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: filters.district,
                            isDense: true,
                            borderRadius: BorderRadius.circular(12),
                            items: ['All', ...DigitalTwinMockDatasource.tamilNaduDistricts]
                                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                _notifier.setHeatmapDistrict(val);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 3. Spatial Density Status Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${points.length} Spatial Hotspots Visible',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('High', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 8),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.amber.shade600,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Med', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 8),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Low', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 4. Heatmap Points List
              Expanded(
                child: points.isEmpty
                    ? DigitalTwinEmptyView(
                        title: 'No Heatmap Hotspots in Selection',
                        message: 'Try enabling more layer categories or clearing the district filter.',
                        onResetFilters: () {
                          _notifier.setAllHeatmapLayers(true);
                          _notifier.setHeatmapDistrict('All');
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: points.length,
                        itemBuilder: (context, index) {
                          final point = points[index];
                          final layerColor = point.layerType.defaultColor;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: layerColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    point.layerType.icon,
                                    size: 20,
                                    color: layerColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              point.description,
                                              style: theme.textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: layerColor.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              point.layerType.displayName,
                                              style: TextStyle(
                                                color: layerColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'GPS: ${point.latitude.toStringAsFixed(4)}° N, ${point.longitude.toStringAsFixed(4)}° E • Radius: ${point.radiusMeters.toInt()}m',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text(
                                            'Intensity:',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: point.intensity,
                                                backgroundColor:
                                                    colorScheme.surfaceContainerHighest,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  point.intensity > 0.75
                                                      ? Colors.red.shade600
                                                      : (point.intensity > 0.4
                                                          ? Colors.orange.shade600
                                                          : Colors.blue.shade600),
                                                ),
                                                minHeight: 5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${(point.intensity * 100).toInt()}%',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
