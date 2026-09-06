import '../entities/analytics_entities.dart';
import '../repositories/analytics_repository.dart';

/// Retrieve aggregated top-level analytics metrics.
class GetAnalyticsSummaryUseCase {
  final AnalyticsRepository repository;
  GetAnalyticsSummaryUseCase(this.repository);

  Future<AnalyticsSummary> call() async {
    return await repository.getAnalyticsSummary();
  }
}

/// Retrieve and filter incident statistics.
class GetIncidentStatisticsUseCase {
  final AnalyticsRepository repository;
  GetIncidentStatisticsUseCase(this.repository);

  Future<List<IncidentStatItem>> call({
    String? district,
    DisasterCategory? category,
    SeverityLevel? severity,
    IncidentStatus? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getIncidentStats(
      district: district,
      category: category,
      severity: severity,
      status: status,
      searchQuery: searchQuery,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

/// Retrieve resource usage and utilization telemetry.
class GetResourceUsageAnalyticsUseCase {
  final AnalyticsRepository repository;
  GetResourceUsageAnalyticsUseCase(this.repository);

  Future<ResourceUsageAnalytics> call({String? district}) async {
    return await repository.getResourceUsageAnalytics(district: district);
  }
}

/// Retrieve team performance scorecard and rankings.
class GetTeamPerformanceUseCase {
  final AnalyticsRepository repository;
  GetTeamPerformanceUseCase(this.repository);

  Future<List<TeamPerformanceItem>> call({
    String? district,
    String? searchQuery,
    String? sortBy,
  }) async {
    return await repository.getTeamPerformance(
      district: district,
      searchQuery: searchQuery,
      sortBy: sortBy,
    );
  }
}

/// Retrieve district-level disaster profiles across 13 Tamil Nadu districts.
class GetDistrictAnalyticsUseCase {
  final AnalyticsRepository repository;
  GetDistrictAnalyticsUseCase(this.repository);

  Future<List<DistrictAnalyticsItem>> call({String? district}) async {
    return await repository.getDistrictAnalytics(district: district);
  }
}

/// Retrieve AI operational insight cards.
class GetAIInsightsUseCase {
  final AnalyticsRepository repository;
  GetAIInsightsUseCase(this.repository);

  Future<List<AIInsightItem>> call({
    String? category,
    SeverityLevel? severity,
    String? searchQuery,
  }) async {
    return await repository.getAIInsights(
      category: category,
      severity: severity,
      searchQuery: searchQuery,
    );
  }
}

/// Generate new export reports.
class GenerateReportUseCase {
  final AnalyticsRepository repository;
  GenerateReportUseCase(this.repository);

  Future<GeneratedReport> call({
    required ReportTimeframe timeframe,
    required ReportFormat format,
    String? district,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) async {
    return await repository.generateReport(
      timeframe: timeframe,
      format: format,
      district: district,
      customStartDate: customStartDate,
      customEndDate: customEndDate,
    );
  }
}

/// Retrieve previously generated reports.
class GetGeneratedReportsUseCase {
  final AnalyticsRepository repository;
  GetGeneratedReportsUseCase(this.repository);

  Future<List<GeneratedReport>> call() async {
    return await repository.getGeneratedReports();
  }
}
