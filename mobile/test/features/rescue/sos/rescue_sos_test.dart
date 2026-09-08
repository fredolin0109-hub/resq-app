import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../mobile/lib/features/rescue/sos/data/datasources/sos_mock_datasource.dart';
import '../../../../mobile/lib/features/rescue/sos/data/repositories/sos_repository_impl.dart';
import '../../../../mobile/lib/features/rescue/sos/domain/entities/sos_incident_entity.dart';
import '../../../../mobile/lib/features/rescue/sos/domain/usecases/sos_usecases.dart';
import '../../../../mobile/lib/features/rescue/sos/presentation/providers/sos_provider.dart';
import '../../../../mobile/lib/features/rescue/sos/presentation/providers/sos_state.dart';
import '../../../../mobile/lib/features/rescue/sos/presentation/screens/assign_team_screen.dart';
import '../../../../mobile/lib/features/rescue/sos/presentation/screens/mission_history_screen.dart';
import '../../../../mobile/lib/features/rescue/sos/presentation/screens/mission_tracking_screen.dart';
import '../../../../mobile/lib/features/rescue/sos/presentation/screens/sos_dashboard_screen.dart';
import '../../../../mobile/lib/features/rescue/sos/presentation/screens/sos_details_screen.dart';
import '../../../../mobile/lib/features/rescue/sos/presentation/widgets/sos_incident_card.dart';
import '../../../../mobile/lib/features/rescue/sos/presentation/widgets/sos_summary_metric_card.dart';

Widget createTestSosWidget({SosNotifier? notifier}) {
  return MaterialApp(
    routes: {
      SosDashboardScreen.routeName: (_) => SosDashboardScreen(notifier: notifier),
      MissionHistoryScreen.routeName: (_) => MissionHistoryScreen(notifier: notifier),
    },
    home: SosDashboardScreen(notifier: notifier),
  );
}

SosNotifier createTestNotifier() {
  final dataSource = SosMockDataSource(latency: Duration.zero);
  final repository = SosRepositoryImpl(dataSource: dataSource);
  return SosNotifier(
    getIncidentsUseCase: GetSosIncidentsUseCase(repository),
    getTeamsUseCase: GetAvailableTeamsUseCase(repository),
    assignTeamUseCase: AssignTeamUseCase(repository),
    updateStatusUseCase: UpdateSosStatusUseCase(repository),
  );
}

