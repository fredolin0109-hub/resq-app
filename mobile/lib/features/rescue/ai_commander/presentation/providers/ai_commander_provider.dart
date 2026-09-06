import 'package:flutter/foundation.dart';
import '../../data/datasources/ai_commander_mock_datasource.dart';
import '../../data/repositories/ai_commander_repository_impl.dart';
import '../../domain/entities/ai_commander_entities.dart';
import '../../domain/repositories/ai_commander_repository.dart';
import '../../domain/usecases/ai_commander_usecases.dart';
import 'ai_commander_state.dart';

/// Central state notifier managing AI Commander intelligence, recommendations, incident analyses, and interactive chat dialogues.
class AICommanderNotifier extends ChangeNotifier {
  final GetAICommanderSummaryUseCase _getSummaryUseCase;
  final GetIncidentAnalysesUseCase _getIncidentsUseCase;
  final GetAIRecommendationsUseCase _getRecommendationsUseCase;
  final ExecuteRecommendationUseCase _executeRecommendationUseCase;
  final ToggleActionItemUseCase _toggleActionItemUseCase;
  final GetSituationSummaryUseCase _getSituationSummaryUseCase;
  final SendAIChatMessageUseCase _chatUseCase;

  AICommanderState _state = AICommanderState.initial();

  AICommanderNotifier({
    required GetAICommanderSummaryUseCase getSummaryUseCase,
    required GetIncidentAnalysesUseCase getIncidentsUseCase,
    required GetAIRecommendationsUseCase getRecommendationsUseCase,
    required ExecuteRecommendationUseCase executeRecommendationUseCase,
    required ToggleActionItemUseCase toggleActionItemUseCase,
    required GetSituationSummaryUseCase getSituationSummaryUseCase,
    required SendAIChatMessageUseCase chatUseCase,
  })  : _getSummaryUseCase = getSummaryUseCase,
        _getIncidentsUseCase = getIncidentsUseCase,
        _getRecommendationsUseCase = getRecommendationsUseCase,
        _executeRecommendationUseCase = executeRecommendationUseCase,
        _toggleActionItemUseCase = toggleActionItemUseCase,
        _getSituationSummaryUseCase = getSituationSummaryUseCase,
        _chatUseCase = chatUseCase;

  AICommanderState get state => _state;

