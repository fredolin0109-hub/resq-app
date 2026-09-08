import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/datasources/analytics_mock_datasource.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../domain/entities/analytics_entities.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../domain/usecases/analytics_usecases.dart';
import '../../services/report_export_service.dart';
import 'analytics_state.dart';

/// Central state notifier orchestrating Disaster Analytics, Incident Statistics,
/// Resource Utilization, Team Scorecards, District Profiles, AI Insights, and Reports.
class AnalyticsNotifier extends ChangeNotifier {
  final GetAnalyticsSummaryUseCase _getSummaryUseCase;
  final GetIncidentStatisticsUseCase _getIncidentsUseCase;
  final GetResourceUsageAnalyticsUseCase _getResourcesUseCase;
  final GetTeamPerformanceUseCase _getTeamsUseCase;
  final GetDistrictAnalyticsUseCase _getDistrictsUseCase;
  final GetAIInsightsUseCase _getInsightsUseCase;
  final GetGeneratedReportsUseCase _getReportsUseCase;
  final GenerateReportUseCase _generateReportUseCase;
  final ReportExportService _exportService;

  AnalyticsState _state = AnalyticsState.initial();

  AnalyticsNotifier({
    required GetAnalyticsSummaryUseCase getSummaryUseCase,
    required GetIncidentStatisticsUseCase getIncidentsUseCase,
    required GetResourceUsageAnalyticsUseCase getResourcesUseCase,
    required GetTeamPerformanceUseCase getTeamsUseCase,
    required GetDistrictAnalyticsUseCase getDistrictsUseCase,
    required GetAIInsightsUseCase getInsightsUseCase,
    required GetGeneratedReportsUseCase getReportsUseCase,
    required GenerateReportUseCase generateReportUseCase,
    ReportExportService? exportService,
  })  : _getSummaryUseCase = getSummaryUseCase,
        _getIncidentsUseCase = getIncidentsUseCase,
        _getResourcesUseCase = getResourcesUseCase,
        _getTeamsUseCase = getTeamsUseCase,
        _getDistrictsUseCase = getDistrictsUseCase,
        _getInsightsUseCase = getInsightsUseCase,
        _getReportsUseCase = getReportsUseCase,
        _generateReportUseCase = generateReportUseCase,
        _exportService = exportService ?? ReportExportService();

  AnalyticsState get state => _state;

  /// Initial load of all analytics telemetry, entities, and historical records.
  Future<void> loadAnalytics() async {
    _state = _state.copyWith(status: AnalyticsViewStatus.loading);
    notifyListeners();

    try {
      final summary = await _getSummaryUseCase();
      final incidents = await _getIncidentsUseCase();
      final resources = await _getResourcesUseCase();
      final teams = await _getTeamsUseCase();
      final districts = await _getDistrictsUseCase();
      final insights = await _getInsightsUseCase();
      final reports = await _getReportsUseCase();

      final filteredIncidents = _applyIncidentFilters(incidents, _state.incidentFilters);
      final filteredTeams = _applyTeamFilters(teams, _state.teamFilters);
      final filteredDistricts = _applyDistrictFilters(districts, _state.districtFilters);
      final filteredInsights = _applyInsightFilters(insights, _state.insightFilters);

      _state = _state.copyWith(
        status: AnalyticsViewStatus.loaded,
        summary: summary,
        allIncidents: incidents,
        filteredIncidents: filteredIncidents,
        resourceAnalytics: resources,
        allTeams: teams,
        filteredTeams: filteredTeams,
        allDistricts: districts,
        filteredDistricts: filteredDistricts,
        allInsights: insights,
        filteredInsights: filteredInsights,
        reports: reports,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: AnalyticsViewStatus.error,
        errorMessage: 'Failed to load disaster analytics: $e',
      );
      notifyListeners();
    }
  }

  /// Reload all analytics dataset.
  Future<void> refresh() => loadAnalytics();

  // --- Incident Filter Actions ---

  void setIncidentDistrict(String district) {
    final newFilters = _state.incidentFilters.copyWith(district: district);
    _state = _state.copyWith(
      incidentFilters: newFilters,
      filteredIncidents: _applyIncidentFilters(_state.allIncidents, newFilters),
    );
    notifyListeners();
  }