void main() {
  group('Live SOS Command Center - Provider & Unit Tests', () {
    test('1. Loads 20+ incidents and calculates top metric counters', () async {
      final notifier = createTestNotifier();
      await notifier.loadSosData();

      expect(notifier.state.isLoaded, isTrue);
      expect(notifier.state.allIncidents.length, greaterThanOrEqualTo(20));
      expect(notifier.state.metrics, isNotNull);
      expect(notifier.state.metrics!.highPriority, greaterThan(0));
    });

    test('2. Search filters incidents across ID, civilian name, and district', () async {
      final notifier = createTestNotifier();
      await notifier.loadSosData();

      notifier.searchIncidents('Tirunelveli');
      expect(notifier.state.filteredIncidents.every((i) => i.district.contains('Tirunelveli') || i.emergencyType.contains('Tirunelveli')), isTrue);

      notifier.searchIncidents('SOS-9401');
      expect(notifier.state.filteredIncidents.length, equals(1));
      expect(notifier.state.filteredIncidents.first.id, equals('SOS-9401'));
    });

    test('3. Assign squad updates incident status and appends timeline milestone', () async {
      final notifier = createTestNotifier();
      await notifier.loadSosData();

      final incident = notifier.state.allIncidents.first;
      final team = notifier.state.availableTeams.first;

      final success = await notifier.assignTeam(incident.id, team);
      expect(success, isTrue);

      final updated = notifier.state.allIncidents.firstWhere((i) => i.id == incident.id);
      expect(updated.status, equals(SosStatus.assigned));
      expect(updated.assignedTeam?.id, equals(team.id));
      expect(updated.timeline.any((t) => t.status == SosStatus.assigned), isTrue);
    });

    test('4. Status progression advances lifecycle to onScene and rescueCompleted', () async {
      final notifier = createTestNotifier();
      await notifier.loadSosData();

      final incident = notifier.state.allIncidents.first;

      await notifier.advanceStatus(incident.id, SosStatus.onScene, note: 'Squad arrived at bridge');
      var updated = notifier.state.allIncidents.firstWhere((i) => i.id == incident.id);
      expect(updated.status, equals(SosStatus.onScene));

      await notifier.advanceStatus(incident.id, SosStatus.rescueCompleted);
      updated = notifier.state.allIncidents.firstWhere((i) => i.id == incident.id);
      expect(updated.status, equals(SosStatus.rescueCompleted));
    });
  });

  group('Live SOS Command Center - Widget & Navigation Tests', () {
    testWidgets('1. Dashboard renders AppBar, Summary Metric Cards, and Incident List', (tester) async {
      final notifier = createTestNotifier();
      await tester.pumpWidget(createTestSosWidget(notifier: notifier));
      await tester.pumpAndSettle();

      expect(find.text('Live SOS Command Center'), findsOneWidget);
      expect(find.byType(SosSummaryMetricCard), findsNWidgets(5));
      expect(find.text('New Alerts'), findsOneWidget);
      expect(find.text('En Route'), findsOneWidget);
      expect(find.text('Resolved'), findsOneWidget);

      // Verify SOS incident cards render
      expect(find.byType(SosIncidentCard), findsWidgets);
      expect(find.text('SOS-9401'), findsOneWidget);
      expect(find.text('Ramesh Sundaram'), findsOneWidget);
    });

    testWidgets('2. Tapping SOS card navigates to SOS Details screen', (tester) async {
      final notifier = createTestNotifier();
      await tester.pumpWidget(createTestSosWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Tap first SOS incident card
      await tester.tap(find.text('SOS-9401'));
      await tester.pumpAndSettle();

      // Should be on SOS Details Screen
      expect(find.byType(SosDetailsScreen), findsOneWidget);
      expect(find.text('Civilian Information'), findsOneWidget);
      expect(find.text('Location & Risk Telemetry'), findsOneWidget);
      expect(find.text('Assigned Rescue Squad'), findsOneWidget);
      expect(find.text('Live Tracking'), findsOneWidget);
    });

    testWidgets('3. Navigates from Details to Assign Squad and Mission Tracking screen', (tester) async {
      final notifier = createTestNotifier();
      await tester.pumpWidget(createTestSosWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Open details
      await tester.tap(find.text('SOS-9401'));
      await tester.pumpAndSettle();

      // Tap Assign / Reassign button
      await tester.tap(find.text('Assign / Reassign'));
      await tester.pumpAndSettle();

      // Should be on Assign Team Screen
      expect(find.byType(AssignTeamScreen), findsOneWidget);
      expect(find.text('Assign Rescue Squad'), findsOneWidget);
      expect(find.text('Alpha Swiftwater Squadron 1'), findsOneWidget);

      // Tap Assign button for first squad
      await tester.tap(find.text('Assign & Deploy Unit').first);
      await tester.pumpAndSettle();

      // Should redirect to Mission Tracking Screen
      expect(find.byType(MissionTrackingScreen), findsOneWidget);
      expect(find.text('Live Tracking • SOS-9401'), findsOneWidget);
      expect(find.text('Mission Lifecycle Timeline'), findsOneWidget);
    });

    testWidgets('4. Mission History archive screen opens and renders completed missions', (tester) async {
      final notifier = createTestNotifier();
      await tester.pumpWidget(createTestSosWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Tap History icon in AppBar
      await tester.tap(find.byTooltip('Mission History'));
      await tester.pumpAndSettle();

      // Should be on Mission History Screen
      expect(find.byType(MissionHistoryScreen), findsOneWidget);
      expect(find.text('Mission History & Archives'), findsOneWidget);
      expect(find.text('All Districts'), findsOneWidget);
    });
  });
}
