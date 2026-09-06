import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/features/rescue/ai_commander/data/datasources/ai_commander_mock_datasource.dart';
import '../../../../lib/features/rescue/ai_commander/data/models/ai_commander_models.dart';
import '../../../../lib/features/rescue/ai_commander/data/repositories/ai_commander_repository_impl.dart';
import '../../../../lib/features/rescue/ai_commander/domain/entities/ai_commander_entities.dart';
import '../../../../lib/features/rescue/ai_commander/domain/usecases/ai_commander_usecases.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/providers/ai_commander_provider.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/providers/ai_commander_state.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/screens/ai_chat_screen.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/screens/ai_commander_dashboard_screen.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/screens/ai_recommendations_screen.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/screens/incident_analysis_screen.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/screens/situation_summary_screen.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/widgets/ai_summary_card.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/widgets/ai_typing_indicator.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/widgets/chat_bubble_widget.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/widgets/incident_analysis_card.dart';
import '../../../../lib/features/rescue/ai_commander/presentation/widgets/recommendation_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AI Commander Domain & Enums Tests', () {
    test('IncidentSeverity colors map to disaster standards', () {
      expect(IncidentSeverity.low.color, const Color(0xFF10B981));
      expect(IncidentSeverity.moderate.color, const Color(0xFF3B82F6));
      expect(IncidentSeverity.high.color, const Color(0xFFF59E0B));
      expect(IncidentSeverity.critical.color, const Color(0xFFF97316));
      expect(IncidentSeverity.catastrophic.color, const Color(0xFFEF4444));
    });

    test('RecommendationPriority colors and display names', () {
      expect(RecommendationPriority.immediate.displayName, 'Immediate Action');
      expect(RecommendationPriority.immediate.color, const Color(0xFFEF4444));

      expect(RecommendationPriority.high.displayName, 'High Priority');
      expect(RecommendationPriority.high.color, const Color(0xFFF97316));

      expect(RecommendationPriority.advisory.displayName, 'Advisory');
      expect(RecommendationPriority.advisory.color, const Color(0xFF3B82F6));
    });

    test('IncidentType icons map correctly', () {
      expect(IncidentType.flood.icon, Icons.flood_rounded);
      expect(IncidentType.cyclone.icon, Icons.cyclone_rounded);
      expect(IncidentType.landslide.icon, Icons.landslide_rounded);
    });
  });

  group('AI Commander Data Models & Serialization Tests', () {
    test('AIRecommendationModel serializes and deserializes correctly', () {
      final now = DateTime.now();
      final model = AIRecommendationModel(
        id: 'REC-TEST',
        incidentId: 'INC-01',
        title: 'Test Directive',
        recommendation: 'Deploy boats to sector 4',
        reasoning: 'Water rising rapidly',
        estimatedImpact: 'Saves 200 civilians',
        priority: RecommendationPriority.immediate,
        difficulty: ExecutionDifficulty.moderate,
        requiredResources: const ['2x Boats'],
        timestamp: now,
        isExecuted: false,
      );

      final json = model.toJson();
      final parsed = AIRecommendationModel.fromJson(json);

      expect(parsed.id, 'REC-TEST');
      expect(parsed.title, 'Test Directive');
      expect(parsed.priority, RecommendationPriority.immediate);
      expect(parsed.difficulty, ExecutionDifficulty.moderate);
      expect(parsed.requiredResources.length, 1);
    });

    test('IncidentAnalysisModel serializes and deserializes correctly', () {
      final now = DateTime.now();
      final model = IncidentAnalysisModel(
        id: 'INC-TEST',
        title: 'Flash Flood Analysis',
        incidentType: IncidentType.flood,
        severity: IncidentSeverity.critical,
        district: 'Tirunelveli',
        affectedArea: 'Vannarpettai',
        estimatedPopulation: 12000,
        riskScore: 92,
        aiConfidence: 0.95,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-1', action: 'Cut Power', responsibleUnit: 'TNEB', isCompleted: false),
        ],
        environmentalFactors: const ['Rain: 200mm'],
        analyzedAt: now,
        summaryNotes: 'Flood breach',
        latitude: 8.72,
        longitude: 77.73,
      );

      final json = model.toJson();
      final parsed = IncidentAnalysisModel.fromJson(json);

      expect(parsed.id, 'INC-TEST');
      expect(parsed.riskScore, 92);
      expect(parsed.confidencePercent, 95);
      expect(parsed.recommendedActions.length, 1);
    });
  });

  group('AI Commander Mock Datasource Completeness Tests', () {
    final ds = AICommanderMockDatasource();

    test('Contains at least 20 tactical AI recommendations', () {
      expect(ds.recommendations.length, greaterThanOrEqualTo(20));
      final immediateRecs = ds.recommendations.where((r) => r.priority == RecommendationPriority.immediate).toList();
      expect(immediateRecs.isNotEmpty, isTrue);
    });

    test('Contains at least 10 multi-sensor incident analyses', () {
      expect(ds.incidentAnalyses.length, greaterThanOrEqualTo(10));
      final floods = ds.incidentAnalyses.where((i) => i.incidentType == IncidentType.flood).toList();
      expect(floods.isNotEmpty, isTrue);
    });

    test('Contains at least 15 interactive chat sessions', () {
      expect(ds.chatSessions.length, greaterThanOrEqualTo(15));
      final totalMessages = ds.chatSessions.fold(0, (sum, s) => sum + s.messages.length);
      expect(totalMessages, greaterThanOrEqualTo(25));
    });

    test('Computes AI Commander summary metrics accurately', () {
      final summary = ds.getSummary();
      expect(summary.activeAISessions, greaterThanOrEqualTo(15));
      expect(summary.incidentsAnalyzed, greaterThanOrEqualTo(10));
      expect(summary.recommendationsGenerated, greaterThanOrEqualTo(20));
      expect(summary.averageConfidence, greaterThan(0.8));
    });

    test('Generates Situation Summary report (SitRep)', () {
      final sitRep = ds.getSituationSummary();
      expect(sitRep.headline.isNotEmpty, isTrue);
      expect(sitRep.resourcesDeployed.isNotEmpty, isTrue);
      expect(sitRep.emergingRisks.isNotEmpty, isTrue);
      expect(sitRep.suggestedNextActions.isNotEmpty, isTrue);
    });
  });

  group('Repository & Use Cases Tests', () {
    late AICommanderRepository repo;

    setUp(() {
      repo = AICommanderRepositoryImpl(AICommanderMockDatasource());
    });

    test('GetIncidentAnalysesUseCase filters by district and severity', () async {
      final usecase = GetIncidentAnalysesUseCase(repo);
      final tirunelveli = await usecase(district: 'Tirunelveli');
      expect(tirunelveli.every((i) => i.district == 'Tirunelveli'), isTrue);

      final critical = await usecase(severity: IncidentSeverity.critical);
      expect(critical.every((i) => i.severity == IncidentSeverity.critical), isTrue);
    });

    test('ExecuteRecommendationUseCase marks recommendation executed', () async {
      final usecase = ExecuteRecommendationUseCase(repo);
      final rec = await usecase('REC-003');
      expect(rec.id, 'REC-003');
      expect(rec.isExecuted, isTrue);
    });

    test('ToggleActionItemUseCase toggles completion flag', () async {
      final usecase = ToggleActionItemUseCase(repo);
      final updated = await usecase(
        incidentId: 'INC-2026-001',
        actionItemId: 'ACT-03',
        isCompleted: true,
      );

      final act = updated.recommendedActions.firstWhere((a) => a.id == 'ACT-03');
      expect(act.isCompleted, isTrue);
    });

    test('SendAIChatMessageUseCase generates simulated AI response', () async {
      final usecase = SendAIChatMessageUseCase(repo);
      final reply = await usecase(
        sessionId: 'CHAT-01',
        promptText: 'Analyze flood risk for Tirunelveli',
      );

      expect(reply.sender, ChatSender.aiCommander);
      expect(reply.text.contains('AI Flood Risk Analysis'), isTrue);
    });
  });

  group('AICommanderNotifier Presentation State Tests', () {
    late AICommanderNotifier notifier;

    setUp(() {
      final ds = AICommanderMockDatasource();
      final repo = AICommanderRepositoryImpl(ds);
      notifier = AICommanderNotifier(
        getSummaryUseCase: GetAICommanderSummaryUseCase(repo),
        getIncidentsUseCase: GetIncidentAnalysesUseCase(repo),
        getRecommendationsUseCase: GetAIRecommendationsUseCase(repo),
        executeRecommendationUseCase: ExecuteRecommendationUseCase(repo),
        toggleActionItemUseCase: ToggleActionItemUseCase(repo),
        getSituationSummaryUseCase: GetSituationSummaryUseCase(repo),
        chatUseCase: SendAIChatMessageUseCase(repo),
      );
    });

    test('loadDashboard sets status to loaded with full collections', () async {
      await notifier.loadDashboard();
      expect(notifier.state.status, AICommanderViewStatus.loaded);
      expect(notifier.state.allIncidents.length, greaterThanOrEqualTo(10));
      expect(notifier.state.allRecommendations.length, greaterThanOrEqualTo(20));
      expect(notifier.state.allChatSessions.length, greaterThanOrEqualTo(15));
    });

    test('searchIncidents filters the incident list', () async {
      await notifier.loadDashboard();
      notifier.searchIncidents('Velachery');
      expect(notifier.state.filteredIncidents.length, 1);
      expect(notifier.state.filteredIncidents.first.title.contains('Velachery'), isTrue);
    });

    test('sendMessage adds user prompt and AI response to session', () async {
      await notifier.loadDashboard();
      final initialCount = notifier.state.activeChatSession?.messages.length ?? 0;

      await notifier.sendMessage('Suggest evacuation plan');

      final finalCount = notifier.state.activeChatSession?.messages.length ?? 0;
      expect(finalCount, initialCount + 2); // 1 User + 1 AI
    });
  });

  group('Widget and Screen Rendering Tests', () {
    testWidgets('AISummaryCard renders title and counter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AISummaryCard(
              title: 'Active Sessions',
              value: '15 Active',
              subtitle: 'Tactical Dialogues',
              icon: Icons.chat_rounded,
              color: Colors.indigo,
            ),
          ),
        ),
      );

      expect(find.text('Active Sessions'), findsOneWidget);
      expect(find.text('15 Active'), findsOneWidget);
    });

    testWidgets('AITypingIndicator renders animation dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AITypingIndicator(),
          ),
        ),
      );

      expect(find.text('AI Commander synthesizing telemetry'), findsOneWidget);
    });

    testWidgets('ChatBubbleWidget renders AI message and suggestion chips', (tester) async {
      final msg = AIChatMessage(
        id: 'MSG-01',
        text: 'AI Tactical Analysis ready.',
        sender: ChatSender.aiCommander,
        timestamp: DateTime.now(),
        actionSuggestions: const ['Analyze flood risk', 'Suggest evacuation plan'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubbleWidget(message: msg),
          ),
        ),
      );

      expect(find.text('AI COMMANDER'), findsOneWidget);
      expect(find.text('AI Tactical Analysis ready.'), findsOneWidget);
      expect(find.text('Analyze flood risk'), findsOneWidget);
      expect(find.text('Suggest evacuation plan'), findsOneWidget);
    });

    testWidgets('RecommendationCard renders recommendation and reasoning', (tester) async {
      final rec = AIRecommendation(
        id: 'REC-01',
        incidentId: 'INC-01',
        title: 'Pre-position Boats',
        recommendation: 'Position 6 rescue boats at bridge quadrant.',
        reasoning: 'Water rising 12cm/hr.',
        estimatedImpact: 'Saves 500 people.',
        priority: RecommendationPriority.immediate,
        difficulty: ExecutionDifficulty.moderate,
        requiredResources: const ['6x Boats'],
        timestamp: DateTime.now(),
        isExecuted: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecommendationCard(recommendation: rec),
          ),
        ),
      );

      expect(find.text('Pre-position Boats'), findsOneWidget);
      expect(find.text('IMMEDIATE ACTION'), findsOneWidget);
      expect(find.text('AI TACTICAL REASONING'), findsOneWidget);
    });

    testWidgets('AICommanderDashboardScreen renders with loaded state', (tester) async {
      final ds = AICommanderMockDatasource();
      final repo = AICommanderRepositoryImpl(ds);
      final notifier = AICommanderNotifier(
        getSummaryUseCase: GetAICommanderSummaryUseCase(repo),
        getIncidentsUseCase: GetIncidentAnalysesUseCase(repo),
        getRecommendationsUseCase: GetAIRecommendationsUseCase(repo),
        executeRecommendationUseCase: ExecuteRecommendationUseCase(repo),
        toggleActionItemUseCase: ToggleActionItemUseCase(repo),
        getSituationSummaryUseCase: GetSituationSummaryUseCase(repo),
        chatUseCase: SendAIChatMessageUseCase(repo),
      );

      await notifier.loadDashboard();

      await tester.pumpWidget(
        MaterialApp(
          home: AICommanderDashboardScreen(notifier: notifier),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('AI Mission Commander'), findsOneWidget);
      expect(find.text('Direct Tactical Prompts'), findsOneWidget);
      expect(find.text('Active AI Sessions'), findsOneWidget);
      expect(find.text('Incidents Analyzed'), findsOneWidget);
    });
  });
}
