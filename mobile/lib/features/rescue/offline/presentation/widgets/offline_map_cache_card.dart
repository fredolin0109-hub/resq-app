import 'package:flutter/material.dart';
import '../../domain/entities/offline_entities.dart';

/// Card showing cached map intelligence for a district.
class OfflineMapCacheCard extends StatelessWidget {
  final CachedMapData cache;
  final VoidCallback? onViewOnMap;

  const OfflineMapCacheCard({
    super.key,
    required this.cache,
    this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // District Name & Cache Size
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.map_rounded, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${cache.district} District Cache',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${(cache.cacheSizeKb / 1024.0).toStringAsFixed(1)} MB',
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Counts Row (Risk zones, Shelters, Hospitals, Teams)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _CacheChip(
                icon: Icons.warning_amber_rounded,
                label: '${cache.cachedRiskZonesCount} Risk Hotspots',
                color: Colors.orange.shade700,
              ),
              _CacheChip(
                icon: Icons.night_shelter_rounded,
                label: '${cache.cachedSheltersCount} Shelters',
                color: Colors.purple.shade600,
              ),
              _CacheChip(
                icon: Icons.local_hospital_rounded,
                label: '${cache.cachedHospitalsCount} Hospitals',
                color: Colors.teal.shade600,
              ),
              _CacheChip(
                icon: Icons.groups_rounded,
                label: '${cache.cachedTeamsCount} Teams',
                color: Colors.blue.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CacheChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CacheChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
