import '../../domain/entities/ai_commander_entities.dart';
import '../../domain/repositories/ai_commander_repository.dart';
import '../datasources/ai_commander_mock_datasource.dart';

/// Concrete repository implementation for AI Commander backed by [AICommanderMockDatasource].
class AICommanderRepositoryImpl implements AICommanderRepository {
  final AICommanderMockDatasource _datasource;

  AICommanderRepositoryImpl([AICommanderMockDatasource? datasource])
      : _datasource = datasource ?? AICommanderMockDatasource();

  @override
  Future<AICommanderSummary> getCommanderSummary() async {
    await Future.delayed(const Duration(milliseconds: 120));
    return _datasource.getSummary();
  }

  @override
  Future<List<IncidentAnalysis>> getIncidentAnalyses({
    String? district,
    IncidentType? incidentType,
    IncidentSeverity? severity,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 160));
    var list = _datasource.incidentAnalyses.map((m) => m.toEntity()).toList();

    if (district != null && district.isNotEmpty && district != 'All') {
      list = list.where((i) => i.district.toLowerCase() == district.toLowerCase()).toList();
    }

    if (incidentType != null) {
      list = list.where((i) => i.incidentType == incidentType).toList();
    }

    if (severity != null) {
      list = list.where((i) => i.severity == severity).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((i) =>
          i.title.toLowerCase().contains(q) ||
          i.district.toLowerCase().contains(q) ||
          i.affectedArea.toLowerCase().contains(q) ||
          i.summaryNotes.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<IncidentAnalysis?> getIncidentAnalysisById(String id) async {
    await Future.delayed(const Duration(milliseconds: 90));
    try {
      return _datasource.incidentAnalyses.firstWhere((i) => i.id == id).toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<AIRecommendation>> getRecommendations({
    RecommendationPriority? priority,
    ExecutionDifficulty? difficulty,
    bool? isExecuted,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 140));
    var list = _datasource.recommendations.map((m) => m.toEntity()).toList();

    if (priority != null) {
      list = list.where((r) => r.priority == priority).toList();
    }

    if (difficulty != null) {
      list = list.where((r) => r.difficulty == difficulty).toList();
    }

    if (isExecuted != null) {
      list = list.where((r) => r.isExecuted == isExecuted).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((r) =>
          r.title.toLowerCase().contains(q) ||
          r.recommendation.toLowerCase().contains(q) ||
          r.reasoning.toLowerCase().contains(q) ||
          r.estimatedImpact.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<AIRecommendation> executeRecommendation(String id) async {
    await Future.delayed(const Duration(milliseconds: 180));
    return _datasource.executeRecommendation(id).toEntity();
  }

  @override
  Future<IncidentAnalysis> toggleActionItem({
    required String incidentId,
    required String actionItemId,
    required bool isCompleted,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _datasource.toggleActionItem(
      incidentId: incidentId,
      actionItemId: actionItemId,
      isCompleted: isCompleted,
    ).toEntity();
  }

  @override
  Future<SituationSummary> getSituationSummary({String? district}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.getSituationSummary(district: district);
  }

  @override
  Future<List<AIChatSession>> getChatSessions() async {
    await Future.delayed(const Duration(milliseconds: 120));
    return _datasource.chatSessions.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AIChatSession?> getChatSessionById(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 90));
    try {
      return _datasource.chatSessions.firstWhere((s) => s.id == sessionId).toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AIChatMessage> sendMessage({
    required String sessionId,
    required String promptText,
    String? relatedIncidentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _datasource.generateAIResponse(
      sessionId: sessionId,
      promptText: promptText,
      relatedIncidentId: relatedIncidentId,
    ).toEntity();
  }

  @override
  Future<AIChatSession> createChatSession({
    required String title,
    required String district,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _datasource.createSession(title: title, district: district).toEntity();
  }

  @override
  Future<bool> clearChatSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _datasource.clearSession(sessionId);
  }
}