  void setIncidentCategory(DisasterCategory? category) {
    final newFilters = category == null
        ? _state.incidentFilters.copyWith(clearCategory: true)
        : _state.incidentFilters.copyWith(category: category);
    _state = _state.copyWith(
      incidentFilters: newFilters,
      filteredIncidents: _applyIncidentFilters(_state.allIncidents, newFilters),
    );
    notifyListeners();
  }

  void setIncidentSeverity(SeverityLevel? severity) {
    final newFilters = severity == null
        ? _state.incidentFilters.copyWith(clearSeverity: true)
        : _state.incidentFilters.copyWith(severity: severity);
    _state = _state.copyWith(
      incidentFilters: newFilters,
      filteredIncidents: _applyIncidentFilters(_state.allIncidents, newFilters),
    );
    notifyListeners();
  }

  void setIncidentStatus(IncidentStatus? status) {
    final newFilters = status == null
        ? _state.incidentFilters.copyWith(clearStatus: true)
        : _state.incidentFilters.copyWith(status: status);
    _state = _state.copyWith(
      incidentFilters: newFilters,
      filteredIncidents: _applyIncidentFilters(_state.allIncidents, newFilters),
    );
    notifyListeners();
  }

  void setIncidentSearchQuery(String query) {
    final newFilters = _state.incidentFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(
      incidentFilters: newFilters,
      filteredIncidents: _applyIncidentFilters(_state.allIncidents, newFilters),
    );
    notifyListeners();
  }

  void setIncidentDateRange(DateTime? start, DateTime? end) {
    final newFilters = (start == null && end == null)
        ? _state.incidentFilters.copyWith(clearDates: true)
        : _state.incidentFilters.copyWith(startDate: start, endDate: end);
    _state = _state.copyWith(
      incidentFilters: newFilters,
      filteredIncidents: _applyIncidentFilters(_state.allIncidents, newFilters),
    );
    notifyListeners();
  }

  void clearIncidentFilters() {
    const newFilters = IncidentFilterOptions();
    _state = _state.copyWith(
      incidentFilters: newFilters,
      filteredIncidents: _applyIncidentFilters(_state.allIncidents, newFilters),
    );
    notifyListeners();
  }

  // --- Resource District Filter Action ---

