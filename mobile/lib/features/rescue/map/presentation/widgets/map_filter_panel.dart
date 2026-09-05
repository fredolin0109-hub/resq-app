import 'package:flutter/material.dart';
import '../../domain/entities/city_risk_entity.dart';

/// Interactive drawer/panel for toggling tactical map layers and filters.
class MapFilterPanel extends StatelessWidget {
  final MapFilterOptions options;
  final ValueChanged<MapFilterOptions> onFiltersChanged;
  final VoidCallback onClose;

  const MapFilterPanel({
    super.key,
    required this.options,
    required this.onFiltersChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Map Filters Panel',
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(-4, 0),
            ),
          ],
          border: Border(
            left: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tune_rounded, color: colorScheme.primary, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Map Layer Filters',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Close Filters',
                      onPressed: onClose,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Filter Toggles List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  children: [
                    _buildSectionHeader('RESOURCE LAYERS'),
                    _buildFilterTile(
                      icon: Icons.local_hospital_rounded,
                      iconColor: Colors.red,
                      title: 'Show Hospitals',
                      value: options.showHospitals,
                      onChanged: (val) => onFiltersChanged(options.copyWith(showHospitals: val)),
                    ),
                    _buildFilterTile(
                      icon: Icons.night_shelter_rounded,
                      iconColor: Colors.teal,
                      title: 'Show Shelters',
                      value: options.showShelters,
                      onChanged: (val) => onFiltersChanged(options.copyWith(showShelters: val)),
                    ),
                    _buildFilterTile(
                      icon: Icons.groups_rounded,
                      iconColor: Colors.blueAccent,
                      title: 'Show Rescue Teams',
                      value: options.showRescueTeams,
                      onChanged: (val) => onFiltersChanged(options.copyWith(showRescueTeams: val)),
                    ),
                    const SizedBox(height: 12),

                    _buildSectionHeader('DISASTER & HAZARD OVERLAYS'),
                    _buildFilterTile(
                      icon: Icons.water_damage_rounded,
                      iconColor: Colors.blue.shade700,
                      title: 'Show Flood Layer',
                      value: options.showFloodLayer,
                      onChanged: (val) => onFiltersChanged(options.copyWith(showFloodLayer: val)),
                    ),
                    _buildFilterTile(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: Colors.deepOrange,
                      title: 'Show Fire Layer',
                      value: options.showFireLayer,
                      onChanged: (val) => onFiltersChanged(options.copyWith(showFireLayer: val)),
                    ),
                    _buildFilterTile(
                      icon: Icons.terrain_rounded,
                      iconColor: Colors.brown,
                      title: 'Show Landslide Layer',
                      value: options.showLandslideLayer,
                      onChanged: (val) => onFiltersChanged(options.copyWith(showLandslideLayer: val)),
                    ),
                    const SizedBox(height: 12),

                    _buildSectionHeader('TELEMETRY & CORRIDORS'),
                    _buildFilterTile(
                      icon: Icons.traffic_rounded,
                      iconColor: Colors.amber.shade800,
                      title: 'Show Traffic & Access',
                      value: options.showTraffic,
                      onChanged: (val) => onFiltersChanged(options.copyWith(showTraffic: val)),
                    ),
                    _buildFilterTile(
                      icon: Icons.radar_rounded,
                      iconColor: colorScheme.primary,
                      title: 'Show Risk Circles',
                      value: options.showRiskCircles,
                      onChanged: (val) => onFiltersChanged(options.copyWith(showRiskCircles: val)),
                    ),
                  ],
                ),
              ),

              // Footer Reset
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => onFiltersChanged(const MapFilterOptions()),
                    icon: const Icon(Icons.restart_alt_rounded, size: 18),
                    label: const Text('Reset to Defaults'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFilterTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      dense: true,
      secondary: Icon(icon, color: iconColor, size: 20),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
