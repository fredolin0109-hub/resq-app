import '../../domain/entities/digital_twin_entities.dart';
import '../../domain/repositories/digital_twin_repository.dart';
import '../datasources/digital_twin_mock_datasource.dart';

/// Implementation of DigitalTwinRepository backed by DigitalTwinMockDatasource.
class DigitalTwinRepositoryImpl implements DigitalTwinRepository {
  final DigitalTwinMockDatasource datasource;

  DigitalTwinRepositoryImpl(this.datasource);

  @override
  Future<DigitalTwinSummary> getTwinSummary() async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      return datasource.getSummary();
    } catch (e) {
      throw Exception('Failed to fetch Digital Twin summary telemetry: $e');
    }
  }

  @override
  Future<LiveAnalyticsData> getLiveAnalytics({String? district}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      return datasource.getLiveAnalytics(district: district);
    } catch (e) {
      throw Exception('Failed to fetch live analytics telemetry: $e');
    }
  }

  @override
  Future<List<HeatmapPoint>> getHeatmapPoints({
    Set<HeatmapLayerType>? activeLayers,
    String? district,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 120));
      return datasource.getHeatmapPoints(
        activeLayers: activeLayers,
        district: district,
      );
    } catch (e) {
      throw Exception('Failed to retrieve heatmap coordinates: $e');
    }
  }

  @override
  Future<List<TimelineEvent>> getTimelineEvents({
    String? district,
    TimelineEventType? eventType,
    String? incidentId,
    String? searchQuery,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      return datasource.getTimelineEvents(
        district: district,
        eventType: eventType,
        incidentId: incidentId,
        searchQuery: searchQuery,
      );
    } catch (e) {
      throw Exception('Failed to load timeline events: $e');
    }
  }

  @override
  Future<List<InfrastructureAsset>> getInfrastructureAssets({
    String? district,
    InfrastructureType? type,
    InfrastructureStatus? status,
    String? searchQuery,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 140));
      return datasource.getInfrastructureAssets(
        district: district,
        type: type,
        status: status,
        searchQuery: searchQuery,
      );
    } catch (e) {
      throw Exception('Failed to retrieve infrastructure assets: $e');
    }
  }

  @override
  Future<List<DigitalTwinPrediction>> getAIPredictions({
    String? district,
    PredictionType? type,
    String? searchQuery,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 160));
      return datasource.getAIPredictions(
        district: district,
        type: type,
        searchQuery: searchQuery,
      );
    } catch (e) {
      throw Exception('Failed to generate AI predictions: $e');
    }
  }

  @override
  Future<List<DisasterSimulation>> getSimulations() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      return datasource.getSimulations();
    } catch (e) {
      throw Exception('Failed to load disaster simulations: $e');
    }
  }

  @override
  Future<DisasterSimulation> updateSimulation(DisasterSimulation simulation) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      return simulation;
    } catch (e) {
      throw Exception('Failed to update disaster simulation: $e');
    }
  }
}
