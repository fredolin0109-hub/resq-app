import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/datasources/digital_twin_mock_datasource.dart';
import '../../data/repositories/digital_twin_repository_impl.dart';
import '../../domain/entities/digital_twin_entities.dart';
import '../../domain/repositories/digital_twin_repository.dart';
import '../../domain/usecases/digital_twin_usecases.dart';
import 'digital_twin_state.dart';

/// Central state notifier orchestrating real-time telemetry, spatial heatmap layers,
/// infrastructure health monitoring, AI predictions, and disaster simulations.
class DigitalTwinNotifier extends ChangeNotifier {
  final GetDigitalTwinSummaryUseCase _getSummaryUseCase;
  final GetLiveAnalyticsUseCase _getAnalyticsUseCase;
  final GetHeatmapPointsUseCase _getHeatmapPointsUseCase;
  final GetTimelineEventsUseCase _getTimelineEventsUseCase;
  final GetInfrastructureAssetsUseCase _getInfrastructureUseCase;
  final GetDigitalTwinPredictionsUseCase _getPredictionsUseCase;
  final ManageDisasterSimulationUseCase _manageSimulationUseCase;

  DigitalTwinState _state = DigitalTwinState.initial();
  Timer? _simulationTimer;

  DigitalTwinNotifier({
    required GetDigitalTwinSummaryUseCase getSummaryUseCase,
    required GetLiveAnalyticsUseCase getAnalyticsUseCase,
    required GetHeatmapPointsUseCase getHeatmapPointsUseCase,
    required GetTimelineEventsUseCase getTimelineEventsUseCase,
    required GetInfrastructureAssetsUseCase getInfrastructureUseCase,
    required GetDigitalTwinPredictionsUseCase getPredictionsUseCase,
    required ManageDisasterSimulationUseCase manageSimulationUseCase,
  })  : _getSummaryUseCase = getSummaryUseCase,
        _getAnalyticsUseCase = getAnalyticsUseCase,
        _getHeatmapPointsUseCase = getHeatmapPointsUseCase,
        _getTimelineEventsUseCase = getTimelineEventsUseCase,
        _getInfrastructureUseCase = getInfrastructureUseCase,
        _getPredictionsUseCase = getPredictionsUseCase,
        _manageSimulationUseCase = manageSimulationUseCase;

