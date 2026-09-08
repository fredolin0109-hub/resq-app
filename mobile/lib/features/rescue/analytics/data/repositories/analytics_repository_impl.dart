import '../../domain/entities/analytics_entities.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_mock_datasource.dart';

/// Concrete repository implementation that interfaces with the data source layer.
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsMockDataSource _dataSource;

  AnalyticsRepositoryImpl({AnalyticsMockDataSource? dataSource})
      : _dataSource = dataSource ?? AnalyticsMockDataSource();

  @override
  Future<AnalyticsSummary> getAnalyticsSummary() {
    return _dataSource.getAnalyticsSummary();
  }

  @override
  Future<List<IncidentStatItem>> getIncidentStats({
    String? district,
    DisasterCategory? category,
    SeverityLevel? severity,
    IncidentStatus? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final list = await _dataSource.getIncidentStats(
      district: district,
      category: category,
      severity: severity,
      status: status,
      searchQuery: searchQuery,
      startDate: startDate,
      endDate: endDate,
    );
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ResourceUsageAnalytics> getResourceUsageAnalytics({String? district}) {
    return _dataSource.getResourceUsageAnalytics(district: district);
  }

  @override
  Future<List<TeamPerformanceItem>> getTeamPerformance({
    String? district,
    String? searchQuery,
    String? sortBy,
  }) async {
    final list = await _dataSource.getTeamPerformance(
      district: district,
      searchQuery: searchQuery,
      sortBy: sortBy,
    );
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<DistrictAnalyticsItem>> getDistrictAnalytics({String? district}) async {
    final list = await _dataSource.getDistrictAnalytics(district: district);
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AIInsightItem>> getAIInsights({
    String? category,
    SeverityLevel? severity,
    String? searchQuery,
  }) async {
    final list = await _dataSource.getAIInsights(
      category: category,
      severity: severity,
      searchQuery: searchQuery,
    );
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<GeneratedReport>> getGeneratedReports() async {
    final list = await _dataSource.getGeneratedReports();
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<GeneratedReport> generateReport({
    required ReportTimeframe timeframe,
    required ReportFormat format,
    String? district,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) async {
    final model = await _dataSource.generateReport(
      timeframe: timeframe,
      format: format,
      district: district,
      customStartDate: customStartDate,
      customEndDate: customEndDate,
    );
    return model.toEntity();
  }
}
