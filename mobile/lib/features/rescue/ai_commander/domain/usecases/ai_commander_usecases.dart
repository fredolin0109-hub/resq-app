import '../entities/ai_commander_entities.dart';
import '../repositories/ai_commander_repository.dart';

/// Fetch dashboard telemetry and AI health metrics.
class GetAICommanderSummaryUseCase {
  final AICommanderRepository repository;
  GetAICommanderSummaryUseCase(this.repository);

  Future<AICommanderSummary> call() async {
    return await repository.getCommanderSummary();
  }
}

/// Retrieve and filter incident analyses.
class GetIncidentAnalysesUseCase {
  final AICommanderRepository repository;
  GetIncidentAnalysesUseCase(this.repository);

  Future<List<IncidentAnalysis>> call({
    String? district,
    IncidentType? incidentType,
    IncidentSeverity? severity,
    String? searchQuery,
  }) async {
    return await repository.getIncidentAnalyses(
      district: district,
      incidentType: incidentType,
      severity: severity,
      searchQuery: searchQuery,
    );
  }

  Future<IncidentAnalysis?> getById(String id) async {
    return await repository.getIncidentAnalysisById(id);
  }
}

/// Retrieve and filter AI recommendations.
class GetAIRecommendationsUseCase {
  final AICommanderRepository repository;
  GetAIRecommendationsUseCase(this.repository);

  Future<List<AIRecommendation>> call({
    RecommendationPriority? priority,
    ExecutionDifficulty? difficulty,
    bool? isExecuted,
    String? searchQuery,
  }) async {
    return await repository.getRecommendations(
      priority: priority,
      difficulty: difficulty,
      isExecuted: isExecuted,
      searchQuery: searchQuery,
    );
  }
}

/// Execute or deploy an AI recommendation.
class ExecuteRecommendationUseCase {
  final AICommanderRepository repository;
  ExecuteRecommendationUseCase(this.repository);

  Future<AIRecommendation> call(String recommendationId) async {
    return await repository.executeRecommendation(recommendationId);
  }
}

/// Toggle action item completion in incident analysis.
class ToggleActionItemUseCase {
  final AICommanderRepository repository;
  ToggleActionItemUseCase(this.repository);

  Future<IncidentAnalysis> call({
    required String incidentId,
    required String actionItemId,
    required bool isCompleted,
  }) async {
    return await repository.toggleActionItem(
      incidentId: incidentId,
      actionItemId: actionItemId,
      isCompleted: isCompleted,
    );
  }
}

/// Retrieve disaster situation summary (SitRep).
class GetSituationSummaryUseCase {
  final AICommanderRepository repository;
  GetSituationSummaryUseCase(this.repository);

  Future<SituationSummary> call({String? district}) async {
    return await repository.getSituationSummary(district: district);
  }
}

/// Manage chat sessions and sending messages to AI Commander.
class SendAIChatMessageUseCase {
  final AICommanderRepository repository;
  SendAIChatMessageUseCase(this.repository);

  Future<AIChatMessage> call({
    required String sessionId,
    required String promptText,
    String? relatedIncidentId,
  }) async {
    return await repository.sendMessage(
      sessionId: sessionId,
      promptText: promptText,
      relatedIncidentId: relatedIncidentId,
    );
  }

  Future<List<AIChatSession>> getSessions() async {
    return await repository.getChatSessions();
  }

  Future<AIChatSession?> getSessionById(String sessionId) async {
    return await repository.getChatSessionById(sessionId);
  }

  Future<AIChatSession> createSession({
    required String title,
    required String district,
  }) async {
    return await repository.createChatSession(
      title: title,
      district: district,
    );
  }

  Future<bool> clearSession(String sessionId) async {
    return await repository.clearChatSession(sessionId);
  }
}
