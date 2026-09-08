import '../../domain/entities/digital_twin_entities.dart';

enum DigitalTwinViewStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// Filter options for spatial heatmap layers and district.
class HeatmapFilterOptions {
  final Set<HeatmapLayerType> activeLayers;
  final String district;

  const HeatmapFilterOptions({
    this.activeLayers = const {
      HeatmapLayerType.flood,
      HeatmapLayerType.fire,
      HeatmapLayerType.cyclone,
      HeatmapLayerType.infrastructure,
      HeatmapLayerType.riskDensity,
    },
    this.district = 'All',
  });

  bool get isAllLayersSelected =>
      activeLayers.length == HeatmapLayerType.values.length;

  HeatmapFilterOptions copyWith({
    Set<HeatmapLayerType>? activeLayers,
    String? district,
  }) {
    return HeatmapFilterOptions(
      activeLayers: activeLayers ?? this.activeLayers,
      district: district ?? this.district,
    );
  }
}

/// Filter options for chronological disaster timeline stream.
class TimelineFilterOptions {
  final String district;
  final TimelineEventType? eventType;
  final String? incidentId;
  final String searchQuery;

  const TimelineFilterOptions({
    this.district = 'All',
    this.eventType,
    this.incidentId,
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      district != 'All' ||
      eventType != null ||
      (incidentId != null && incidentId!.isNotEmpty) ||
      searchQuery.isNotEmpty;

  TimelineFilterOptions copyWith({
    String? district,
    TimelineEventType? eventType,
    String? incidentId,
    String? searchQuery,
    bool clearType = false,
    bool clearIncident = false,
  }) {
    return TimelineFilterOptions(
      district: district ?? this.district,
      eventType: clearType ? null : (eventType ?? this.eventType),
      incidentId: clearIncident ? null : (incidentId ?? this.incidentId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Filter options for critical infrastructure assets.
class InfrastructureFilterOptions {
  final String district;
  final InfrastructureType? type;
  final InfrastructureStatus? status;
  final String searchQuery;

  const InfrastructureFilterOptions({
    this.district = 'All',
    this.type,
    this.status,
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      district != 'All' ||
      type != null ||
      status != null ||
      searchQuery.isNotEmpty;

  InfrastructureFilterOptions copyWith({
    String? district,
    InfrastructureType? type,
    InfrastructureStatus? status,
    String? searchQuery,
    bool clearType = false,
    bool clearStatus = false,
  }) {
    return InfrastructureFilterOptions(
      district: district ?? this.district,
      type: clearType ? null : (type ?? this.type),
      status: clearStatus ? null : (status ?? this.status),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Filter options for AI Predictive Forecasts.
class PredictionFilterOptions {
  final String district;
  final PredictionType? type;
  final String searchQuery;
  final int minRiskScore;

  const PredictionFilterOptions({
    this.district = 'All',
    this.type,
    this.searchQuery = '',
    this.minRiskScore = 0,
  });

  bool get hasActiveFilters =>
      district != 'All' ||
      type != null ||
      searchQuery.isNotEmpty ||
      minRiskScore > 0;

  PredictionFilterOptions copyWith({
    String? district,
    PredictionType? type,
    String? searchQuery,
    int? minRiskScore,
    bool clearType = false,
  }) {
    return PredictionFilterOptions(
      district: district ?? this.district,
      type: clearType ? null : (type ?? this.type),
      searchQuery: searchQuery ?? this.searchQuery,
      minRiskScore: minRiskScore ?? this.minRiskScore,
    );
  }
}

/// Central state model for the Digital Twin Command Center.
class DigitalTwinState {
  final DigitalTwinViewStatus status;
  final String? errorMessage;
  final DigitalTwinSummary summary;
  final LiveAnalyticsData liveAnalytics;

  // Master collections
  final List<HeatmapPoint> allHeatmapPoints;
  final List<TimelineEvent> allTimelineEvents;
  final List<InfrastructureAsset> allInfrastructureAssets;
  final List<DigitalTwinPrediction> allPredictions;
  final List<DisasterSimulation> allSimulations;

  // Filtered views
  final List<HeatmapPoint> filteredHeatmapPoints;
  final List<TimelineEvent> filteredTimelineEvents;
  final List<InfrastructureAsset> filteredInfrastructureAssets;
  final List<DigitalTwinPrediction> filteredPredictions;

  // Active filter models
  final HeatmapFilterOptions heatmapFilters;
  final TimelineFilterOptions timelineFilters;
  final InfrastructureFilterOptions infrastructureFilters;
  final PredictionFilterOptions predictionFilters;

  // Selections
  final DisasterSimulation? activeSimulation;
  final InfrastructureAsset? selectedAsset;
  final TimelineEvent? selectedTimelineEvent;
  final DigitalTwinPrediction? selectedPrediction;

  const DigitalTwinState({
    required this.status,
    this.errorMessage,
    required this.summary,
    required this.liveAnalytics,
    required this.allHeatmapPoints,
    required this.allTimelineEvents,
    required this.allInfrastructureAssets,
    required this.allPredictions,
    required this.allSimulations,
    required this.filteredHeatmapPoints,
    required this.filteredTimelineEvents,
    required this.filteredInfrastructureAssets,
    required this.filteredPredictions,
    required this.heatmapFilters,
    required this.timelineFilters,
    required this.infrastructureFilters,
    required this.predictionFilters,
    this.activeSimulation,
    this.selectedAsset,
    this.selectedTimelineEvent,
    this.selectedPrediction,
  });

  factory DigitalTwinState.initial() => const DigitalTwinState(
        status: DigitalTwinViewStatus.initial,
        errorMessage: null,
        summary: DigitalTwinSummary.empty,
        liveAnalytics: LiveAnalyticsData(
          incidentCount: 0,
          riskTrend: [],
          precipitationTrend: [],
          populationImpacted: 0,
          roadAvailabilityRatio: 1.0,
          waterLevelMeters: 0.0,
          waterLevelDangerThreshold: 4.5,
          powerGridStable: true,
          communicationTowerUptime: 1.0,
        ),
        allHeatmapPoints: [],
        allTimelineEvents: [],
        allInfrastructureAssets: [],
        allPredictions: [],
        allSimulations: [],
        filteredHeatmapPoints: [],
        filteredTimelineEvents: [],
        filteredInfrastructureAssets: [],
        filteredPredictions: [],
        heatmapFilters: HeatmapFilterOptions(),
        timelineFilters: TimelineFilterOptions(),
        infrastructureFilters: InfrastructureFilterOptions(),
        predictionFilters: PredictionFilterOptions(),
        activeSimulation: null,
        selectedAsset: null,
        selectedTimelineEvent: null,
        selectedPrediction: null,
      );

  bool get isLoading => status == DigitalTwinViewStatus.loading;
  bool get isLoaded => status == DigitalTwinViewStatus.loaded;
  bool get isError => status == DigitalTwinViewStatus.error;
  bool get isEmpty =>
      status == DigitalTwinViewStatus.empty ||
      (status == DigitalTwinViewStatus.loaded &&
          allHeatmapPoints.isEmpty &&
          allTimelineEvents.isEmpty &&
          allInfrastructureAssets.isEmpty);

  DigitalTwinState copyWith({
    DigitalTwinViewStatus? status,
    String? errorMessage,
    DigitalTwinSummary? summary,
    LiveAnalyticsData? liveAnalytics,
    List<HeatmapPoint>? allHeatmapPoints,
    List<TimelineEvent>? allTimelineEvents,
    List<InfrastructureAsset>? allInfrastructureAssets,
    List<DigitalTwinPrediction>? allPredictions,
    List<DisasterSimulation>? allSimulations,
    List<HeatmapPoint>? filteredHeatmapPoints,
    List<TimelineEvent>? filteredTimelineEvents,
    List<InfrastructureAsset>? filteredInfrastructureAssets,
    List<DigitalTwinPrediction>? filteredPredictions,
    HeatmapFilterOptions? heatmapFilters,
    TimelineFilterOptions? timelineFilters,
    InfrastructureFilterOptions? infrastructureFilters,
    PredictionFilterOptions? predictionFilters,
    DisasterSimulation? activeSimulation,
    InfrastructureAsset? selectedAsset,
    TimelineEvent? selectedTimelineEvent,
    DigitalTwinPrediction? selectedPrediction,
    bool clearSelectedAsset = false,
    bool clearSelectedEvent = false,
    bool clearSelectedPrediction = false,
  }) {
    return DigitalTwinState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      summary: summary ?? this.summary,
      liveAnalytics: liveAnalytics ?? this.liveAnalytics,
      allHeatmapPoints: allHeatmapPoints ?? this.allHeatmapPoints,
      allTimelineEvents: allTimelineEvents ?? this.allTimelineEvents,
      allInfrastructureAssets:
          allInfrastructureAssets ?? this.allInfrastructureAssets,
      allPredictions: allPredictions ?? this.allPredictions,
      allSimulations: allSimulations ?? this.allSimulations,
      filteredHeatmapPoints:
          filteredHeatmapPoints ?? this.filteredHeatmapPoints,
      filteredTimelineEvents:
          filteredTimelineEvents ?? this.filteredTimelineEvents,
      filteredInfrastructureAssets:
          filteredInfrastructureAssets ?? this.filteredInfrastructureAssets,
      filteredPredictions: filteredPredictions ?? this.filteredPredictions,
      heatmapFilters: heatmapFilters ?? this.heatmapFilters,
      timelineFilters: timelineFilters ?? this.timelineFilters,
      infrastructureFilters:
          infrastructureFilters ?? this.infrastructureFilters,
      predictionFilters: predictionFilters ?? this.predictionFilters,
      activeSimulation: activeSimulation ?? this.activeSimulation,
      selectedAsset:
          clearSelectedAsset ? null : (selectedAsset ?? this.selectedAsset),
      selectedTimelineEvent: clearSelectedEvent
          ? null
          : (selectedTimelineEvent ?? this.selectedTimelineEvent),
      selectedPrediction: clearSelectedPrediction
          ? null
          : (selectedPrediction ?? this.selectedPrediction),
    );
  }
}
