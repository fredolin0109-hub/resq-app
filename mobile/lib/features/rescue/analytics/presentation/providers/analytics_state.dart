import '../../domain/entities/analytics_entities.dart';

enum AnalyticsViewStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// Incident filtering options.
class IncidentFilterOptions {
  final String district;
  final DisasterCategory? category;
  final SeverityLevel? severity;
  final IncidentStatus? status;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;

  const IncidentFilterOptions({
    this.district = 'All',
    this.category,
    this.severity,
    this.status,
    this.searchQuery = '',
    this.startDate,
    this.endDate,
  });

  bool get hasActiveFilters =>
      district != 'All' ||
      category != null ||
      severity != null ||
      status != null ||
      searchQuery.isNotEmpty ||
      startDate != null ||
      endDate != null;

  IncidentFilterOptions copyWith({
    String? district,
    DisasterCategory? category,
    SeverityLevel? severity,
    IncidentStatus? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    bool clearCategory = false,
    bool clearSeverity = false,
    bool clearStatus = false,
    bool clearDates = false,
  }) {
    return IncidentFilterOptions(
      district: district ?? this.district,
      category: clearCategory ? null : (category ?? this.category),
      severity: clearSeverity ? null : (severity ?? this.severity),
      status: clearStatus ? null : (status ?? this.status),
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
    );
  }
}

/// Team performance filtering and sorting options.
class TeamFilterOptions {
  final String district;
  final String searchQuery;
  final String sortBy; // 'score', 'rescues', 'responseTime', 'successRate'

  const TeamFilterOptions({
    this.district = 'All',
    this.searchQuery = '',
    this.sortBy = 'score',
  });

  bool get hasActiveFilters =>
      district != 'All' || searchQuery.isNotEmpty || sortBy != 'score';

