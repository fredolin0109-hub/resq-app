import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../mobile/lib/features/rescue/map/data/datasources/rescue_map_mock_datasource.dart';
import '../../../../mobile/lib/features/rescue/map/data/repositories/rescue_map_repository_impl.dart';
import '../../../../mobile/lib/features/rescue/map/domain/usecases/get_tamil_nadu_cities_usecase.dart';
import '../../../../mobile/lib/features/rescue/map/presentation/providers/rescue_map_provider.dart';
import '../../../../mobile/lib/features/rescue/map/presentation/providers/rescue_map_state.dart';
import '../../../../mobile/lib/features/rescue/map/presentation/screens/rescue_map_screen.dart';
import '../../../../mobile/lib/features/rescue/map/presentation/widgets/city_search_widget.dart';
import '../../../../mobile/lib/features/rescue/map/presentation/widgets/location_information_panel.dart';
import '../../../../mobile/lib/features/rescue/map/presentation/widgets/map_controls_widget.dart';
import '../../../../mobile/lib/features/rescue/map/presentation/widgets/map_filter_panel.dart';
import '../../../../mobile/lib/features/rescue/map/presentation/widgets/risk_circle_layer.dart';
import '../../../../mobile/lib/features/rescue/map/presentation/widgets/risk_legend_widget.dart';

Widget createTestMapWidget({RescueMapNotifier? notifier}) {
  return MaterialApp(
    home: RescueMapScreen(
      notifier: notifier,
    ),
  );
}

void main() {
  group('Rescue Mission Command Map - Widget Tests', () {
    testWidgets('1. Map loads with Tamil Nadu cities, Search Box, Controls, and Legend', (tester) async {
      final mockDataSource = const RescueMapMockDataSource(latency: Duration.zero);
      final repository = RescueMapRepositoryImpl(dataSource: mockDataSource);
      final useCase = GetTamilNaduCitiesUseCase(repository);
      final notifier = RescueMapNotifier(useCase);

      await tester.pumpWidget(createTestMapWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Check AppBar Title
      expect(find.text('Tamil Nadu Mission Command Map'), findsOneWidget);

      // Check Core Widgets
      expect(find.byType(CitySearchWidget), findsOneWidget);
      expect(find.byType(RiskLegendWidget), findsOneWidget);
      expect(find.byType(MapControlsWidget), findsOneWidget);
      expect(find.byType(RiskCircleLayer), findsOneWidget);

      // Check Legend Labels
      expect(find.text('Safe'), findsOneWidget);
      expect(find.text('Moderate'), findsOneWidget);
      expect(find.text('High Risk'), findsOneWidget);
    });

    testWidgets('2. Risk circles render for Tamil Nadu cities including Palani, Madurai, and Chennai', (tester) async {
      final mockDataSource = const RescueMapMockDataSource(latency: Duration.zero);
      final notifier = RescueMapNotifier(
        GetTamilNaduCitiesUseCase(RescueMapRepositoryImpl(dataSource: mockDataSource)),
      );

      await tester.pumpWidget(createTestMapWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Verify specific city badges appear on the map
      expect(find.text('Palani'), findsOneWidget);
      expect(find.text('Madurai'), findsOneWidget);
      expect(find.text('Chennai'), findsOneWidget);
      expect(find.text('Coimbatore'), findsOneWidget);
      expect(find.text('Tirunelveli'), findsOneWidget);
    });

    testWidgets('3. City Search Autocomplete filters and triggers city selection', (tester) async {
      final mockDataSource = const RescueMapMockDataSource(latency: Duration.zero);
      final notifier = RescueMapNotifier(
        GetTamilNaduCitiesUseCase(RescueMapRepositoryImpl(dataSource: mockDataSource)),
      );

      await tester.pumpWidget(createTestMapWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Enter search query "Palani" into the search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Palani');
      await tester.pumpAndSettle();

      // Autocomplete option should be visible
      expect(find.text('Palani, Dindigul'), findsOneWidget);

      // Tap autocomplete suggestion
      await tester.tap(find.text('Palani, Dindigul'));
      await tester.pumpAndSettle();

      // State should have selected Palani
      expect(notifier.state.selectedCity?.name, equals('Palani'));
      expect(find.byType(LocationInformationPanel), findsOneWidget);
    });

    testWidgets('4. Clicking a city opens Location Information Panel with telemetry details', (tester) async {
      final mockDataSource = const RescueMapMockDataSource(latency: Duration.zero);
      final notifier = RescueMapNotifier(
        GetTamilNaduCitiesUseCase(RescueMapRepositoryImpl(dataSource: mockDataSource)),
      );

      await tester.pumpWidget(createTestMapWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Tap on Madurai city node
      await tester.tap(find.text('Madurai'));
      await tester.pumpAndSettle();

      // Location Information Panel must open
      expect(find.byType(LocationInformationPanel), findsOneWidget);
      expect(find.text('Madurai District • Vaigai Riverfront & Central'), findsOneWidget);
      expect(find.text('Population'), findsOneWidget);
      expect(find.text('Weather'), findsOneWidget);
      expect(find.text('Navigate'), findsOneWidget);
      expect(find.text('Assign Team'), findsOneWidget);

      // Close panel
      await tester.tap(find.byIcon(Icons.close_rounded).first);
      await tester.pumpAndSettle();

      expect(find.byType(LocationInformationPanel), findsNothing);
    });

    testWidgets('5. Map Filter Panel opens and allows toggling layers', (tester) async {
      final mockDataSource = const RescueMapMockDataSource(latency: Duration.zero);
      final notifier = RescueMapNotifier(
        GetTamilNaduCitiesUseCase(RescueMapRepositoryImpl(dataSource: mockDataSource)),
      );

      await tester.pumpWidget(createTestMapWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Tap Filter button in Top AppBar
      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(MapFilterPanel), findsOneWidget);
      expect(find.text('Map Layer Filters'), findsOneWidget);
      expect(find.text('Show Hospitals'), findsOneWidget);
      expect(find.text('Show Flood Layer'), findsOneWidget);
      expect(find.text('Show Risk Circles'), findsOneWidget);

      // Tap close
      await tester.tap(find.byTooltip('Close Filters'));
      await tester.pumpAndSettle();

      expect(find.byType(MapFilterPanel), findsNothing);
    });
  });
}
