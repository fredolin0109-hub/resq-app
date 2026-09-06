import '../../domain/entities/ai_commander_entities.dart';

enum AICommanderViewStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// Filter options for incident analyses.
class IncidentFilterOptions {
  final String district;
  final IncidentType? incidentType;
  final IncidentSeverity? severity;
  final String searchQuery;

  const IncidentFilterOptions({
    this.district = 'All',
    this.incidentType,
    this.severity,
    this.searchQuery = '',
  });

  bool get hasActiveFilters => district != 'All' || incidentType != null || severity != null || searchQuery.isNotEmpty;

  IncidentFilterOptions copyWith({
    String? district,
    IncidentType? incidentType,
    IncidentSeverity? severity,
    String? searchQuery,
    bool clearType = false,
    bool clearSeverity = false,
  }) {
    return IncidentFilterOptions(
      district: district ?? this.district,
      incidentType: clearType ? null : (incidentType ?? this.incidentType),
      severity: clearSeverity ? null : (severity ?? this.severity),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Filter options for recommendations.
class RecommendationFilterOptions {
  final RecommendationPriority? priority;
  final ExecutionDifficulty? difficulty;
  final bool? isExecuted;
  final String searchQuery;

  const RecommendationFilterOptions({
    this.priority,
    this.difficulty,
    this.isExecuted,
    this.searchQuery = '',
  });

  bool get hasActiveFilters => priority != null || difficulty != null || isExecuted != null || searchQuery.isNotEmpty;

  RecommendationFilterOptions copyWith({
    RecommendationPriority? priority,
    ExecutionDifficulty? difficulty,
    bool? isExecuted,
    String? searchQuery,
    bool clearPriority = false,
    bool clearDifficulty = false,
    bool clearExecuted = false,
  }) {
    return RecommendationFilterOptions(
      priority: clearPriority ? null : (priority ?? this.priority),
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
      isExecuted: clearExecuted ? null : (isExecuted ?? this.isExecuted),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Presentation state for AI Commander module.
class AICommanderState {
  final AICommanderViewStatus status;
  final String? errorMessage;
  final AICommanderSummary summary;
  final SituationSummary situationSummary;

  // Raw domain collections
  final List<IncidentAnalysis> allIncidents;
  final List<AIRecommendation> allRecommendations;
  final List<AIChatSession> allChatSessions;

  // Filtered views
  final List<IncidentAnalysis> filteredIncidents;
  final List<AIRecommendation> filteredRecommendations;

  // Active filters
  final IncidentFilterOptions incidentFilters;
  final RecommendationFilterOptions recommendationFilters;

  // Active selections
  final IncidentAnalysis? selectedIncident;
  final AIRecommendation? selectedRecommendation;
  final AIChatSession? activeChatSession;

  // Real-time Chat Flags
  final bool isSendingMessage;
  final bool isAnalyzing;
  final bool isExecuting;

  const AICommanderState({
    required this.status,
    this.errorMessage,
    required this.summary,
    required this.situationSummary,
    required this.allIncidents,
    required this.allRecommendations,
    required this.allChatSessions,
    required this.filteredIncidents,
    required this.filteredRecommendations,
    required this.incidentFilters,
    required this.recommendationFilters,
    this.selectedIncident,
    this.selectedRecommendation,
    this.activeChatSession,
    this.isSendingMessage = false,
    this.isAnalyzing = false,
    this.isExecuting = false,
  });

  factory AICommanderState.initial() => const AICommanderState(
        status: AICommanderViewStatus.initial,
        errorMessage: null,
        summary: AICommanderSummary.empty,
        situationSummary: SituationSummary(
          id: '',
          headline: '',
          incidentOverview: '',
          resourcesDeployed: [],
          emergingRisks: [],
          suggestedNextActions: [],
          generatedAt: null as dynamic,
          primaryDistrict: '',
          totalEvacuees: 0,
          activeMissions: 0,
        ),
        allIncidents: [],
        allRecommendations: [],
        allChatSessions: [],
        filteredIncidents: [],
        filteredRecommendations: [],
        incidentFilters: IncidentFilterOptions(),
        recommendationFilters: RecommendationFilterOptions(),
      );

  AICommanderState copyWith({
    AICommanderViewStatus? status,
    String? errorMessage,
    AICommanderSummary? summary,
    SituationSummary? situationSummary,
    List<IncidentAnalysis>? allIncidents,
    List<AIRecommendation>? allRecommendations,
    List<AIChatSession>? allChatSessions,
    List<IncidentAnalysis>? filteredIncidents,
    List<AIRecommendation>? filteredRecommendations,
    IncidentFilterOptions? incidentFilters,
    RecommendationFilterOptions? recommendationFilters,
    IncidentAnalysis? selectedIncident,
    AIRecommendation? selectedRecommendation,
    AIChatSession? activeChatSession,
    bool? isSendingMessage,
    bool? isAnalyzing,
    bool? isExecuting,
  }) {
    return AICommanderState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      summary: summary ?? this.summary,
      situationSummary: situationSummary ?? this.situationSummary,
      allIncidents: allIncidents ?? this.allIncidents,
      allRecommendations: allRecommendations ?? this.allRecommendations,
      allChatSessions: allChatSessions ?? this.allChatSessions,
      filteredIncidents: filteredIncidents ?? this.filteredIncidents,
      filteredRecommendations: filteredRecommendations ?? this.filteredRecommendations,
      incidentFilters: incidentFilters ?? this.incidentFilters,
      recommendationFilters: recommendationFilters ?? this.recommendationFilters,
      selectedIncident: selectedIncident ?? this.selectedIncident,
      selectedRecommendation: selectedRecommendation ?? this.selectedRecommendation,
      activeChatSession: activeChatSession ?? this.activeChatSession,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      isExecuting: isExecuting ?? this.isExecuting,
    );
  }
}