  DigitalTwinState get state => _state;

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  /// Initial load of all Digital Twin telemetry, entities, and simulations.
  Future<void> loadDashboard() async {
    _state = _state.copyWith(status: DigitalTwinViewStatus.loading);
    notifyListeners();

    try {
      final summary = await _getSummaryUseCase();
      final analytics = await _getAnalyticsUseCase();
      final heatmapPoints = await _getHeatmapPointsUseCase();
      final timelineEvents = await _getTimelineEventsUseCase();
      final infrastructureAssets = await _getInfrastructureUseCase();
      final predictions = await _getPredictionsUseCase();
      final simulations = await _manageSimulationUseCase.getSimulations();

      final filteredHeatmaps = _applyHeatmapFilters(heatmapPoints, _state.heatmapFilters);
      final filteredTimeline = _applyTimelineFilters(timelineEvents, _state.timelineFilters);
      final filteredInfra = _applyInfrastructureFilters(infrastructureAssets, _state.infrastructureFilters);
      final filteredPreds = _applyPredictionFilters(predictions, _state.predictionFilters);

      final activeSim = simulations.isNotEmpty ? simulations.first : null;

      _state = _state.copyWith(
        status: DigitalTwinViewStatus.loaded,
        summary: summary,
        liveAnalytics: analytics,
        allHeatmapPoints: heatmapPoints,
        allTimelineEvents: timelineEvents,
        allInfrastructureAssets: infrastructureAssets,
        allPredictions: predictions,
        allSimulations: simulations,
        filteredHeatmapPoints: filteredHeatmaps,
        filteredTimelineEvents: filteredTimeline,
        filteredInfrastructureAssets: filteredInfra,
        filteredPredictions: filteredPreds,
        activeSimulation: activeSim,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: DigitalTwinViewStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
    }
  }

  /// Refresh telemetry and datasets.
  Future<void> refresh() async {
    await loadDashboard();
  }

  // ===========================================================================
  // HEATMAP LAYER HANDLERS
  // ===========================================================================

  void toggleHeatmapLayer(HeatmapLayerType layer) {
    final updatedLayers = Set<HeatmapLayerType>.from(_state.heatmapFilters.activeLayers);
    if (updatedLayers.contains(layer)) {
      if (updatedLayers.length > 1) {
        updatedLayers.remove(layer);
      }
    } else {
      updatedLayers.add(layer);
    }
    final newFilters = _state.heatmapFilters.copyWith(activeLayers: updatedLayers);
    _state = _state.copyWith(
      heatmapFilters: newFilters,
      filteredHeatmapPoints: _applyHeatmapFilters(_state.allHeatmapPoints, newFilters),
    );
    notifyListeners();
  }

  void setAllHeatmapLayers(bool enableAll) {
    final updatedLayers = enableAll
        ? HeatmapLayerType.values.toSet()
        : {HeatmapLayerType.flood, HeatmapLayerType.riskDensity};
    final newFilters = _state.heatmapFilters.copyWith(activeLayers: updatedLayers);
    _state = _state.copyWith(
      heatmapFilters: newFilters,
      filteredHeatmapPoints: _applyHeatmapFilters(_state.allHeatmapPoints, newFilters),
    );
    notifyListeners();
  }

  void setHeatmapDistrict(String district) {
    final newFilters = _state.heatmapFilters.copyWith(district: district);
    _state = _state.copyWith(
      heatmapFilters: newFilters,
      filteredHeatmapPoints: _applyHeatmapFilters(_state.allHeatmapPoints, newFilters),
    );
    notifyListeners();
  }

  // ===========================================================================
  // TIMELINE HANDLERS
  // ===========================================================================

  void updateTimelineFilters(TimelineFilterOptions options) {
    _state = _state.copyWith(
      timelineFilters: options,
      filteredTimelineEvents: _applyTimelineFilters(_state.allTimelineEvents, options),
    );
    notifyListeners();
  }

  void searchTimeline(String query) {
    final opts = _state.timelineFilters.copyWith(searchQuery: query);
    updateTimelineFilters(opts);
  }

  void setTimelineDistrict(String district) {
    final opts = _state.timelineFilters.copyWith(district: district);
    updateTimelineFilters(opts);
  }

  void setTimelineType(TimelineEventType? type) {
    final opts = _state.timelineFilters.copyWith(
      eventType: type,
      clearType: type == null,
    );
    updateTimelineFilters(opts);
  }

  void selectTimelineEvent(TimelineEvent? event) {
    _state = _state.copyWith(
      selectedTimelineEvent: event,
      clearSelectedEvent: event == null,
    );
    notifyListeners();
  }

  // ===========================================================================
  // INFRASTRUCTURE HANDLERS
  // ===========================================================================

  void updateInfrastructureFilters(InfrastructureFilterOptions options) {
    _state = _state.copyWith(
      infrastructureFilters: options,
      filteredInfrastructureAssets: _applyInfrastructureFilters(_state.allInfrastructureAssets, options),
    );
    notifyListeners();
  }

  void searchInfrastructure(String query) {
    final opts = _state.infrastructureFilters.copyWith(searchQuery: query);
    updateInfrastructureFilters(opts);
  }

  void setInfrastructureDistrict(String district) {
    final opts = _state.infrastructureFilters.copyWith(district: district);
    updateInfrastructureFilters(opts);
  }

  void setInfrastructureType(InfrastructureType? type) {
    final opts = _state.infrastructureFilters.copyWith(
      type: type,
      clearType: type == null,
    );
    updateInfrastructureFilters(opts);
  }

  void setInfrastructureStatus(InfrastructureStatus? status) {
    final opts = _state.infrastructureFilters.copyWith(
      status: status,
      clearStatus: status == null,
    );
    updateInfrastructureFilters(opts);
  }

  void selectAsset(InfrastructureAsset? asset) {
    _state = _state.copyWith(
      selectedAsset: asset,
      clearSelectedAsset: asset == null,
    );
    notifyListeners();
  }

  // ===========================================================================
  // AI PREDICTIONS HANDLERS
  // ===========================================================================

  void updatePredictionFilters(PredictionFilterOptions options) {
    _state = _state.copyWith(
      predictionFilters: options,
      filteredPredictions: _applyPredictionFilters(_state.allPredictions, options),
    );
    notifyListeners();
  }

  void searchPredictions(String query) {
    final opts = _state.predictionFilters.copyWith(searchQuery: query);
    updatePredictionFilters(opts);
  }

  void setPredictionDistrict(String district) {
    final opts = _state.predictionFilters.copyWith(district: district);
    updatePredictionFilters(opts);
  }

  void setPredictionType(PredictionType? type) {
    final opts = _state.predictionFilters.copyWith(
      type: type,
      clearType: type == null,
    );
    updatePredictionFilters(opts);
  }

  void selectPrediction(DigitalTwinPrediction? prediction) {
    _state = _state.copyWith(
      selectedPrediction: prediction,
      clearSelectedPrediction: prediction == null,
    );
    notifyListeners();
  }

  // ===========================================================================
  // DISASTER SIMULATION HANDLERS
  // ===========================================================================

  void selectSimulation(SimulationType type) {
    final match = _state.allSimulations.firstWhere(
      (s) => s.type == type,
      orElse: () => _state.allSimulations.first,
    );
    _state = _state.copyWith(activeSimulation: match);
    notifyListeners();
  }

  void togglePlaySimulation() {
    final current = _state.activeSimulation;
    if (current == null) return;

    final isPlaying = !current.isPlaying;
    final updated = current.copyWith(isPlaying: isPlaying);
    _state = _state.copyWith(activeSimulation: updated);
    notifyListeners();

    if (isPlaying) {
      _startSimulationLoop();
    } else {
      _stopSimulationLoop();
    }
  }

  void setSimulationSpeed(double speed) {
    final current = _state.activeSimulation;
    if (current == null) return;

    final updated = current.copyWith(speedMultiplier: speed);
    _state = _state.copyWith(activeSimulation: updated);
    notifyListeners();
  }

  void scrubSimulation(double progress) {
    final current = _state.activeSimulation;
    if (current == null) return;

    final updated = current.copyWith(
      progress: progress.clamp(0.0, 1.0),
    );
    _state = _state.copyWith(activeSimulation: updated);
    notifyListeners();
  }

  void resetSimulation() {
    final current = _state.activeSimulation;
    if (current == null) return;

    _stopSimulationLoop();
    final updated = current.copyWith(
      progress: 0.0,
      isPlaying: false,
    );
    _state = _state.copyWith(activeSimulation: updated);
    notifyListeners();
  }

  void _startSimulationLoop() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final sim = _state.activeSimulation;
      if (sim == null || !sim.isPlaying) {
        timer.cancel();
        return;
      }

      final step = 0.01 * sim.speedMultiplier;
      final nextProgress = sim.progress + step;

      if (nextProgress >= 1.0) {
        _state = _state.copyWith(
          activeSimulation: sim.copyWith(
            progress: 1.0,
            isPlaying: false,
          ),
        );
        timer.cancel();
        notifyListeners();
      } else {
        _state = _state.copyWith(
          activeSimulation: sim.copyWith(progress: nextProgress),
        );
        notifyListeners();
      }
    });
  }

  void _stopSimulationLoop() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  // ===========================================================================
  // PRIVATE FILTER UTILITIES
  // ===========================================================================

  List<HeatmapPoint> _applyHeatmapFilters(
    List<HeatmapPoint> points,
    HeatmapFilterOptions opts,
  ) {
    return points.where((p) {
      if (opts.activeLayers.isNotEmpty && !opts.activeLayers.contains(p.layerType)) {
        return false;
      }
      if (opts.district != 'All' &&
          p.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  List<TimelineEvent> _applyTimelineFilters(
    List<TimelineEvent> events,
    TimelineFilterOptions opts,
  ) {
    return events.where((e) {
      if (opts.district != 'All' &&
          e.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      if (opts.eventType != null && e.eventType != opts.eventType) {
        return false;
      }
      if (opts.incidentId != null &&
          opts.incidentId!.isNotEmpty &&
          e.incidentId != opts.incidentId) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = e.title.toLowerCase().contains(q) ||
            e.description.toLowerCase().contains(q) ||
            e.district.toLowerCase().contains(q) ||
            e.loggedBy.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<InfrastructureAsset> _applyInfrastructureFilters(
    List<InfrastructureAsset> assets,
    InfrastructureFilterOptions opts,
  ) {
    return assets.where((a) {
      if (opts.district != 'All' &&
          a.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      if (opts.type != null && a.type != opts.type) {
        return false;
      }
      if (opts.status != null && a.status != opts.status) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = a.name.toLowerCase().contains(q) ||
            a.district.toLowerCase().contains(q) ||
            a.locationAddress.toLowerCase().contains(q) ||
            a.telemetryNotes.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<DigitalTwinPrediction> _applyPredictionFilters(
    List<DigitalTwinPrediction> preds,
    PredictionFilterOptions opts,
  ) {
    return preds.where((p) {
      if (opts.district != 'All' &&
          p.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      if (opts.type != null && p.type != opts.type) {
        return false;
      }
      if (p.riskScore < opts.minRiskScore) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = p.title.toLowerCase().contains(q) ||
            p.district.toLowerCase().contains(q) ||
            p.affectedZone.toLowerCase().contains(q) ||
            p.projectedOutcome.toLowerCase().contains(q) ||
            p.preventiveAction.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }
}

/// Global dependency injection container for Digital Twin module.
class DigitalTwinDependencies {
  static final DigitalTwinMockDatasource datasource = DigitalTwinMockDatasource();
  static final DigitalTwinRepository repository = DigitalTwinRepositoryImpl(datasource);

  static final GetDigitalTwinSummaryUseCase getSummaryUseCase =
      GetDigitalTwinSummaryUseCase(repository);
  static final GetLiveAnalyticsUseCase getAnalyticsUseCase =
      GetLiveAnalyticsUseCase(repository);
  static final GetHeatmapPointsUseCase getHeatmapPointsUseCase =
      GetHeatmapPointsUseCase(repository);
  static final GetTimelineEventsUseCase getTimelineEventsUseCase =
      GetTimelineEventsUseCase(repository);
  static final GetInfrastructureAssetsUseCase getInfrastructureUseCase =
      GetInfrastructureAssetsUseCase(repository);
  static final GetDigitalTwinPredictionsUseCase getPredictionsUseCase =
      GetDigitalTwinPredictionsUseCase(repository);
  static final ManageDisasterSimulationUseCase manageSimulationUseCase =
      ManageDisasterSimulationUseCase(repository);

  static final DigitalTwinNotifier notifier = DigitalTwinNotifier(
    getSummaryUseCase: getSummaryUseCase,
    getAnalyticsUseCase: getAnalyticsUseCase,
    getHeatmapPointsUseCase: getHeatmapPointsUseCase,
    getTimelineEventsUseCase: getTimelineEventsUseCase,
    getInfrastructureUseCase: getInfrastructureUseCase,
    getPredictionsUseCase: getPredictionsUseCase,
    manageSimulationUseCase: manageSimulationUseCase,
  );
}
