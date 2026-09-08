import 'package:flutter/material.dart';

/// Floating tactical map controls for Zoom (+/-), Reset to Tamil Nadu, and Filter drawer toggle.
class MapControlsWidget extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetTamilNadu;
  final VoidCallback onToggleFilters;
  final bool isFilterActive;

  const MapControlsWidget({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetTamilNadu,
    required this.onToggleFilters,
    this.isFilterActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom In
        _buildControlButton(
          icon: Icons.add_rounded,
          tooltip: 'Zoom In',
          onPressed: onZoomIn,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),

        // Zoom Out
        _buildControlButton(
          icon: Icons.remove_rounded,
          tooltip: 'Zoom Out',
          onPressed: onZoomOut,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),

        // Reset to Tamil Nadu Center
        _buildControlButton(
          icon: Icons.crop_free_rounded,
          tooltip: 'Fit Entire Tamil Nadu',
          onPressed: onResetTamilNadu,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),

        // Filter Toggle Button
        _buildControlButton(
          icon: Icons.layers_rounded,
          tooltip: 'Map Layers & Filters',
          onPressed: onToggleFilters,
          colorScheme: colorScheme,
          isActive: isFilterActive,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
    bool isActive = false,
  }) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: isActive ? colorScheme.primary : colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              size: 22,
              color: isActive ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
