import '../entities/ai_commander_entities.dart';

/// Abstract repository contract for AI Commander intelligence, analyses, recommendations, and tactical chat sessions.
abstract class AICommanderRepository {
  /// Fetch summary statistics for the AI Commander dashboard.
  Future<AICommanderSummary> getCommanderSummary();

  /// Retrieve all incident analyses, optionally filtered by district, incident type, or severity.
  Future<List<IncidentAnalysis>> getIncidentAnalyses({
    String? district,
    IncidentType? incidentType,
    IncidentSeverity? severity,
    String? searchQuery,
  });

  /// Retrieve a specific incident analysis by its unique ID.
  Future<IncidentAnalysis?> getIncidentAnalysisById(String id);

  /// Retrieve all AI recommendations, optionally filtered by priority or execution status.
  Future<List<AIRecommendation>> getRecommendations({
    RecommendationPriority? priority,
    ExecutionDifficulty? difficulty,
    bool? isExecuted,
    String? searchQuery,
  });

  /// Mark an AI recommendation as executed or applied in field.
  Future<AIRecommendation> executeRecommendation(String id);

  /// Toggle or update the completion of an action item within an incident analysis.
  Future<IncidentAnalysis> toggleActionItem({
    required String incidentId,
    required String actionItemId,
    required bool isCompleted,
  });

  /// Generate or fetch the latest disaster situation summary (SitRep).
  Future<SituationSummary> getSituationSummary({String? district});

  /// Retrieve all tactical chat sessions.
  Future<List<AIChatSession>> getChatSessions();

  /// Retrieve a specific chat session with its messages.
  Future<AIChatSession?> getChatSessionById(String sessionId);

  /// Send a prompt message and receive simulated AI tactical response.
  Future<AIChatMessage> sendMessage({
    required String sessionId,
    required String promptText,
    String? relatedIncidentId,
  });

  /// Create a new interactive chat session.
  Future<AIChatSession> createChatSession({
    required String title,
    required String district,
  });

  /// Clear or reset a chat session history.
  Future<bool> clearChatSession(String sessionId);
}
