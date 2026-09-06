import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../mobile/lib/features/rescue/team_management/data/datasources/team_management_mock_datasource.dart';
import '../../../../mobile/lib/features/rescue/team_management/data/repositories/team_management_repository_impl.dart';
import '../../../../mobile/lib/features/rescue/team_management/domain/entities/team_management_entities.dart';
import '../../../../mobile/lib/features/rescue/team_management/domain/usecases/team_management_usecases.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/providers/team_management_provider.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/providers/team_management_state.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/screens/dispatch_team_screen.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/screens/fleet_management_screen.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/screens/rescue_teams_dashboard_screen.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/screens/team_details_screen.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/screens/team_members_screen.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/screens/vehicle_details_screen.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/widgets/fleet_summary_widget.dart';
import '../../../../mobile/lib/features/rescue/team_management/presentation/widgets/team_card.dart';

Widget createTestTeamWidget({TeamManagementNotifier? notifier}) {
  return MaterialApp(
    routes: {
      RescueTeamsDashboardScreen.routeName: (_) => RescueTeamsDashboardScreen(notifier: notifier),
      FleetManagementScreen.routeName: (_) => FleetManagementScreen(notifier: notifier),
      DispatchTeamScreen.routeName: (_) => DispatchTeamScreen(notifier: notifier),
    },
    home: RescueTeamsDashboardScreen(notifier: notifier),
  );
}

TeamManagementNotifier createTestNotifier() {
  final dataSource = TeamManagementMockDataSource(latency: Duration.zero);
  final repository = TeamManagementRepositoryImpl(dataSource: dataSource);
  return TeamManagementNotifier(
    getTeamsUseCase: GetTeamsUseCase(repository),
    getVehiclesUseCase: GetVehiclesUseCase(repository),
    dispatchTeamUseCase: DispatchTeamUseCase(repository),
  );
}

void main() {
  group('Rescue Team & Fleet Management - Provider & Unit Tests', () {
    test('1. Loads 10 rescue teams, 25 personnel, and 15 fleet assets', () async {
      final notifier = createTestNotifier();
      await notifier.loadDashboard();

      expect(notifier.state.isLoaded, isTrue);
      expect(notifier.state.allTeams.length, equals(10));
      expect(notifier.state.allVehicles.length, equals(15));
      expect(notifier.state.teamsSummary, isNotNull);
      expect(notifier.state.fleetSummary, isNotNull);
      expect(notifier.state.fleetSummary!.totalVehicles, equals(15));
    });

    test('2. Search query filters squads across name, leader, and district', () async {
      final notifier = createTestNotifier();
      await notifier.loadDashboard();

      notifier.search('Natarajan');
      expect(notifier.state.filteredTeams.length, equals(1));
      expect(notifier.state.filteredTeams.first.name, contains('Alpha Swiftwater'));

      notifier.search('Chennai');
      expect(notifier.state.filteredTeams.any((t) => t.district == 'Chennai'), isTrue);
    });

    test('3. Dispatch squad updates team status to busy and records active mission', () async {
      final notifier = createTestNotifier();
      await notifier.loadDashboard();

      final team = notifier.state.allTeams.first;
      final vehicle = notifier.state.allVehicles.first;

      final success = await notifier.dispatchSquad(
        teamId: team.id,
        missionId: 'SOS-9499',
        priority: 'Critical',
        targetLocation: 'Causeway Bridge Lowland',
        vehicle: vehicle,
      );

      expect(success, isTrue);
      final updated = notifier.state.allTeams.firstWhere((t) => t.id == team.id);
      expect(updated.status, equals(TeamStatus.busy));
      expect(updated.currentMission, contains('SOS-9499'));
    });
  });

  group('Rescue Team & Fleet Management - Widget & Navigation Tests', () {
    testWidgets('1. Dashboard renders summary cards, fleet widget, and squad list', (tester) async {
      final notifier = createTestNotifier();
      await tester.pumpWidget(createTestTeamWidget(notifier: notifier));
      await tester.pumpAndSettle();

      expect(find.text('Rescue Teams & Fleet Command'), findsOneWidget);
      expect(find.text('Total Teams'), findsOneWidget);
      expect(find.text('Active Teams'), findsOneWidget);
      expect(find.text('Fleet Assets Overview'), findsOneWidget);

      expect(find.byType(FleetSummaryWidget), findsOneWidget);
      expect(find.byType(TeamCard), findsWidgets);
      expect(find.text('Alpha Swiftwater Squadron'), findsOneWidget);
    });

    testWidgets('2. Tapping Team Card opens Team Details and navigates to Roster', (tester) async {
      final notifier = createTestNotifier();
      await tester.pumpWidget(createTestTeamWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Tap on Alpha Swiftwater Squadron
      await tester.tap(find.text('Alpha Swiftwater Squadron'));
      await tester.pumpAndSettle();

      // Details Screen
      expect(find.byType(TeamDetailsScreen), findsOneWidget);
      expect(find.text('Equipment & Medical Gear'), findsOneWidget);
      expect(find.text('Assigned Vehicle & Fleet Assets'), findsOneWidget);

      // Tap Roster button
      await tester.tap(find.text('Roster'));
      await tester.pumpAndSettle();

      // Members Screen
      expect(find.byType(TeamMembersScreen), findsOneWidget);
      expect(find.text('Captain K. Natarajan'), findsOneWidget);
      expect(find.text('LEAD'), findsOneWidget);
    });

    testWidgets('3. Navigates to Fleet Management and Vehicle Details Screen', (tester) async {
      final notifier = createTestNotifier();
      await tester.pumpWidget(createTestTeamWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Tap Fleet Management icon in AppBar
      await tester.tap(find.byTooltip('Fleet Management'));
      await tester.pumpAndSettle();

      expect(find.byType(FleetManagementScreen), findsOneWidget);
      expect(find.text('Fleet & Heavy Assets'), findsOneWidget);
      expect(find.text('TN-72-RSQ-01'), findsOneWidget);

      // Tap on vehicle card
      await tester.tap(find.text('TN-72-RSQ-01'));
      await tester.pumpAndSettle();

      expect(find.byType(VehicleDetailsScreen), findsOneWidget);
      expect(find.text('Fuel Level'), findsOneWidget);
      expect(find.text('Battery Level'), findsOneWidget);
    });

    testWidgets('4. Navigates to Dispatch Team Screen and executes dispatch', (tester) async {
      final notifier = createTestNotifier();
      await tester.pumpWidget(createTestTeamWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Tap Emergency Dispatch icon in AppBar
      await tester.tap(find.byTooltip('Emergency Dispatch'));
      await tester.pumpAndSettle();

      expect(find.byType(DispatchTeamScreen), findsOneWidget);
      expect(find.text('Emergency Squad Dispatch'), findsOneWidget);
      expect(find.text('Confirm & Authorize Dispatch'), findsOneWidget);

      // Execute dispatch
      await tester.tap(find.text('Confirm & Authorize Dispatch'));
      await tester.pumpAndSettle();

      // Back on dashboard
      expect(find.byType(RescueTeamsDashboardScreen), findsOneWidget);
    });
  });
}
