import '../entities/digital_twin_entities.dart';
import '../repositories/digital_twin_repository.dart';

/// Fetch dashboard telemetry and twin summary.
class GetDigitalTwinSummaryUseCase {
  final DigitalTwinRepository repository;
  GetDigitalTwinSummaryUseCase(this.repository);

  Future<DigitalTwinSummary> call() async {
    return await repository.getTwinSummary();
  }
}

/// Fetch real-time analytics and trend graphs.
class GetLiveAnalyticsUseCase {
  final DigitalTwinRepository repository;
  GetLiveAnalyticsUseCase(this.repository);

  Future<LiveAnalyticsData> call({String? district}) async {
    return await repository.getLiveAnalytics(district: district);
  }
}

/// Retrieve and filter multi-layer heatmap points.
class GetHeatmapPointsUseCase {
  final DigitalTwinRepository repository;
  GetHeatmapPointsUseCase(this.repository);

  Future<List<HeatmapPoint>> call({
    Set<HeatmapLayerType>? activeLayers,
    String? district,
  }) async {
    return await repository.getHeatmapPoints(
      activeLayers: activeLayers,
      district: district,
    );
  }
}

/// Retrieve chronological disaster timeline events.
class GetTimelineEventsUseCase {
  final DigitalTwinRepository repository;
  GetTimelineEventsUseCase(this.repository);

  Future<List<TimelineEvent>> call({
    String? district,
    TimelineEventType? eventType,
    String? incidentId,
    String? searchQuery,
  }) async {
    return await repository.getTimelineEvents(
      district: district,
      eventType: eventType,
      incidentId: incidentId,
      searchQuery: searchQuery,
    );
  }
}

/// Retrieve and filter infrastructure assets.
class GetInfrastructureAssetsUseCase {
  final DigitalTwinRepository repository;
  GetInfrastructureAssetsUseCase(this.repository);

  Future<List<InfrastructureAsset>> call({
    String? district,
    InfrastructureType? type,
    InfrastructureStatus? status,
    String? searchQuery,
  }) async {
    return await repository.getInfrastructureAssets(
      district: district,
      type: type,
      status: status,
      searchQuery: searchQuery,
    );
  }
}

/// Retrieve AI predictions and forecasts.
class GetDigitalTwinPredictionsUseCase {
  final DigitalTwinRepository repository;
  GetDigitalTwinPredictionsUseCase(this.repository);

  Future<List<DigitalTwinPrediction>> call({
    String? district,
    PredictionType? type,
    String? searchQuery,
  }) async {
    return await repository.getAIPredictions(
      district: district,
      type: type,
      searchQuery: searchQuery,
    );
  }
}

/// Manage and run disaster simulations.
class ManageDisasterSimulationUseCase {
  final DigitalTwinRepository repository;
  ManageDisasterSimulationUseCase(this.repository);

  Future<List<DisasterSimulation>> getSimulations() async {
    return await repository.getSimulations();
  }

  Future<DisasterSimulation> updateSimulation(DisasterSimulation simulation) async {
    return await repository.updateSimulation(simulation);
  }
}
