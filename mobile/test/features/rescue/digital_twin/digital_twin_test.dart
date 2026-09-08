import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/features/rescue/digital_twin/data/datasources/digital_twin_mock_datasource.dart';
import '../../../../lib/features/rescue/digital_twin/data/models/digital_twin_models.dart';
import '../../../../lib/features/rescue/digital_twin/data/repositories/digital_twin_repository_impl.dart';
import '../../../../lib/features/rescue/digital_twin/domain/entities/digital_twin_entities.dart';
import '../../../../lib/features/rescue/digital_twin/domain/repositories/digital_twin_repository.dart';
import '../../../../lib/features/rescue/digital_twin/domain/usecases/digital_twin_usecases.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/providers/digital_twin_provider.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/providers/digital_twin_state.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/screens/digital_twin_dashboard_screen.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/widgets/analytics_chart_tile.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/widgets/digital_twin_summary_card.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/widgets/heatmap_layer_selector_widget.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/widgets/infrastructure_card.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/widgets/prediction_card.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/widgets/simulation_control_panel.dart';
import '../../../../lib/features/rescue/digital_twin/presentation/widgets/timeline_event_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Digital Twin Domain & Enums Tests', () {
    test('HeatmapLayerType maps names, icons, and colors', () {
      expect(HeatmapLayerType.flood.displayName, 'Flood Inundation');
      expect(HeatmapLayerType.flood.icon, Icons.flood_rounded);
      expect(HeatmapLayerType.flood.defaultColor, const Color(0xFF3B82F6));

      expect(HeatmapLayerType.fire.displayName, 'Fire & Thermal');
      expect(HeatmapLayerType.fire.icon, Icons.local_fire_department_rounded);

      expect(HeatmapLayerType.cyclone.displayName, 'Cyclone Wind Field');
      expect(HeatmapLayerType.earthquake.displayName, 'Seismic Tremor');
      expect(HeatmapLayerType.landslide.displayName, 'Landslide Hazard');
      expect(HeatmapLayerType.storm.displayName, 'Storm Surge');
      expect(HeatmapLayerType.medical.displayName, 'Medical Demand');
      expect(HeatmapLayerType.infrastructure.displayName, 'Critical Infrastructure');
      expect(HeatmapLayerType.populationDensity.displayName, 'Population Density');
      expect(HeatmapLayerType.riskDensity.displayName, 'Composite Risk Density');
    });

    test('InfrastructureType and Status map correctly', () {
      expect(InfrastructureType.hospital.displayName, 'Emergency Hospital');
      expect(InfrastructureType.bridge.displayName, 'River / Canal Bridge');
      expect(InfrastructureType.powerGrid.displayName, 'Power Grid / Substation');

      expect(InfrastructureStatus.operational.displayName, 'Operational');
      expect(InfrastructureStatus.operational.color, const Color(0xFF10B981));
      expect(InfrastructureStatus.critical.displayName, 'Critical Breach');
      expect(InfrastructureStatus.critical.color, const Color(0xFFEF4444));
    });

    test('TimelineEventType colors and display names', () {
      expect(TimelineEventType.incidentReported.displayName, 'Incident Reported');
      expect(TimelineEventType.incidentReported.color, const Color(0xFFEF4444));
      expect(TimelineEventType.aiAnalysis.displayName, 'AI Predictive Analysis');
      expect(TimelineEventType.missionCompleted.displayName, 'Mission Completed');
    });

    test('PredictionType display names and icons', () {
      expect(PredictionType.floodExpansion.displayName, 'Flood Inundation Expansion');
      expect(PredictionType.roadBlockage.displayName, 'Road Transit Blockage');
      expect(PredictionType.resourceShortage.displayName, 'Resource Stockpile Depletion');
    });

    test('SimulationType display names and icons', () {
      expect(SimulationType.flood.displayName, 'Flood Simulation');
      expect(SimulationType.cyclone.displayName, 'Cyclone Wind Simulation');
      expect(SimulationType.earthquake.displayName, 'Earthquake Tremor Simulation');
    });
  });

  group('Digital Twin Data Models & JSON Serialization Tests', () {
    test('HeatmapPointModel serializes and deserializes properly', () {
      const model = HeatmapPointModel(
        id: 'HP-001',
        latitude: 13.0827,
        longitude: 80.2707,
        intensity: 0.85,
        radiusMeters: 500,
        layerType: HeatmapLayerType.flood,
        district: 'Chennai',
        description: 'Adyar River Basin Inundation',
      );

      final json = model.toJson();
      final parsed = HeatmapPointModel.fromJson(json);

      expect(parsed.id, 'HP-001');
      expect(parsed.latitude, 13.0827);
      expect(parsed.intensity, 0.85);
      expect(parsed.layerType, HeatmapLayerType.flood);
      expect(parsed.district, 'Chennai');
    });

    test('InfrastructureAssetModel serializes and deserializes properly', () {
      final now = DateTime.now();
      final model = InfrastructureAssetModel(
        id: 'INF-001',
        name: 'General Hospital',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Chennai',
        locationAddress: 'Park Town, Chennai',
        latitude: 13.0805,
        longitude: 80.2785,
        operationalCapacityRatio: 0.90,
        lastInspected: now,
        telemetryNotes: 'ICU online',
      );

      final json = model.toJson();
      final parsed = InfrastructureAssetModel.fromJson(json);

      expect(parsed.id, 'INF-001');
      expect(parsed.name, 'General Hospital');
      expect(parsed.type, InfrastructureType.hospital);
      expect(parsed.status, InfrastructureStatus.operational);
      expect(parsed.capacityPercent, 90);
    });

    test('TimelineEventModel serializes and deserializes properly', () {
      final now = DateTime.now();
      final model = TimelineEventModel(
        id: 'TLE-001',
        title: 'Flash Flood Reported',
        description: 'Water rising in sector 4',
        eventType: TimelineEventType.incidentReported,
        district: 'Chennai',
        incidentId: 'INC-101',
        timestamp: now,
        affectedCount: 120,
        loggedBy: 'Command Officer',
      );

      final json = model.toJson();
      final parsed = TimelineEventModel.fromJson(json);

      expect(parsed.id, 'TLE-001');
      expect(parsed.title, 'Flash Flood Reported');
      expect(parsed.eventType, TimelineEventType.incidentReported);
      expect(parsed.affectedCount, 120);
    });

    test('DigitalTwinPredictionModel serializes and deserializes properly', () {
      final now = DateTime.now();
      final model = DigitalTwinPredictionModel(
        id: 'PRD-001',
        title: 'Adyar River Expansion',
        type: PredictionType.floodExpansion,
        district: 'Chennai',
        affectedZone: 'Saidapet',
        riskScore: 88,
        confidenceRatio: 0.94,
        timeHorizon: 'Next 2 Hours',
        projectedOutcome: 'Water depth rising 40cm',
        preventiveAction: 'Dispatch boats',
        generatedAt: now,
      );

      final json = model.toJson();
      final parsed = DigitalTwinPredictionModel.fromJson(json);

      expect(parsed.id, 'PRD-001');
      expect(parsed.riskScore, 88);
      expect(parsed.confidencePercent, 94);
      expect(parsed.type, PredictionType.floodExpansion);
    });
  });

  group('DigitalTwinMockDatasource Completeness Tests', () {
    final ds = DigitalTwinMockDatasource();

    test('Covers all 13 key Tamil Nadu districts', () {
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.length, 13);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Chennai'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Cuddalore'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Nagapattinam'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Tirunelveli'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Thoothukudi'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Madurai'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Coimbatore'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Salem'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Tiruchirappalli'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Vellore'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Thanjavur'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Erode'), isTrue);
      expect(DigitalTwinMockDatasource.tamilNaduDistricts.contains('Kanyakumari'), isTrue);
    });

    test('Contains 100+ Spatial Heatmap Points', () {
      final points = ds.getHeatmapPoints();
      expect(points.length, greaterThanOrEqualTo(100));
    });

    test('Contains 50 Chronological Timeline Events', () {
      final events = ds.getTimelineEvents();
      expect(events.length, greaterThanOrEqualTo(50));
    });

    test('Contains 30 Critical Infrastructure Assets', () {
      final assets = ds.getInfrastructureAssets();
      expect(assets.length, greaterThanOrEqualTo(30));
    });

    test('Contains 40 AI Predictive Disaster Forecasts', () {
      final preds = ds.getAIPredictions();
      expect(preds.length, greaterThanOrEqualTo(40));
    });

    test('Generates 5 Preset Disaster Simulations', () {
      final sims = ds.getSimulations();
      expect(sims.length, 5);
      expect(sims.any((s) => s.type == SimulationType.flood), isTrue);
      expect(sims.any((s) => s.type == SimulationType.cyclone), isTrue);
      expect(sims.any((s) => s.type == SimulationType.earthquake), isTrue);
      expect(sims.any((s) => s.type == SimulationType.fire), isTrue);
      expect(sims.any((s) => s.type == SimulationType.landslide), isTrue);
    });
  });

  group('Repository & Use Cases Tests', () {
    late DigitalTwinRepository repo;

    setUp(() {
      repo = DigitalTwinRepositoryImpl(DigitalTwinMockDatasource());
    });

    test('GetDigitalTwinSummaryUseCase fetches summary metrics', () async {
      final usecase = GetDigitalTwinSummaryUseCase(repo);
      final summary = await usecase();
      expect(summary.activeIncidents, greaterThan(0));
      expect(summary.aiPredictionAccuracy, greaterThan(0.9));
    });

    test('GetLiveAnalyticsUseCase fetches telemetry for district', () async {
      final usecase = GetLiveAnalyticsUseCase(repo);
      final analytics = await usecase(district: 'Chennai');
      expect(analytics.riskTrend.isNotEmpty, isTrue);
      expect(analytics.precipitationTrend.isNotEmpty, isTrue);
      expect(analytics.roadAvailabilityRatio, greaterThan(0.0));
    });

    test('GetHeatmapPointsUseCase filters by active layers', () async {
      final usecase = GetHeatmapPointsUseCase(repo);
      final points = await usecase(
        activeLayers: {HeatmapLayerType.flood},
        district: 'Chennai',
      );
      expect(points.every((p) => p.layerType == HeatmapLayerType.flood), isTrue);
      expect(points.every((p) => p.district == 'Chennai'), isTrue);
    });

    test('GetInfrastructureAssetsUseCase filters by type and status', () async {
      final usecase = GetInfrastructureAssetsUseCase(repo);
      final hospitals = await usecase(type: InfrastructureType.hospital);
      expect(hospitals.every((h) => h.type == InfrastructureType.hospital), isTrue);
    });

    test('ManageDisasterSimulationUseCase loads and updates simulations', () async {
      final usecase = ManageDisasterSimulationUseCase(repo);
      final sims = await usecase.getSimulations();
      expect(sims.length, 5);

      final updated = await usecase.updateSimulation(
        sims.first.copyWith(speedMultiplier: 5.0),
      );
      expect(updated.speedMultiplier, 5.0);
    });
  });

  group('DigitalTwinNotifier Presentation State Tests', () {
    late DigitalTwinNotifier notifier;

    setUp(() {
      final ds = DigitalTwinMockDatasource();
      final repo = DigitalTwinRepositoryImpl(ds);
      notifier = DigitalTwinNotifier(
        getSummaryUseCase: GetDigitalTwinSummaryUseCase(repo),
        getAnalyticsUseCase: GetLiveAnalyticsUseCase(repo),
        getHeatmapPointsUseCase: GetHeatmapPointsUseCase(repo),
        getTimelineEventsUseCase: GetTimelineEventsUseCase(repo),
        getInfrastructureUseCase: GetInfrastructureAssetsUseCase(repo),
        getPredictionsUseCase: GetDigitalTwinPredictionsUseCase(repo),
        manageSimulationUseCase: ManageDisasterSimulationUseCase(repo),
      );
    });

    test('loadDashboard sets status to loaded with full collections', () async {
      await notifier.loadDashboard();
      expect(notifier.state.status, DigitalTwinViewStatus.loaded);
      expect(notifier.state.allHeatmapPoints.length, greaterThanOrEqualTo(100));
      expect(notifier.state.allTimelineEvents.length, greaterThanOrEqualTo(50));
      expect(notifier.state.allInfrastructureAssets.length, greaterThanOrEqualTo(30));
      expect(notifier.state.allPredictions.length, greaterThanOrEqualTo(40));
      expect(notifier.state.allSimulations.length, 5);
      expect(notifier.state.activeSimulation, isNotNull);
    });

    test('toggleHeatmapLayer updates active layers and filtered points', () async {
      await notifier.loadDashboard();
      final initialLayers = notifier.state.heatmapFilters.activeLayers.length;
      notifier.toggleHeatmapLayer(HeatmapLayerType.landslide);
      expect(
        notifier.state.heatmapFilters.activeLayers.contains(HeatmapLayerType.landslide),
        isTrue,
      );
      expect(notifier.state.heatmapFilters.activeLayers.length, initialLayers + 1);
    });

    test('searchTimeline filters chronological stream', () async {
      await notifier.loadDashboard();
      notifier.searchTimeline('Velachery');
      expect(
        notifier.state.filteredTimelineEvents
            .any((e) => e.description.toLowerCase().contains('velachery') || e.title.toLowerCase().contains('velachery') || e.loggedBy.toLowerCase().contains('velachery')),
        isTrue,
      );
    });

    test('scrubSimulation updates simulation progress', () async {
      await notifier.loadDashboard();
      notifier.scrubSimulation(0.75);
      expect(notifier.state.activeSimulation?.progress, 0.75);
    });
  });

  group('Widget and Screen Rendering Tests', () {
    testWidgets('DigitalTwinSummaryCard renders metrics and labels', (tester) async {
      const summary = DigitalTwinSummary(
        activeIncidents: 42,
        highRiskDistricts: 5,
        activeRescueTeams: 38,
        availableResourcesCount: 1240,
        sheltersOccupied: 46,
        totalShelters: 80,
        hospitalsAvailable: 34,
        totalHospitals: 42,
        populationAtRisk: 185200,
        aiPredictionAccuracy: 0.942,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DigitalTwinSummaryCard(summary: summary),
          ),
        ),
      );

      expect(find.text('Digital Twin AI Core'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(find.text('Active Incidents'), findsOneWidget);
      expect(find.text('Rescue Teams'), findsOneWidget);
    });

    testWidgets('HeatmapLayerSelectorWidget renders layer chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeatmapLayerSelectorWidget(
              activeLayers: const {HeatmapLayerType.flood, HeatmapLayerType.fire},
              onToggleLayer: (_) {},
              onToggleAll: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Spatial Heatmap Layers'), findsOneWidget);
      expect(find.text('Flood Inundation'), findsOneWidget);
      expect(find.text('Fire & Thermal'), findsOneWidget);
    });

    testWidgets('TimelineEventTile renders event title and district', (tester) async {
      final event = TimelineEvent(
        id: 'TLE-01',
        title: 'Flash Flood Warning',
        description: 'River discharge reached 40,000 cusecs',
        eventType: TimelineEventType.incidentReported,
        district: 'Chennai',
        incidentId: 'INC-101',
        timestamp: DateTime.now(),
        affectedCount: 200,
        loggedBy: 'Command Center',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimelineEventTile(event: event),
          ),
        ),
      );

      expect(find.text('Flash Flood Warning'), findsOneWidget);
      expect(find.text('Chennai'), findsOneWidget);
      expect(find.text('Incident Reported'), findsOneWidget);
    });

    testWidgets('InfrastructureCard renders asset details and status', (tester) async {
      final asset = InfrastructureAsset(
        id: 'INF-01',
        name: 'General Hospital Trauma Center',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Chennai',
        locationAddress: 'Park Town, Chennai',
        latitude: 13.0805,
        longitude: 80.2785,
        operationalCapacityRatio: 0.95,
        lastInspected: DateTime.now(),
        telemetryNotes: 'All 4 generators verified operational',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfrastructureCard(asset: asset),
          ),
        ),
      );

      expect(find.text('General Hospital Trauma Center'), findsOneWidget);
      expect(find.text('Operational'), findsOneWidget);
      expect(find.text('95%'), findsOneWidget);
    });

    testWidgets('PredictionCard renders prediction title and risk score', (tester) async {
      final pred = DigitalTwinPrediction(
        id: 'PRD-01',
        title: 'Adyar River Surge Expansion',
        type: PredictionType.floodExpansion,
        district: 'Chennai',
        affectedZone: 'Saidapet',
        riskScore: 88,
        confidenceRatio: 0.94,
        timeHorizon: 'Next 2 Hours',
        projectedOutcome: 'Water depth will rise by 40cm',
        preventiveAction: 'Deploy inflatable boat fleet',
        generatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PredictionCard(prediction: pred),
          ),
        ),
      );

      expect(find.text('Adyar River Surge Expansion'), findsOneWidget);
      expect(find.text('88'), findsOneWidget);
      expect(find.text('RISK'), findsOneWidget);
      expect(find.text('Next 2 Hours'), findsOneWidget);
    });

    testWidgets('DigitalTwinDashboardScreen renders dashboard overview', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DigitalTwinDashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Digital Twin Command Center'), findsOneWidget);
      expect(find.text('Operational Modules'), findsOneWidget);
      expect(find.text('Live Analytics'), findsOneWidget);
      expect(find.text('Disaster Heatmaps'), findsOneWidget);
      expect(find.text('Timeline Monitor'), findsOneWidget);
      expect(find.text('Infrastructure'), findsOneWidget);
      expect(find.text('AI Predictions'), findsOneWidget);
      expect(find.text('Simulation Lab'), findsOneWidget);
      expect(find.text('Twin Allocation'), findsOneWidget);
    });
  });
}
