import 'package:flutter/material.dart';
import '../../domain/entities/digital_twin_entities.dart';

/// Interactive Layer Selector bar for 10 geospatial disaster heatmap overlays.
class HeatmapLayerSelectorWidget extends StatelessWidget {
  final Set<HeatmapLayerType> activeLayers;
  final ValueChanged<HeatmapLayerType> onToggleLayer;
  final ValueChanged<bool> onToggleAll;

  const HeatmapLayerSelectorWidget({
    super.key,
    required this.activeLayers,
    required this.onToggleLayer,
    required this.onToggleAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final allSelected = activeLayers.length == HeatmapLayerType.values.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.layers_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Spatial Heatmap Layers',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${activeLayers.length} Active',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => onToggleAll(!allSelected),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(allSelected ? 'Reset Layers' : 'Select All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: HeatmapLayerType.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final layer = HeatmapLayerType.values[index];
              final isSelected = activeLayers.contains(layer);
              final layerColor = layer.defaultColor;

              return FilterChip(
                showCheckmark: false,
                selected: isSelected,
                avatar: Icon(
                  layer.icon,
                  size: 16,
                  color: isSelected ? Colors.white : layerColor,
                ),
                label: Text(
                  layer.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                  ),
                ),
                selectedColor: layerColor,
                backgroundColor: colorScheme.surfaceContainer,
                side: BorderSide(
                  color: isSelected
                      ? layerColor
                      : colorScheme.outlineVariant.withValues(alpha: 0.6),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (_) => onToggleLayer(layer),
              );
            },
          ),
        ),
      ],
    );
  }
}
