import '../entities/digital_twin_entities.dart';

/// Abstract repository contract for Digital Twin disaster monitoring, analytics, predictions, and simulations.
abstract class DigitalTwinRepository {
  /// Fetch aggregated summary statistics for the Digital Twin command dashboard.
  Future<DigitalTwinSummary> getTwinSummary();

  /// Retrieve real-time telemetry and trend data for live analytics.
  Future<LiveAnalyticsData> getLiveAnalytics({String? district});

  /// Retrieve spatial heatmap points, optionally filtered by active layers or district.
  Future<List<HeatmapPoint>> getHeatmapPoints({
    Set<HeatmapLayerType>? activeLayers,
    String? district,
  });

  /// Retrieve chronological disaster timeline events.
  Future<List<TimelineEvent>> getTimelineEvents({
    String? district,
    TimelineEventType? eventType,
    String? incidentId,
    String? searchQuery,
  });

  /// Retrieve infrastructure monitoring assets across Tamil Nadu.
  Future<List<InfrastructureAsset>> getInfrastructureAssets({
    String? district,
    InfrastructureType? type,
    InfrastructureStatus? status,
    String? searchQuery,
  });

  /// Retrieve AI predictive forecasts.
  Future<List<DigitalTwinPrediction>> getAIPredictions({
    String? district,
    PredictionType? type,
    String? searchQuery,
  });

  /// Retrieve available simulation scenarios.
  Future<List<DisasterSimulation>> getSimulations();

  /// Update or scrub disaster simulation state (speed, progress, playback).
  Future<DisasterSimulation> updateSimulation(DisasterSimulation simulation);
}
