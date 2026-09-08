import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/features/rescue/analytics/data/datasources/analytics_mock_datasource.dart';
import '../../../../lib/features/rescue/analytics/data/models/analytics_models.dart';
import '../../../../lib/features/rescue/analytics/data/repositories/analytics_repository_impl.dart';
import '../../../../lib/features/rescue/analytics/domain/entities/analytics_entities.dart';
import '../../../../lib/features/rescue/analytics/domain/usecases/analytics_usecases.dart';
import '../../../../lib/features/rescue/analytics/presentation/providers/analytics_provider.dart';
import '../../../../lib/features/rescue/analytics/presentation/providers/analytics_state.dart';
import '../../../../lib/features/rescue/analytics/presentation/screens/analytics_dashboard_screen.dart';
import '../../../../lib/features/rescue/analytics/presentation/screens/district_analytics_screen.dart';
import '../../../../lib/features/rescue/analytics/presentation/screens/incident_statistics_screen.dart';
import '../../../../lib/features/rescue/analytics/presentation/screens/reports_center_screen.dart';
import '../../../../lib/features/rescue/analytics/presentation/screens/resource_utilization_screen.dart';
import '../../../../lib/features/rescue/analytics/presentation/screens/team_performance_screen.dart';
import '../../../../lib/features/rescue/analytics/presentation/screens/ai_insights_screen.dart';
import '../../../../lib/features/rescue/analytics/presentation/widgets/ai_insight_card.dart';
import '../../../../lib/features/rescue/analytics/presentation/widgets/analytics_summary_card.dart';
import '../../../../lib/features/rescue/analytics/presentation/widgets/district_analytics_card.dart';
import '../../../../lib/features/rescue/analytics/presentation/widgets/incident_chart_card.dart';
import '../../../../lib/features/rescue/analytics/presentation/widgets/report_item_card.dart';
import '../../../../lib/features/rescue/analytics/presentation/widgets/resource_utilization_card.dart';
import '../../../../lib/features/rescue/analytics/presentation/widgets/team_performance_card.dart';
import '../../../../lib/features/rescue/analytics/services/report_export_service.dart';