  /// Loads full AI intelligence dataset for dashboard.
  Future<void> loadDashboard() async {
    _state = _state.copyWith(status: AICommanderViewStatus.loading);
    notifyListeners();

    try {
      final summary = await _getSummaryUseCase();
      final incidents = await _getIncidentsUseCase();
      final recommendations = await _getRecommendationsUseCase();
      final sessions = await _chatUseCase.getSessions();
      final sitRep = await _getSituationSummaryUseCase();

      final filteredIncidents = _applyIncidentFilters(incidents, _state.incidentFilters);
      final filteredRecs = _applyRecommendationFilters(recommendations, _state.recommendationFilters);

      final activeSession = _state.activeChatSession ?? (sessions.isNotEmpty ? sessions.first : null);

      _state = _state.copyWith(
        status: AICommanderViewStatus.loaded,
        summary: summary,
        situationSummary: sitRep,
        allIncidents: incidents,
        filteredIncidents: filteredIncidents,
        allRecommendations: recommendations,
        filteredRecommendations: filteredRecs,
        allChatSessions: sessions,
        activeChatSession: activeSession,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: AICommanderViewStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
    }
  }

  // ===========================================================================
  // FILTER & SEARCH HANDLERS
  // ===========================================================================

  void updateIncidentFilters(IncidentFilterOptions opts) {
    _state = _state.copyWith(incidentFilters: opts);
    _reapplyIncidentFilters();
  }

  void searchIncidents(String query) {
    final opts = _state.incidentFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(incidentFilters: opts);
    _reapplyIncidentFilters();
  }

  void updateRecommendationFilters(RecommendationFilterOptions opts) {
    _state = _state.copyWith(recommendationFilters: opts);
    _reapplyRecommendationFilters();
  }

  void searchRecommendations(String query) {
    final opts = _state.recommendationFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(recommendationFilters: opts);
    _reapplyRecommendationFilters();
  }

  // ===========================================================================
  // SELECTION HANDLERS
  // ===========================================================================

  void selectIncident(IncidentAnalysis incident) {
    _state = _state.copyWith(selectedIncident: incident);
    notifyListeners();
  }

  void selectIncidentById(String id) {
    try {
      final inc = _state.allIncidents.firstWhere((i) => i.id == id);
      _state = _state.copyWith(selectedIncident: inc);
      notifyListeners();
    } catch (_) {}
  }

  void selectRecommendation(AIRecommendation rec) {
    _state = _state.copyWith(selectedRecommendation: rec);
    notifyListeners();
  }

  void selectChatSession(AIChatSession session) {
    _state = _state.copyWith(activeChatSession: session);
    notifyListeners();
  }

  // ===========================================================================
  // TACTICAL ACTIONS & MUTATIONS
  // ===========================================================================

  Future<bool> executeRecommendation(String id) async {
    _state = _state.copyWith(isExecuting: true);
    notifyListeners();

    try {
      final updated = await _executeRecommendationUseCase(id);
      final allRecs = _state.allRecommendations.map((r) => r.id == updated.id ? updated : r).toList();
      final filteredRecs = _applyRecommendationFilters(allRecs, _state.recommendationFilters);
      final summary = await _getSummaryUseCase();

      _state = _state.copyWith(
        isExecuting: false,
        allRecommendations: allRecs,
        filteredRecommendations: filteredRecs,
        selectedRecommendation: updated,
        summary: summary,
      );
      notifyListeners();
      return true;
    } catch (_) {
      _state = _state.copyWith(isExecuting: false);
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleActionItem({
    required String incidentId,
    required String actionItemId,
    required bool isCompleted,
  }) async {
    try {
      final updatedIncident = await _toggleActionItemUseCase(
        incidentId: incidentId,
        actionItemId: actionItemId,
        isCompleted: isCompleted,
      );

      final allInc = _state.allIncidents.map((i) => i.id == updatedIncident.id ? updatedIncident : i).toList();
      final filteredInc = _applyIncidentFilters(allInc, _state.incidentFilters);

      _state = _state.copyWith(
        allIncidents: allInc,
        filteredIncidents: filteredInc,
        selectedIncident: updatedIncident,
      );
      notifyListeners();
    } catch (_) {}
  }

  // ===========================================================================
  // CHAT ACTIONS
  // ===========================================================================

  Future<void> sendMessage(String text, {String? relatedIncidentId}) async {
    final session = _state.activeChatSession ?? (_state.allChatSessions.isNotEmpty ? _state.allChatSessions.first : null);
    if (session == null || text.trim().isEmpty) return;

    // Add immediate user message with typing state
    final tempUserMsg = AIChatMessage(
      id: 'TEMP-${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      sender: ChatSender.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...session.messages, tempUserMsg];
    final tempSession = AIChatSession(
      id: session.id,
      title: session.title,
      district: session.district,
      createdAt: session.createdAt,
      messages: updatedMessages,
    );

    _state = _state.copyWith(
      activeChatSession: tempSession,
      isSendingMessage: true,
    );
    notifyListeners();

    try {
      final aiReply = await _chatUseCase(
        sessionId: session.id,
        promptText: text,
        relatedIncidentId: relatedIncidentId,
      );

      final finalMessages = [...updatedMessages, aiReply];
      final finalSession = AIChatSession(
        id: session.id,
        title: session.title,
        district: session.district,
        createdAt: session.createdAt,
        messages: finalMessages,
      );

      final allSessions = _state.allChatSessions.map((s) => s.id == finalSession.id ? finalSession : s).toList();

      _state = _state.copyWith(
        isSendingMessage: false,
        activeChatSession: finalSession,
        allChatSessions: allSessions,
      );
      notifyListeners();
    } catch (_) {
      _state = _state.copyWith(isSendingMessage: false);
      notifyListeners();
    }
  }

  Future<AIChatSession> createNewChatSession({String title = '', String district = 'General'}) async {
    final newSession = await _chatUseCase.createSession(title: title, district: district);
    final allSessions = [newSession, ..._state.allChatSessions];

    _state = _state.copyWith(
      allChatSessions: allSessions,
      activeChatSession: newSession,
    );
    notifyListeners();
    return newSession;
  }

  Future<void> clearActiveChatSession() async {
    final current = _state.activeChatSession;
    if (current == null) return;

    await _chatUseCase.clearSession(current.id);
    final cleared = AIChatSession(
      id: current.id,
      title: current.title,
      district: current.district,
      createdAt: current.createdAt,
      messages: [],
    );

    final allSessions = _state.allChatSessions.map((s) => s.id == cleared.id ? cleared : s).toList();
    _state = _state.copyWith(
      activeChatSession: cleared,
      allChatSessions: allSessions,
    );
    notifyListeners();
  }

  // ===========================================================================
  // INTERNAL FILTER LOGIC
  // ===========================================================================

  void _reapplyIncidentFilters() {
    final filtered = _applyIncidentFilters(_state.allIncidents, _state.incidentFilters);
    _state = _state.copyWith(filteredIncidents: filtered);
    notifyListeners();
  }

  void _reapplyRecommendationFilters() {
    final filtered = _applyRecommendationFilters(_state.allRecommendations, _state.recommendationFilters);
    _state = _state.copyWith(filteredRecommendations: filtered);
    notifyListeners();
  }

  List<IncidentAnalysis> _applyIncidentFilters(List<IncidentAnalysis> list, IncidentFilterOptions opts) {
    return list.where((i) {
      if (opts.district != 'All' && i.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      if (opts.incidentType != null && i.incidentType != opts.incidentType) {
        return false;
      }
      if (opts.severity != null && i.severity != opts.severity) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = i.title.toLowerCase().contains(q) ||
            i.district.toLowerCase().contains(q) ||
            i.affectedArea.toLowerCase().contains(q) ||
            i.summaryNotes.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<AIRecommendation> _applyRecommendationFilters(List<AIRecommendation> list, RecommendationFilterOptions opts) {
    return list.where((r) {
      if (opts.priority != null && r.priority != opts.priority) {
        return false;
      }
      if (opts.difficulty != null && r.difficulty != opts.difficulty) {
        return false;
      }
      if (opts.isExecuted != null && r.isExecuted != opts.isExecuted) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = r.title.toLowerCase().contains(q) ||
            r.recommendation.toLowerCase().contains(q) ||
            r.reasoning.toLowerCase().contains(q) ||
            r.estimatedImpact.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }
}

/// Global dependency injection container for AI Commander module.
class AICommanderDependencies {
  static final AICommanderMockDatasource datasource = AICommanderMockDatasource();
  static final AICommanderRepository repository = AICommanderRepositoryImpl(datasource);

  static final GetAICommanderSummaryUseCase getSummaryUseCase = GetAICommanderSummaryUseCase(repository);
  static final GetIncidentAnalysesUseCase getIncidentsUseCase = GetIncidentAnalysesUseCase(repository);
  static final GetAIRecommendationsUseCase getRecommendationsUseCase = GetAIRecommendationsUseCase(repository);
  static final ExecuteRecommendationUseCase executeRecommendationUseCase = ExecuteRecommendationUseCase(repository);
  static final ToggleActionItemUseCase toggleActionItemUseCase = ToggleActionItemUseCase(repository);
  static final GetSituationSummaryUseCase getSituationSummaryUseCase = GetSituationSummaryUseCase(repository);
  static final SendAIChatMessageUseCase chatUseCase = SendAIChatMessageUseCase(repository);

  static final AICommanderNotifier notifier = AICommanderNotifier(
    getSummaryUseCase: getSummaryUseCase,
    getIncidentsUseCase: getIncidentsUseCase,
    getRecommendationsUseCase: getRecommendationsUseCase,
    executeRecommendationUseCase: executeRecommendationUseCase,
    toggleActionItemUseCase: toggleActionItemUseCase,
    getSituationSummaryUseCase: getSituationSummaryUseCase,
    chatUseCase: chatUseCase,
  );
}
