import '../entities/analytics_entities.dart';

/// Abstract repository contract for Disaster Analytics, Insights, Statistics, and Reporting.
abstract class AnalyticsRepository {
  /// Fetch aggregated summary statistics for the Analytics dashboard.
  Future<AnalyticsSummary> getAnalyticsSummary();

  /// Retrieve incident records for statistical breakdown and chart visualizers.
  Future<List<IncidentStatItem>> getIncidentStats({
    String? district,
    DisasterCategory? category,
    SeverityLevel? severity,
    IncidentStatus? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Retrieve resource utilization metrics (vehicles, fuel, food, water, medical, shelters, hospitals).
  Future<ResourceUsageAnalytics> getResourceUsageAnalytics({String? district});

  /// Retrieve team performance scorecard and leaderboard.
  Future<List<TeamPerformanceItem>> getTeamPerformance({
    String? district,
    String? searchQuery,
    String? sortBy,
  });

  /// Retrieve district-level disaster operational profiles across all 13 Tamil Nadu districts.
  Future<List<DistrictAnalyticsItem>> getDistrictAnalytics({String? district});

  /// Retrieve AI-generated operational and predictive insight cards.
  Future<List<AIInsightItem>> getAIInsights({
    String? category,
    SeverityLevel? severity,
    String? searchQuery,
  });

  /// Retrieve list of previously generated export reports.
  Future<List<GeneratedReport>> getGeneratedReports();

  /// Generate a new report (Daily, Weekly, Monthly, Custom in PDF, CSV, JSON format).
  Future<GeneratedReport> generateReport({
    required ReportTimeframe timeframe,
    required ReportFormat format,
    String? district,
    DateTime? customStartDate,
    DateTime? customEndDate,
  });
}