void main() {
  group('Disaster Analytics Domain & Data Models Tests', () {
    test('IncidentStatItemModel JSON serialization test', () {
      final now = DateTime.now();
      final model = IncidentStatItemModel(
        id: 'INC-1001',
        title: 'Flash Flood Inundation - Chennai Zone 1',
        disasterCategory: DisasterCategory.flood,
        district: 'Chennai',
        severity: SeverityLevel.critical,
        status: IncidentStatus.inProgress,
        timestamp: now,
        victimsCount: 45,
        responseTimeMinutes: 12,
        rescueDurationMinutes: 65,
      );

      final json = model.toJson();
      expect(json['id'], 'INC-1001');
      expect(json['district'], 'Chennai');
      expect(json['victimsCount'], 45);

      final deserialized = IncidentStatItemModel.fromJson(json);
      expect(deserialized.id, 'INC-1001');
      expect(deserialized.disasterCategory, DisasterCategory.flood);
      expect(deserialized.severity, SeverityLevel.critical);
      expect(deserialized.status, IncidentStatus.inProgress);
    });

    test('TeamPerformanceItemModel JSON serialization test', () {
      const team = TeamPerformanceItemModel(
        teamId: 'TEAM-101',
        teamName: 'Alpha Aquatic Response 1',
        district: 'Cuddalore',
        leaderName: 'Commander Ramesh NDRF',
        missionCount: 48,
        avgResponseTimeMinutes: 10.5,
        successRate: 0.96,
        rescuesCompleted: 340,
        distanceTravelledKm: 1250.5,
        performanceScore: 95.8,
      );

      final json = team.toJson();
      expect(json['teamId'], 'TEAM-101');
      expect(json['leaderName'], 'Commander Ramesh NDRF');

      final deserialized = TeamPerformanceItemModel.fromJson(json);
      expect(deserialized.teamName, 'Alpha Aquatic Response 1');
      expect(deserialized.successRatePercent, 96);
      expect(deserialized.performanceScore, 95.8);
    });

    test('DistrictAnalyticsItemModel JSON serialization test', () {
      const dist = DistrictAnalyticsItemModel(
        district: 'Nagapattinam',
        incidentCount: 42,
        populationImpacted: 35000,
        sheltersOpen: 24,
        totalShelters: 30,
        hospitalsActive: 11,
        totalHospitals: 12,
        resourcesAvailable: 85,
        riskTier: RiskTier.critical,
        activeMissionsCount: 14,
      );

      final json = dist.toJson();
      expect(json['district'], 'Nagapattinam');
      expect(json['riskTier'], RiskTier.critical.index);

      final deserialized = DistrictAnalyticsItemModel.fromJson(json);
      expect(deserialized.district, 'Nagapattinam');
      expect(deserialized.riskTier, RiskTier.critical);
    });

    test('AIInsightItemModel JSON serialization test', () {
      final now = DateTime.now();
      final ins = AIInsightItemModel(
        id: 'AI-01',
        title: 'Coastal Surge Vulnerability',
        category: 'High Risk District',
        severity: SeverityLevel.critical,
        projectedImpact: '18,500 residents at risk',
        recommendation: 'Pre-stage inflatable boats',
        confidenceScore: 0.94,
        timestamp: now,
      );

      final json = ins.toJson();
      expect(json['title'], 'Coastal Surge Vulnerability');

      final deserialized = AIInsightItemModel.fromJson(json);
      expect(deserialized.confidencePercent, 94);
      expect(deserialized.severity, SeverityLevel.critical);
    });

    test('GeneratedReportModel JSON serialization test', () {
      final now = DateTime.now();
      final report = GeneratedReportModel(
        id: 'REP-001',
        title: 'Tamil Nadu SitRep',
        timeframe: ReportTimeframe.daily,
        format: ReportFormat.pdf,
        generatedAt: now,
        dateRangeLabel: 'Past 24 Hours',
        dataItemsCount: 500,
        fileSizeKb: 1420,
        downloadUrl: 'https://resqlink.gov.in/rep.pdf',
      );

      final json = report.toJson();
      expect(json['id'], 'REP-001');

      final deserialized = GeneratedReportModel.fromJson(json);
      expect(deserialized.title, 'Tamil Nadu SitRep');
      expect(deserialized.format, ReportFormat.pdf);
    });
  });

  group('Data Source & Repository Integration Tests', () {
    late AnalyticsMockDataSource dataSource;
    late AnalyticsRepositoryImpl repository;

    setUp(() {
      dataSource = AnalyticsMockDataSource();
      repository = AnalyticsRepositoryImpl(dataSource: dataSource);
    });

    test('Data source generates 500 incidents, 50 teams, 13 districts', () async {
      final incidents = await repository.getIncidentStats();
      expect(incidents.length, 500);

      final teams = await repository.getTeamPerformance();
      expect(teams.length, 50);

      final districts = await repository.getDistrictAnalytics();
      expect(districts.length, 13);
      expect(AnalyticsMockDataSource.tnDistricts.length, 13);

      final summary = await repository.getAnalyticsSummary();
      expect(summary.totalIncidents, 500);
      expect(summary.activeRescueTeams, 50);
      expect(summary.totalVictimsRescued > 0, true);
    });

    test('Incident filtering by district, category, and severity works correctly', () async {
      final chennaiIncidents = await repository.getIncidentStats(district: 'Chennai');
      expect(chennaiIncidents.every((i) => i.district == 'Chennai'), true);

      final floodIncidents = await repository.getIncidentStats(category: DisasterCategory.flood);
      expect(floodIncidents.every((i) => i.disasterCategory == DisasterCategory.flood), true);

      final criticalIncidents = await repository.getIncidentStats(severity: SeverityLevel.critical);
      expect(criticalIncidents.every((i) => i.severity == SeverityLevel.critical), true);
    });

    test('Report generation and export service produces PDF, CSV, JSON', () async {
      final newReport = await repository.generateReport(
        timeframe: ReportTimeframe.weekly,
        format: ReportFormat.csv,
        district: 'Cuddalore',
      );
      expect(newReport.timeframe, ReportTimeframe.weekly);
      expect(newReport.format, ReportFormat.csv);

      final exportService = ReportExportService();
      final summary = await repository.getAnalyticsSummary();
      final incidents = await repository.getIncidentStats();
      final resources = await repository.getResourceUsageAnalytics();
      final teams = await repository.getTeamPerformance();
      final districts = await repository.getDistrictAnalytics();
      final insights = await repository.getAIInsights();

      final jsonContent = await exportService.exportReportContent(
        timeframe: ReportTimeframe.daily,
        format: ReportFormat.json,
        summary: summary,
        incidents: incidents,
        resources: resources,
        teams: teams,
        districts: districts,
        insights: insights,
      );
      expect(jsonContent.contains('ResQLink AI Disaster Analytics & SitRep'), true);

      final csvContent = await exportService.exportReportContent(
        timeframe: ReportTimeframe.weekly,
        format: ReportFormat.csv,
        summary: summary,
        incidents: incidents,
        resources: resources,
        teams: teams,
        districts: districts,
        insights: insights,
      );
      expect(csvContent.contains('--- EXECUTIVE SUMMARY ---'), true);

      final pdfContent = await exportService.exportReportContent(
        timeframe: ReportTimeframe.monthly,
        format: ReportFormat.pdf,
        summary: summary,
        incidents: incidents,
        resources: resources,
        teams: teams,
        districts: districts,
        insights: insights,
      );
      expect(pdfContent.contains('RESQLINK AI COMMAND CENTER SITREP REPORT'), true);
    });
  });

  group('Presentation Provider State Tests', () {
    late AnalyticsNotifier notifier;

    setUp(() {
      notifier = AnalyticsDependencies.notifier;
    });

    test('loadAnalytics populates state and applies filters properly', () async {
      await notifier.loadAnalytics();
      expect(notifier.state.status, AnalyticsViewStatus.loaded);
      expect(notifier.state.allIncidents.length, 500);
      expect(notifier.state.allTeams.length, 50);
      expect(notifier.state.allDistricts.length, 13);
      expect(notifier.state.allInsights.length >= 5, true);

      // Apply district filter
      notifier.setIncidentDistrict('Cuddalore');
      expect(notifier.state.filteredIncidents.every((i) => i.district == 'Cuddalore'), true);

      // Clear filters
      notifier.clearIncidentFilters();
      expect(notifier.state.filteredIncidents.length, 500);
    });
  });

  group('Disaster Analytics UI Widgets & Screens Tests', () {
    testWidgets('AnalyticsSummaryCard renders metrics correctly', (tester) async {
      const summary = AnalyticsSummary(
        totalIncidents: 500,
        activeIncidents: 120,
        resolvedIncidents: 380,
        avgResponseTimeMinutes: 14.5,
        avgRescueTimeMinutes: 62.0,
        activeRescueTeams: 50,
        totalResourcesUsed: 18400,
        aiPredictionsGenerated: 84,
        totalVictimsRescued: 4200,
        totalDistanceTravelledKm: 48900.0,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnalyticsSummaryCard(summary: summary),
          ),
        ),
      );

      expect(find.text('Operational Analytics Overview'), findsOneWidget);
      expect(find.text('500'), findsOneWidget);
      expect(find.text('120'), findsOneWidget);
      expect(find.text('4200'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('IncidentChartCard renders category and severity badges', (tester) async {
      final now = DateTime.now();
      final sampleIncidents = [
        IncidentStatItem(
          id: 'INC-1',
          title: 'Flood Chennai',
          disasterCategory: DisasterCategory.flood,
          district: 'Chennai',
          severity: SeverityLevel.critical,
          status: IncidentStatus.inProgress,
          timestamp: now,
          victimsCount: 20,
          responseTimeMinutes: 10,
          rescueDurationMinutes: 40,
        ),
        IncidentStatItem(
          id: 'INC-2',
          title: 'Cyclone Cuddalore',
          disasterCategory: DisasterCategory.cyclone,
          district: 'Cuddalore',
          severity: SeverityLevel.high,
          status: IncidentStatus.dispatched,
          timestamp: now,
          victimsCount: 15,
          responseTimeMinutes: 15,
          rescueDurationMinutes: 50,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentChartCard(incidents: sampleIncidents),
          ),
        ),
      );

      expect(find.text('Disaster Breakdown Matrix'), findsOneWidget);
      expect(find.textContaining('Category Distribution'), findsOneWidget);
    });

    testWidgets('ResourceUtilizationCard renders fleet and capacity', (tester) async {
      const res = ResourceUsageAnalytics(
        totalVehiclesActive: 142,
        totalVehiclesDeployed: 180,
        fuelConsumptionLitres: 48920.5,
        medicalKitsUsed: 1240,
        foodRationsDistributedKg: 85200,
        waterPacketsDistributedLitres: 195000,
        shelterOccupancyRatio: 0.74,
        hospitalCapacityRatio: 0.81,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResourceUtilizationCard(resources: res),
          ),
        ),
      );

      expect(find.text('Resource Utilization Telemetry'), findsOneWidget);
      expect(find.text('142 / 180'), findsOneWidget);
      expect(find.text('74%'), findsOneWidget);
      expect(find.text('81%'), findsOneWidget);
    });

    testWidgets('AIInsightCard renders title, recommendation, and confidence', (tester) async {
      final insight = AIInsightItem(
        id: 'AI-1',
        title: 'Coastal Surge Warning',
        category: 'High Risk District',
        severity: SeverityLevel.critical,
        projectedImpact: 'High water levels expected in 24 hours',
        recommendation: 'Deploy amphibious squad',
        confidenceScore: 0.94,
        timestamp: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIInsightCard(insight: insight),
          ),
        ),
      );

      expect(find.text('Coastal Surge Warning'), findsOneWidget);
      expect(find.text('High Risk District'), findsOneWidget);
      expect(find.text('CRITICAL'), findsOneWidget);
      expect(find.textContaining('94%'), findsOneWidget);
    });

    testWidgets('AnalyticsDashboardScreen mounts and renders properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnalyticsDashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Disaster Analytics & Reports'), findsOneWidget);
      expect(find.text('Operational Analytics Overview'), findsOneWidget);
    });

    testWidgets('ReportsCenterScreen mounts and displays archive', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReportsCenterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reports & SitRep Center'), findsOneWidget);
      expect(find.text('Generate SitRep'), findsOneWidget);
    });
  });
}