  TeamFilterOptions copyWith({
    String? district,
    String? searchQuery,
    String? sortBy,
  }) {
    return TeamFilterOptions(
      district: district ?? this.district,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

/// District filtering options.
class DistrictFilterOptions {
  final String district;
  final RiskTier? riskTier;
  final String searchQuery;

  const DistrictFilterOptions({
    this.district = 'All',
    this.riskTier,
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      district != 'All' || riskTier != null || searchQuery.isNotEmpty;

  DistrictFilterOptions copyWith({
    String? district,
    RiskTier? riskTier,
    String? searchQuery,
    bool clearRiskTier = false,
  }) {
    return DistrictFilterOptions(
      district: district ?? this.district,
      riskTier: clearRiskTier ? null : (riskTier ?? this.riskTier),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// AI Insights filtering options.
class AIInsightFilterOptions {
  final String category;
  final SeverityLevel? severity;
  final String searchQuery;

  const AIInsightFilterOptions({
    this.category = 'All',
    this.severity,
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      category != 'All' || severity != null || searchQuery.isNotEmpty;

  AIInsightFilterOptions copyWith({
    String? category,
    SeverityLevel? severity,
    String? searchQuery,
    bool clearSeverity = false,
  }) {
    return AIInsightFilterOptions(
      category: category ?? this.category,
      severity: clearSeverity ? null : (severity ?? this.severity),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Unified immutable state for Disaster Analytics & Reporting.
class AnalyticsState {
  final AnalyticsViewStatus status;
  final String? errorMessage;
  final AnalyticsSummary summary;
  final List<IncidentStatItem> allIncidents;
  final List<IncidentStatItem> filteredIncidents;
  final IncidentFilterOptions incidentFilters;
  final ResourceUsageAnalytics resourceAnalytics;
  final String selectedResourceDistrict;
  final List<TeamPerformanceItem> allTeams;
  final List<TeamPerformanceItem> filteredTeams;
  final TeamFilterOptions teamFilters;
  final List<DistrictAnalyticsItem> allDistricts;
  final List<DistrictAnalyticsItem> filteredDistricts;
  final DistrictFilterOptions districtFilters;
  final List<AIInsightItem> allInsights;
  final List<AIInsightItem> filteredInsights;
  final AIInsightFilterOptions insightFilters;
  final List<GeneratedReport> reports;
  final bool isGeneratingReport;
  final String? lastGeneratedReportContent;

  const AnalyticsState({
    required this.status,
    this.errorMessage,
    required this.summary,
    required this.allIncidents,
    required this.filteredIncidents,
    required this.incidentFilters,
    required this.resourceAnalytics,
    required this.selectedResourceDistrict,
    required this.allTeams,
    required this.filteredTeams,
    required this.teamFilters,
    required this.allDistricts,
    required this.filteredDistricts,
    required this.districtFilters,
    required this.allInsights,
    required this.filteredInsights,
    required this.insightFilters,
    required this.reports,
    required this.isGeneratingReport,
    this.lastGeneratedReportContent,
  });

  factory AnalyticsState.initial() {
    return const AnalyticsState(
      status: AnalyticsViewStatus.initial,
      errorMessage: null,
      summary: AnalyticsSummary.empty,
      allIncidents: [],
      filteredIncidents: [],
      incidentFilters: IncidentFilterOptions(),
      resourceAnalytics: ResourceUsageAnalytics(
        totalVehiclesActive: 0,
        totalVehiclesDeployed: 0,
        fuelConsumptionLitres: 0,
        medicalKitsUsed: 0,
        foodRationsDistributedKg: 0,
        waterPacketsDistributedLitres: 0,
        shelterOccupancyRatio: 0,
        hospitalCapacityRatio: 0,
      ),
      selectedResourceDistrict: 'All',
      allTeams: [],
      filteredTeams: [],
      teamFilters: TeamFilterOptions(),
      allDistricts: [],
      filteredDistricts: [],
      districtFilters: DistrictFilterOptions(),
      allInsights: [],
      filteredInsights: [],
      insightFilters: AIInsightFilterOptions(),
      reports: [],
      isGeneratingReport: false,
      lastGeneratedReportContent: null,
    );
  }

  AnalyticsState copyWith({
    AnalyticsViewStatus? status,
    String? errorMessage,
    AnalyticsSummary? summary,
    List<IncidentStatItem>? allIncidents,
    List<IncidentStatItem>? filteredIncidents,
    IncidentFilterOptions? incidentFilters,
    ResourceUsageAnalytics? resourceAnalytics,
    String? selectedResourceDistrict,
    List<TeamPerformanceItem>? allTeams,
    List<TeamPerformanceItem>? filteredTeams,
    TeamFilterOptions? teamFilters,
    List<DistrictAnalyticsItem>? allDistricts,
    List<DistrictAnalyticsItem>? filteredDistricts,
    DistrictFilterOptions? districtFilters,
    List<AIInsightItem>? allInsights,
    List<AIInsightItem>? filteredInsights,
    AIInsightFilterOptions? insightFilters,
    List<GeneratedReport>? reports,
    bool? isGeneratingReport,
    String? lastGeneratedReportContent,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      summary: summary ?? this.summary,
      allIncidents: allIncidents ?? this.allIncidents,
      filteredIncidents: filteredIncidents ?? this.filteredIncidents,
      incidentFilters: incidentFilters ?? this.incidentFilters,
      resourceAnalytics: resourceAnalytics ?? this.resourceAnalytics,
      selectedResourceDistrict:
          selectedResourceDistrict ?? this.selectedResourceDistrict,
      allTeams: allTeams ?? this.allTeams,
      filteredTeams: filteredTeams ?? this.filteredTeams,
      teamFilters: teamFilters ?? this.teamFilters,
      allDistricts: allDistricts ?? this.allDistricts,
      filteredDistricts: filteredDistricts ?? this.filteredDistricts,
      districtFilters: districtFilters ?? this.districtFilters,
      allInsights: allInsights ?? this.allInsights,
      filteredInsights: filteredInsights ?? this.filteredInsights,
      insightFilters: insightFilters ?? this.insightFilters,
      reports: reports ?? this.reports,
      isGeneratingReport: isGeneratingReport ?? this.isGeneratingReport,
      lastGeneratedReportContent:
          lastGeneratedReportContent ?? this.lastGeneratedReportContent,
    );
  }
}