  Future<void> setResourceDistrict(String district) async {
    try {
      final resources = await _getResourcesUseCase(district: district);
      _state = _state.copyWith(
        selectedResourceDistrict: district,
        resourceAnalytics: resources,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating resource district: $e');
    }
  }

  // --- Team Performance Filter Actions ---

  void setTeamDistrict(String district) {
    final newFilters = _state.teamFilters.copyWith(district: district);
    _state = _state.copyWith(
      teamFilters: newFilters,
      filteredTeams: _applyTeamFilters(_state.allTeams, newFilters),
    );
    notifyListeners();
  }

  void setTeamSearchQuery(String query) {
    final newFilters = _state.teamFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(
      teamFilters: newFilters,
      filteredTeams: _applyTeamFilters(_state.allTeams, newFilters),
    );
    notifyListeners();
  }

  void setTeamSortBy(String sortBy) {
    final newFilters = _state.teamFilters.copyWith(sortBy: sortBy);
    _state = _state.copyWith(
      teamFilters: newFilters,
      filteredTeams: _applyTeamFilters(_state.allTeams, newFilters),
    );
    notifyListeners();
  }

  void clearTeamFilters() {
    const newFilters = TeamFilterOptions();
    _state = _state.copyWith(
      teamFilters: newFilters,
      filteredTeams: _applyTeamFilters(_state.allTeams, newFilters),
    );
    notifyListeners();
  }

  // --- District Analytics Filter Actions ---

  void setDistrictFilter(String district) {
    final newFilters = _state.districtFilters.copyWith(district: district);
    _state = _state.copyWith(
      districtFilters: newFilters,
      filteredDistricts: _applyDistrictFilters(_state.allDistricts, newFilters),
    );
    notifyListeners();
  }

  void setDistrictRiskTier(RiskTier? tier) {
    final newFilters = tier == null
        ? _state.districtFilters.copyWith(clearRiskTier: true)
        : _state.districtFilters.copyWith(riskTier: tier);
    _state = _state.copyWith(
      districtFilters: newFilters,
      filteredDistricts: _applyDistrictFilters(_state.allDistricts, newFilters),
    );
    notifyListeners();
  }

  void setDistrictSearchQuery(String query) {
    final newFilters = _state.districtFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(
      districtFilters: newFilters,
      filteredDistricts: _applyDistrictFilters(_state.allDistricts, newFilters),
    );
    notifyListeners();
  }

  void clearDistrictFilters() {
    const newFilters = DistrictFilterOptions();
    _state = _state.copyWith(
      districtFilters: newFilters,
      filteredDistricts: _applyDistrictFilters(_state.allDistricts, newFilters),
    );
    notifyListeners();
  }

  // --- AI Insights Filter Actions ---

  void setInsightCategory(String category) {
    final newFilters = _state.insightFilters.copyWith(category: category);
    _state = _state.copyWith(
      insightFilters: newFilters,
      filteredInsights: _applyInsightFilters(_state.allInsights, newFilters),
    );
    notifyListeners();
  }

  void setInsightSeverity(SeverityLevel? severity) {
    final newFilters = severity == null
        ? _state.insightFilters.copyWith(clearSeverity: true)
        : _state.insightFilters.copyWith(severity: severity);
    _state = _state.copyWith(
      insightFilters: newFilters,
      filteredInsights: _applyInsightFilters(_state.allInsights, newFilters),
    );
    notifyListeners();
  }

  void setInsightSearchQuery(String query) {
    final newFilters = _state.insightFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(
      insightFilters: newFilters,
      filteredInsights: _applyInsightFilters(_state.allInsights, newFilters),
    );
    notifyListeners();
  }

  void clearInsightFilters() {
    const newFilters = AIInsightFilterOptions();
    _state = _state.copyWith(
      insightFilters: newFilters,
      filteredInsights: _applyInsightFilters(_state.allInsights, newFilters),
    );
    notifyListeners();
  }

  // --- Report Generation & Export ---

  Future<GeneratedReport?> generateNewReport({
    required ReportTimeframe timeframe,
    required ReportFormat format,
    String? district,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) async {
    _state = _state.copyWith(isGeneratingReport: true);
    notifyListeners();

    try {
      final report = await _generateReportUseCase(
        timeframe: timeframe,
        format: format,
        district: district,
        customStartDate: customStartDate,
        customEndDate: customEndDate,
      );

      final updatedReports = await _getReportsUseCase();

      final content = await _exportService.exportReportContent(
        timeframe: timeframe,
        format: format,
        summary: _state.summary,
        incidents: _state.filteredIncidents,
        resources: _state.resourceAnalytics,
        teams: _state.filteredTeams,
        districts: _state.filteredDistricts,
        insights: _state.filteredInsights,
        districtFilter: district,
      );

      _state = _state.copyWith(
        isGeneratingReport: false,
        reports: updatedReports,
        lastGeneratedReportContent: content,
      );
      notifyListeners();
      return report;
    } catch (e) {
      _state = _state.copyWith(isGeneratingReport: false);
      notifyListeners();
      return null;
    }
  }

  Future<String> exportReportPreview({
    required ReportTimeframe timeframe,
    required ReportFormat format,
    String? district,
  }) async {
    return await _exportService.exportReportContent(
      timeframe: timeframe,
      format: format,
      summary: _state.summary,
      incidents: _state.filteredIncidents,
      resources: _state.resourceAnalytics,
      teams: _state.filteredTeams,
      districts: _state.filteredDistricts,
      insights: _state.filteredInsights,
      districtFilter: district,
    );
  }

  // --- Filter Implementations ---

  List<IncidentStatItem> _applyIncidentFilters(
      List<IncidentStatItem> items, IncidentFilterOptions filters) {
    return items.where((item) {
      if (filters.district != 'All' && item.district != filters.district) {
        return false;
      }
      if (filters.category != null && item.disasterCategory != filters.category) {
        return false;
      }
      if (filters.severity != null && item.severity != filters.severity) {
        return false;
      }
      if (filters.status != null && item.status != filters.status) {
        return false;
      }
      if (filters.startDate != null && item.timestamp.isBefore(filters.startDate!)) {
        return false;
      }
      if (filters.endDate != null && item.timestamp.isAfter(filters.endDate!)) {
        return false;
      }
      if (filters.searchQuery.trim().isNotEmpty) {
        final q = filters.searchQuery.toLowerCase();
        final match = item.title.toLowerCase().contains(q) ||
            item.district.toLowerCase().contains(q) ||
            item.id.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<TeamPerformanceItem> _applyTeamFilters(
      List<TeamPerformanceItem> items, TeamFilterOptions filters) {
    var list = items.where((team) {
      if (filters.district != 'All' && team.district != filters.district) {
        return false;
      }
      if (filters.searchQuery.trim().isNotEmpty) {
        final q = filters.searchQuery.toLowerCase();
        final match = team.teamName.toLowerCase().contains(q) ||
            team.leaderName.toLowerCase().contains(q) ||
            team.district.toLowerCase().contains(q) ||
            team.teamId.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();

    if (filters.sortBy == 'rescues') {
      list.sort((a, b) => b.rescuesCompleted.compareTo(a.rescuesCompleted));
    } else if (filters.sortBy == 'responseTime') {
      list.sort((a, b) => a.avgResponseTimeMinutes.compareTo(b.avgResponseTimeMinutes));
    } else if (filters.sortBy == 'successRate') {
      list.sort((a, b) => b.successRate.compareTo(a.successRate));
    } else {
      list.sort((a, b) => b.performanceScore.compareTo(a.performanceScore));
    }

    return list;
  }

  List<DistrictAnalyticsItem> _applyDistrictFilters(
      List<DistrictAnalyticsItem> items, DistrictFilterOptions filters) {
    return items.where((dist) {
      if (filters.district != 'All' && dist.district != filters.district) {
        return false;
      }
      if (filters.riskTier != null && dist.riskTier != filters.riskTier) {
        return false;
      }
      if (filters.searchQuery.trim().isNotEmpty) {
        final q = filters.searchQuery.toLowerCase();
        if (!dist.district.toLowerCase().contains(q)) return false;
      }
      return true;
    }).toList();
  }

  List<AIInsightItem> _applyInsightFilters(
      List<AIInsightItem> items, AIInsightFilterOptions filters) {
    return items.where((ins) {
      if (filters.category != 'All' && ins.category != filters.category) {
        return false;
      }
      if (filters.severity != null && ins.severity != filters.severity) {
        return false;
      }
      if (filters.searchQuery.trim().isNotEmpty) {
        final q = filters.searchQuery.toLowerCase();
        final match = ins.title.toLowerCase().contains(q) ||
            ins.recommendation.toLowerCase().contains(q) ||
            ins.projectedImpact.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }
}

/// Dependency injection and singleton provider container for Analytics.
class AnalyticsDependencies {
  static final AnalyticsMockDataSource dataSource = AnalyticsMockDataSource();
  static final AnalyticsRepository repository =
      AnalyticsRepositoryImpl(dataSource: dataSource);

  static final GetAnalyticsSummaryUseCase getSummaryUseCase =
      GetAnalyticsSummaryUseCase(repository);
  static final GetIncidentStatisticsUseCase getIncidentsUseCase =
      GetIncidentStatisticsUseCase(repository);
  static final GetResourceUsageAnalyticsUseCase getResourcesUseCase =
      GetResourceUsageAnalyticsUseCase(repository);
  static final GetTeamPerformanceUseCase getTeamsUseCase =
      GetTeamPerformanceUseCase(repository);
  static final GetDistrictAnalyticsUseCase getDistrictsUseCase =
      GetDistrictAnalyticsUseCase(repository);
  static final GetAIInsightsUseCase getInsightsUseCase =
      GetAIInsightsUseCase(repository);
  static final GetGeneratedReportsUseCase getReportsUseCase =
      GetGeneratedReportsUseCase(repository);
  static final GenerateReportUseCase generateReportUseCase =
      GenerateReportUseCase(repository);
  static final ReportExportService exportService = ReportExportService();

  static final AnalyticsNotifier notifier = AnalyticsNotifier(
    getSummaryUseCase: getSummaryUseCase,
    getIncidentsUseCase: getIncidentsUseCase,
    getResourcesUseCase: getResourcesUseCase,
    getTeamsUseCase: getTeamsUseCase,
    getDistrictsUseCase: getDistrictsUseCase,
    getInsightsUseCase: getInsightsUseCase,
    getReportsUseCase: getReportsUseCase,
    generateReportUseCase: generateReportUseCase,
    exportService: exportService,
  );
}
