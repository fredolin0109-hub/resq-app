import 'package:flutter/material.dart';
import '../../domain/entities/city_risk_entity.dart';
import '../providers/rescue_map_provider.dart';
import '../providers/rescue_map_state.dart';
import '../widgets/city_search_widget.dart';
import '../widgets/district_boundary_layer.dart';
import '../widgets/location_information_panel.dart';
import '../widgets/map_controls_widget.dart';
import '../widgets/map_filter_panel.dart';
import '../widgets/risk_circle_layer.dart';
import '../widgets/risk_legend_widget.dart';
import '../widgets/route_information_sheet.dart';

/// Production-ready Rescue Mission Command Map for Tamil Nadu.
class RescueMapScreen extends StatefulWidget {
  final RescueMapNotifier? notifier;

  const RescueMapScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/map';

  @override
  State<RescueMapScreen> createState() => _RescueMapScreenState();
}

class _RescueMapScreenState extends State<RescueMapScreen> {
  late final RescueMapNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? RescueMapDependencies.notifier;
    _notifier.addListener(_onStateChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_notifier.state.status == RescueMapStatus.initial) {
        _notifier.loadMapData();
      }
    });
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _handleNavigateRoute(CityRiskEntity city) {
    _notifier.toggleRouteSheet(true);
  }

  void _handleAssignTeam(CityRiskEntity city) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rescue Squad deployed to ${city.name} (${city.district} District)'),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = _notifier.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tamil Nadu Mission Command Map',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        backgroundColor: colorScheme.surface,
        actions: [
          // Show All (Reset Tamil Nadu)
          Semantics(
            button: true,
            label: 'Show entire Tamil Nadu',
            child: TextButton.icon(
              onPressed: () => _notifier.resetToTamilNadu(),
              icon: const Icon(Icons.public_rounded, size: 18),
              label: const Text('Show All'),
            ),
          ),
          // Filter Toggle
          Semantics(
            button: true,
            label: 'Toggle Map Filters',
            child: IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              tooltip: 'Filter Layers',
              onPressed: () => _notifier.toggleFilterPanel(),
            ),
          ),
          // Refresh
          Semantics(
            button: true,
            label: 'Refresh Map Telemetry',
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh Telemetry',
              onPressed: () => _notifier.loadMapData(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _buildMapCanvas(context, state),
      ),
    );
  }

  Widget _buildMapCanvas(BuildContext context, RescueMapState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading Tamil Nadu Tactical Map Telemetry...'),
          ],
        ),
      );
    }

    if (state.isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(state.errorMessage ?? 'Failed to load map data'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _notifier.loadMapData(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      );
    }

    if (state.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 54, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('No data available'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _notifier.loadMapData(),
              child: const Text('Reload Map'),
            ),
          ],
        ),
      );
    }

    final isWide = MediaQuery.of(context).size.width >= 800;

    return Stack(
      children: [
        // 1. Tactical Map Background (Simulated Map Canvas with Pan / Zoom Gesture Detectors)
        Positioned.fill(
          child: Container(
            color: const Color(0xFF18222D), // Deep Navy Tactical Map Tone
            child: GestureDetector(
              onDoubleTap: () => _notifier.zoomIn(),
              onScaleUpdate: (details) {
                if (details.scale > 1.05) _notifier.zoomIn();
                if (details.scale < 0.95) _notifier.zoomOut();
              },
              child: Stack(
                children: [
                  // District Boundaries & Grid Overlays
                  DistrictBoundaryLayer(
                    showTraffic: state.filterOptions.showTraffic,
                    showFloodLayer: state.filterOptions.showFloodLayer,
                  ),

                  // Risk Circles Layer (Green, Yellow, Red)
                  RiskCircleLayer(
                    cities: state.filteredCities,
                    selectedCity: state.selectedCity,
                    showRiskCircles: state.filterOptions.showRiskCircles,
                    onCityTapped: (city) => _notifier.selectCity(city),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 2. Top City Search Autocomplete Box
        Positioned(
          top: 14,
          left: 14,
          right: isWide ? 420 : 14,
          child: CitySearchWidget(
            cities: state.allCities,
            onCitySelected: (city) => _notifier.selectCity(city),
            onClear: () => _notifier.resetToTamilNadu(),
          ),
        ),

        // 3. Floating Risk Legend
        const Positioned(
          bottom: 24,
          left: 16,
          child: RiskLegendWidget(),
        ),

        // 4. Map Control Buttons (Zoom, Fit All, Layers)
        Positioned(
          right: isWide && (state.isInfoPanelOpen || state.isFilterPanelOpen) ? 390 : 16,
          bottom: 24,
          child: MapControlsWidget(
            onZoomIn: () => _notifier.zoomIn(),
            onZoomOut: () => _notifier.zoomOut(),
            onResetTamilNadu: () => _notifier.resetToTamilNadu(),
            onToggleFilters: () => _notifier.toggleFilterPanel(),
            isFilterActive: state.isFilterPanelOpen,
          ),
        ),

        // 5. Filter Panel Drawer (Slide in from Right)
        if (state.isFilterPanelOpen)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: MapFilterPanel(
              options: state.filterOptions,
              onFiltersChanged: (newOpts) => _notifier.updateFilters(newOpts),
              onClose: () => _notifier.toggleFilterPanel(),
            ),
          ),

        // 6. Location Information Side Panel / Bottom Sheet
        if (state.selectedCity != null && state.isInfoPanelOpen)
          isWide
              ? Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: LocationInformationPanel(
                    city: state.selectedCity!,
                    onClose: () => _notifier.deselectCity(),
                    onNavigateRoute: () => _handleNavigateRoute(state.selectedCity!),
                    onAssignTeam: () => _handleAssignTeam(state.selectedCity!),
                  ),
                )
              : Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LocationInformationPanel(
                    city: state.selectedCity!,
                    onClose: () => _notifier.deselectCity(),
                    onNavigateRoute: () => _handleNavigateRoute(state.selectedCity!),
                    onAssignTeam: () => _handleAssignTeam(state.selectedCity!),
                  ),
                ),

        // 7. Route Information Sheet (When Navigate is tapped)
        if (state.selectedCity != null && state.isRouteSheetOpen)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: RouteInformationSheet(
              destinationCity: state.selectedCity!,
              onClose: () => _notifier.toggleRouteSheet(false),
              onStartDispatch: () {
                _notifier.toggleRouteSheet(false);
                _handleAssignTeam(state.selectedCity!);
              },
            ),
          ),
      ],
    );
  }
}
