import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../mobile/lib/features/rescue/data/datasources/rescue_dashboard_mock_datasource.dart';
import '../../../../mobile/lib/features/rescue/data/repositories/rescue_dashboard_repository_impl.dart';
import '../../../../mobile/lib/features/rescue/domain/usecases/get_rescue_dashboard_data_usecase.dart';
import '../../../../mobile/lib/features/rescue/presentation/providers/rescue_dashboard_provider.dart';
import '../../../../mobile/lib/features/rescue/presentation/providers/rescue_dashboard_state.dart';
import '../../../../mobile/lib/features/rescue/presentation/screens/rescue_dashboard_screen.dart';
import '../../../../mobile/lib/features/rescue/presentation/widgets/dashboard_empty_view.dart';
import '../../../../mobile/lib/features/rescue/presentation/widgets/dashboard_error_view.dart';
import '../../../../mobile/lib/features/rescue/presentation/widgets/dashboard_skeleton_loader.dart';
import '../../../../mobile/lib/features/rescue/presentation/widgets/greeting_card.dart';
import '../../../../mobile/lib/features/rescue/presentation/widgets/mission_summary_card.dart';
import '../../../../mobile/lib/features/rescue/presentation/widgets/quick_action_card.dart';
import '../../../../mobile/lib/features/rescue/presentation/widgets/system_status_card.dart';
import '../../../../mobile/lib/features/rescue/presentation/widgets/weather_card.dart';

Widget createTestDashboardWidget({
  RescueDashboardNotifier? notifier,
}) {
  return MaterialApp(
    home: RescueDashboardScreen(
      notifier: notifier,
    ),
  );
}

void main() {
  group('Rescue Mission Dashboard - Widget Tests', () {
    testWidgets('1. Dashboard loads and displays main header and telemetry sections', (tester) async {
      final mockDataSource = const RescueDashboardMockDataSource(
        simulatedDelay: Duration.zero,
      );
      final repository = RescueDashboardRepositoryImpl(dataSource: mockDataSource);
      final useCase = GetRescueDashboardDataUseCase(repository);
      final notifier = RescueDashboardNotifier(useCase);

      await tester.pumpWidget(createTestDashboardWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Check AppBar Title
      expect(find.text('Rescue Mission Command'), findsOneWidget);

      // Check Greeting Card
      expect(find.byType(GreetingCard), findsOneWidget);
      expect(find.text('Commander Sarah Connor'), findsOneWidget);
      expect(find.text('District Control Officer'), findsOneWidget);
      expect(find.text('ONLINE'), findsOneWidget);

      // Check Section Headers
      expect(find.text('Operational Overview'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Live Emergency Feed'), findsOneWidget);

      // Check Weather & System Health
      expect(find.byType(WeatherCard), findsOneWidget);
      expect(find.byType(SystemStatusCard), findsOneWidget);
      expect(find.text('Tactical Weather'), findsOneWidget);
      expect(find.text('System & Mesh Health'), findsOneWidget);
    });

    testWidgets('2. Mission summary cards and counts are visible', (tester) async {
      final mockDataSource = const RescueDashboardMockDataSource(
        simulatedDelay: Duration.zero,
      );
      final notifier = RescueDashboardNotifier(
        GetRescueDashboardDataUseCase(RescueDashboardRepositoryImpl(dataSource: mockDataSource)),
      );

      await tester.pumpWidget(createTestDashboardWidget(notifier: notifier));
      await tester.pumpAndSettle();

      expect(find.byType(MissionSummaryCard), findsNWidgets(4));
      expect(find.text('Active Missions'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);

      expect(find.text('Pending SOS'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);

      expect(find.text('Rescue Teams'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);

      expect(find.text('Available Resources'), findsOneWidget);
      expect(find.text('38'), findsOneWidget);
    });

    testWidgets('3. Quick Actions and Bottom Navigation trigger subpage transitions', (tester) async {
      final mockDataSource = const RescueDashboardMockDataSource(
        simulatedDelay: Duration.zero,
      );
      final notifier = RescueDashboardNotifier(
        GetRescueDashboardDataUseCase(RescueDashboardRepositoryImpl(dataSource: mockDataSource)),
      );

      await tester.pumpWidget(createTestDashboardWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Verify 8 quick action cards exist
      expect(find.byType(QuickActionCard), findsNWidgets(8));

      // Tap 'Mission Map' quick action
      await tester.tap(find.text('Mission Map').first);
      await tester.pumpAndSettle();

      // Should be on Mission Map placeholder
      expect(find.text('Route: /rescue/map'), findsOneWidget);

      // Tap Back to Dashboard
      await tester.tap(find.text('Back to Dashboard'));
      await tester.pumpAndSettle();

      // Back on Dashboard
      expect(find.text('Rescue Mission Command'), findsOneWidget);

      // Tap Bottom Navigation item 'SOS'
      await tester.tap(find.text('SOS'));
      await tester.pumpAndSettle();

      expect(find.text('Route: /rescue/alerts'), findsOneWidget);
    });

    testWidgets('4. Loading state displays Skeleton Loader', (tester) async {
      final mockDataSource = const RescueDashboardMockDataSource(
        simulatedDelay: Duration(seconds: 2),
      );
      final notifier = RescueDashboardNotifier(
        GetRescueDashboardDataUseCase(RescueDashboardRepositoryImpl(dataSource: mockDataSource)),
      );

      await tester.pumpWidget(createTestDashboardWidget(notifier: notifier));
      await tester.pump(); // Start async fetch

      // Skeleton loader should be active while loading
      expect(find.byType(DashboardSkeletonLoader), findsOneWidget);

      await tester.pumpAndSettle(); // Complete simulated delay
      expect(find.byType(DashboardSkeletonLoader), findsNothing);
    });

    testWidgets('5. Empty state displays friendly illustration and "No active incidents"', (tester) async {
      final mockDataSource = const RescueDashboardMockDataSource(
        simulatedDelay: Duration.zero,
        simulateEmpty: true,
      );
      final notifier = RescueDashboardNotifier(
        GetRescueDashboardDataUseCase(RescueDashboardRepositoryImpl(dataSource: mockDataSource)),
      );

      await tester.pumpWidget(createTestDashboardWidget(notifier: notifier));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardEmptyView), findsOneWidget);
      expect(find.text('No active incidents'), findsOneWidget);
      expect(find.text('Refresh Telemetry'), findsOneWidget);
    });

    testWidgets('6. Error state displays error view and retry button', (tester) async {
      final mockDataSource = const RescueDashboardMockDataSource(
        simulatedDelay: Duration.zero,
        simulateError: true,
      );
      final notifier = RescueDashboardNotifier(
        GetRescueDashboardDataUseCase(RescueDashboardRepositoryImpl(dataSource: mockDataSource)),
      );

      await tester.pumpWidget(createTestDashboardWidget(notifier: notifier));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardErrorView), findsOneWidget);
      expect(find.text('Unable to Load Mission Data'), findsOneWidget);
      expect(find.text('Retry Connection'), findsOneWidget);
    });
  });
}
