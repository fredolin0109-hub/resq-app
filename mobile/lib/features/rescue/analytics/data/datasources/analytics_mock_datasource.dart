import 'dart:math';
import '../models/analytics_models.dart';
import '../../domain/entities/analytics_entities.dart';

/// Comprehensive mock data provider for Disaster Analytics & Reporting.
/// Populates 500 incidents, 50 rescue squads, 13 Tamil Nadu districts,
/// resource telemetry, predictive AI insights, and downloadable reports.
class AnalyticsMockDataSource {
  static final AnalyticsMockDataSource _instance =
      AnalyticsMockDataSource._internal();
  factory AnalyticsMockDataSource() => _instance;

  AnalyticsMockDataSource._internal() {
    _initializeData();
  }

  static const List<String> tnDistricts = [
    'Chennai',
    'Cuddalore',
    'Nagapattinam',
    'Tirunelveli',
    'Thoothukudi',
    'Madurai',
    'Coimbatore',
    'Salem',
    'Tiruchirappalli',
    'Vellore',
    'Thanjavur',
    'Erode',
    'Kanyakumari',
  ];

  late final List<IncidentStatItemModel> _incidents;
  late final List<TeamPerformanceItemModel> _teams;
  late final List<DistrictAnalyticsItemModel> _districts;
  late final List<AIInsightItemModel> _aiInsights;
  late final List<GeneratedReportModel> _generatedReports;
  late ResourceUsageAnalytics _resourceAnalytics;

  void _initializeData() {
    final random = Random(42);

    // 1. Generate 500 Incidents
    _incidents = [];
    final incidentPrefixes = [
      'Flash Flood Inundation',
      'Cyclonic Wind Damage',
      'Structural Wall Collapse',
      'Substation Electrical Fire',
      'Hillside Mudslide',
      'Severe Coastal Storm Surge',
      'Waterborne Cholera Outbreak',
      'Industrial Chemical Leakage',
      'Urban Drainage Choke Flooding',
      'Highway Landslip Obstruction',
      'Transformer Explosion Fire',
      'Bridge Structural Washaway',
      'Salt Pan Tidal Flooding',
      'River Embankment Breach',
      'Fishermen Boat Distress in Cyclone',
    ];

    final now = DateTime.now();

    for (int i = 1; i <= 500; i++) {
      final id = 'INC-${(1000 + i).toString()}';
      final district = tnDistricts[i % tnDistricts.length];
      final cat = DisasterCategory.values[i % DisasterCategory.values.length];
      final prefix = incidentPrefixes[i % incidentPrefixes.length];
      final title = '$prefix - $district Zone ${(i % 8) + 1}';
      
      final sev = SeverityLevel.values[random.nextInt(SeverityLevel.values.length)];
      final status = i % 5 == 0
          ? IncidentStatus.reported
          : i % 4 == 0
              ? IncidentStatus.dispatched
              : i % 3 == 0
                  ? IncidentStatus.inProgress
                  : IncidentStatus.resolved;

      final victims = (random.nextInt(45) + 1) * (sev.index + 1);
      final respTime = 6 + random.nextInt(25); // 6 to 30 mins
      final rescueDuration = 25 + random.nextInt(180); // 25 to 205 mins
      final daysAgo = random.nextInt(60);
      final hoursAgo = random.nextInt(24);
      final timestamp = now.subtract(Duration(days: daysAgo, hours: hoursAgo, minutes: random.nextInt(60)));

      _incidents.add(
        IncidentStatItemModel(
          id: id,
          title: title,
          disasterCategory: cat,
          district: district,
          severity: sev,
          status: status,
          timestamp: timestamp,
          victimsCount: victims,
          responseTimeMinutes: respTime,
          rescueDurationMinutes: rescueDuration,
        ),
      );
    }

    // 2. Generate 50 Rescue Teams
    final leaderFirstNames = [
      'Commander Ramesh',
      'Captain Ananya',
      'Inspector Karthik',
      'Lieutenant Priya',
      'Major Sundar',
      'Captain Vignesh',
      'Commander Shalini',
      'Inspector Arvind',
      'Major Deepa',
      'Captain Naveen',
      'Commander Balaji',
      'Inspector Revathi',
      'Major Saravanan',
      'Captain Divya',
      'Lieutenant Vijay',
    ];

    final teamDesignations = [
      'Alpha Aquatic Response',
      'Bravo Rapid Evacuation',
      'Charlie Hazmat Containment',
      'Delta Urban Search & Rescue',
      'Echo Heli-Rescue Squad',
      'Foxtrot Amphibious Taskforce',
      'Golf High-Altitude Relief',
      'Hotel Paramedical Unit',
      'India Drone Recon Fleet',
      'Juliet Tactical Fire Unit',
    ];

    _teams = [];
    for (int i = 1; i <= 50; i++) {
      final teamId = 'TEAM-${(100 + i).toString()}';
      final district = tnDistricts[i % tnDistricts.length];
      final teamType = teamDesignations[i % teamDesignations.length];
      final teamName = '$teamType ${(i % 5) + 1}';
      final leader = '${leaderFirstNames[i % leaderFirstNames.length]} ${(i % 3) == 0 ? "IPS" : (i % 2) == 0 ? "NDRF" : "SDRF"}';
      
      final missions = 12 + random.nextInt(85);
      final respTime = 8.0 + (random.nextDouble() * 12.0); // 8.0 to 20.0
      final successRate = 0.88 + (random.nextDouble() * 0.11); // 88% to 99%
      final rescues = (missions * (4 + random.nextInt(12)));
      final distance = (missions * (15.0 + random.nextDouble() * 35.0));
      final score = (successRate * 60.0) + ((30.0 - respTime) * 1.5) + ((rescues / 100.0) * 2.0);
      final boundedScore = score.clamp(78.0, 99.8);

      _teams.add(
        TeamPerformanceItemModel(
          teamId: teamId,
          teamName: teamName,
          district: district,
          leaderName: leader,
          missionCount: missions,
          avgResponseTimeMinutes: double.parse(respTime.toStringAsFixed(1)),
          successRate: double.parse(successRate.toStringAsFixed(3)),
          rescuesCompleted: rescues,
          distanceTravelledKm: double.parse(distance.toStringAsFixed(1)),
          performanceScore: double.parse(boundedScore.toStringAsFixed(1)),
        ),
      );
    }
    // Sort teams by performance score descending
    _teams.sort((a, b) => b.performanceScore.compareTo(a.performanceScore));

    // 3. Generate 13 Tamil Nadu District Profiles
    final districtStats = <String, Map<String, dynamic>>{
      'Chennai': {'pop': 48000, 'shelters': 42, 'hosp': 28, 'risk': RiskTier.high},
      'Cuddalore': {'pop': 34000, 'shelters': 38, 'hosp': 16, 'risk': RiskTier.critical},
      'Nagapattinam': {'pop': 29000, 'shelters': 30, 'hosp': 12, 'risk': RiskTier.critical},
      'Tirunelveli': {'pop': 18000, 'shelters': 22, 'hosp': 14, 'risk': RiskTier.medium},
      'Thoothukudi': {'pop': 22000, 'shelters': 25, 'hosp': 15, 'risk': RiskTier.high},
      'Madurai': {'pop': 15000, 'shelters': 20, 'hosp': 22, 'risk': RiskTier.medium},
      'Coimbatore': {'pop': 12000, 'shelters': 18, 'hosp': 24, 'risk': RiskTier.low},
      'Salem': {'pop': 9500, 'shelters': 15, 'hosp': 18, 'risk': RiskTier.low},
      'Tiruchirappalli': {'pop': 14000, 'shelters': 19, 'hosp': 19, 'risk': RiskTier.medium},
      'Vellore': {'pop': 11000, 'shelters': 16, 'hosp': 16, 'risk': RiskTier.low},
      'Thanjavur': {'pop': 24000, 'shelters': 28, 'hosp': 14, 'risk': RiskTier.high},
      'Erode': {'pop': 8000, 'shelters': 14, 'hosp': 15, 'risk': RiskTier.low},
      'Kanyakumari': {'pop': 26000, 'shelters': 26, 'hosp': 17, 'risk': RiskTier.high},
    };

    _districts = [];
    for (final dist in tnDistricts) {
      final count = _incidents.where((i) => i.district == dist).length;
      final active = _incidents.where((i) => i.district == dist && i.status != IncidentStatus.resolved).length;
      final info = districtStats[dist]!;
      final totalShelters = info['shelters'] as int;
      final sheltersOpen = (totalShelters * 0.75).round();
      final totalHosp = info['hosp'] as int;
      final activeHosp = (totalHosp * 0.9).round();
      final risk = info['risk'] as RiskTier;
      final pop = (info['pop'] as int) + (count * 120);

      _districts.add(
        DistrictAnalyticsItemModel(
          district: dist,
          incidentCount: count,
          populationImpacted: pop,
          sheltersOpen: sheltersOpen,
          totalShelters: totalShelters,
          hospitalsActive: activeHosp,
          totalHospitals: totalHosp,
          resourcesAvailable: 45 + random.nextInt(120),
          riskTier: risk,
          activeMissionsCount: active,
        ),
      );
    }

    // 4. Resource Usage Telemetry
    _resourceAnalytics = const ResourceUsageAnalytics(
      totalVehiclesActive: 142,
      totalVehiclesDeployed: 180,
      fuelConsumptionLitres: 48920.5,
      medicalKitsUsed: 1240,
      foodRationsDistributedKg: 85200,
      waterPacketsDistributedLitres: 195000,
      shelterOccupancyRatio: 0.74,
      hospitalCapacityRatio: 0.81,
    );

    // 5. AI Operational Insights
    _aiInsights = [
      AIInsightItemModel(
        id: 'AI-INS-01',
        title: 'Cuddalore & Nagapattinam Coastal Flood Surge Vulnerability',
        category: 'High Risk District',
        severity: SeverityLevel.critical,
        projectedImpact:
            'Estimated 18,500 residents at risk of 1.8m backwater surge in lower Kollidam catchment within 36 hours.',
        recommendation:
            'Pre-stage 8 SDRF inflatable boats and 3 high-capacity submersible de-watering pumps in Chidambaram.',
        confidenceScore: 0.94,
        timestamp: now.subtract(const Duration(minutes: 42)),
      ),
      AIInsightItemModel(
        id: 'AI-INS-02',
        title: 'Trauma & Anti-Venom Kit Depletion in Thoothukudi',
        category: 'Resource Shortage',
        severity: SeverityLevel.high,
        projectedImpact:
            'Current district inventory drops below 15% threshold if salt-pan rescue ops exceed 48 continuous hours.',
        recommendation:
            'Reroute 400 trauma modules and 150 anti-venom vials from Tirunelveli Central Medical Warehouse.',
        confidenceScore: 0.91,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 15)),
      ),
      AIInsightItemModel(
        id: 'AI-INS-03',
        title: 'Optimal Fleet Dispatch Route: Chennai Zone 4 Bypass',
        category: 'Suggested Allocation',
        severity: SeverityLevel.moderate,
        projectedImpact:
            'Avoids 45-minute waterlogging bottleneck along Velachery Main Road for Adyar riverbank relief convoys.',
        recommendation:
            'Direct heavy rescue vehicles via OMR Elevated Link Road corridor to reduce transit duration by 32%.',
        confidenceScore: 0.89,
        timestamp: now.subtract(const Duration(hours: 4)),
      ),
      AIInsightItemModel(
        id: 'AI-INS-04',
        title: 'Structural Integrity Warning: Old Coleroon Bridge Sluice',
        category: 'Infrastructure Risk',
        severity: SeverityLevel.critical,
        projectedImpact:
            'Hydrodynamic pressure exceeding design tolerance by 14% due to upstream reservoir discharge.',
        recommendation:
            'Enforce immediate pedestrian and heavy vehicle transit cordon; deploy drone structural ultrasound.',
        confidenceScore: 0.96,
        timestamp: now.subtract(const Duration(hours: 6)),
      ),
      AIInsightItemModel(
        id: 'AI-INS-05',
        title: 'Epidemic Cluster Suppression in Relief Camps (Kanyakumari)',
        category: 'Medical Outbreak',
        severity: SeverityLevel.high,
        projectedImpact:
            'Early wastewater antigen sampling indicates elevated diarrheal risk across 3 coastal relief centers.',
        recommendation:
            'Deploy 5 mobile chlorine dosing systems and distribute 2,500 oral rehydration salts sachets immediately.',
        confidenceScore: 0.88,
        timestamp: now.subtract(const Duration(hours: 9)),
      ),
    ];

    // 6. Pre-existing Generated Reports
    _generatedReports = [
      GeneratedReportModel(
        id: 'REP-2026-0906-01',
        title: 'Tamil Nadu State Disaster SitRep - Daily',
        timeframe: ReportTimeframe.daily,
        format: ReportFormat.pdf,
        generatedAt: now.subtract(const Duration(hours: 3)),
        dateRangeLabel: '06 Sep 2026 (00:00 - 23:59)',
        dataItemsCount: 500,
        fileSizeKb: 1420,
        downloadUrl: 'https://resqlink.gov.in/reports/sitrep-20260906-daily.pdf',
      ),
      GeneratedReportModel(
        id: 'REP-2026-0901-02',
        title: 'Coastal Zone Operations Audit - Weekly',
        timeframe: ReportTimeframe.weekly,
        format: ReportFormat.csv,
        generatedAt: now.subtract(const Duration(days: 2)),
        dateRangeLabel: '30 Aug - 05 Sep 2026',
        dataItemsCount: 380,
        fileSizeKb: 680,
        downloadUrl: 'https://resqlink.gov.in/reports/coastal-weekly-audit.csv',
      ),
      GeneratedReportModel(
        id: 'REP-2026-0831-03',
        title: 'Statewide Resource Telemetry & Mission Matrix - Monthly',
        timeframe: ReportTimeframe.monthly,
        format: ReportFormat.json,
        generatedAt: now.subtract(const Duration(days: 6)),
        dateRangeLabel: '01 Aug - 31 Aug 2026',
        dataItemsCount: 1450,
        fileSizeKb: 3120,
        downloadUrl: 'https://resqlink.gov.in/reports/statewide-august-telemetry.json',
      ),
    ];
  }

  // --- Public Query API ---

  Future<AnalyticsSummary> getAnalyticsSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final active = _incidents.where((i) => i.status != IncidentStatus.resolved && i.status != IncidentStatus.closed).length;
    final resolved = _incidents.where((i) => i.status == IncidentStatus.resolved || i.status == IncidentStatus.closed).length;
    final totalVictims = _incidents.fold<int>(0, (sum, i) => sum + i.victimsCount);
    final totalRespTime = _incidents.fold<int>(0, (sum, i) => sum + i.responseTimeMinutes);
    final totalRescueTime = _incidents.fold<int>(0, (sum, i) => sum + i.rescueDurationMinutes);
    final totalDist = _teams.fold<double>(0.0, (sum, t) => sum + t.distanceTravelledKm);

    return AnalyticsSummary(
      totalIncidents: _incidents.length,
      activeIncidents: active,
      resolvedIncidents: resolved,
      avgResponseTimeMinutes: double.parse((totalRespTime / _incidents.length).toStringAsFixed(1)),
      avgRescueTimeMinutes: double.parse((totalRescueTime / _incidents.length).toStringAsFixed(1)),
      activeRescueTeams: _teams.length,
      totalResourcesUsed: 12400 + _incidents.length * 12,
      aiPredictionsGenerated: 84,
      totalVictimsRescued: totalVictims,
      totalDistanceTravelledKm: double.parse(totalDist.toStringAsFixed(1)),
    );
  }

  Future<List<IncidentStatItemModel>> getIncidentStats({
    String? district,
    DisasterCategory? category,
    SeverityLevel? severity,
    IncidentStatus? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _incidents.where((item) {
      if (district != null && district != 'All' && item.district != district) {
        return false;
      }
      if (category != null && item.disasterCategory != category) {
        return false;
      }
      if (severity != null && item.severity != severity) {
        return false;
      }
      if (status != null && item.status != status) {
        return false;
      }
      if (startDate != null && item.timestamp.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && item.timestamp.isAfter(endDate)) {
        return false;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matches = item.title.toLowerCase().contains(q) ||
            item.district.toLowerCase().contains(q) ||
            item.id.toLowerCase().contains(q);
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  Future<ResourceUsageAnalytics> getResourceUsageAnalytics({String? district}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (district != null && district != 'All') {
      final districtIncidents = _incidents.where((i) => i.district == district).length;
      final factor = (districtIncidents / 50.0).clamp(0.4, 1.6);
      return ResourceUsageAnalytics(
        totalVehiclesActive: (_resourceAnalytics.totalVehiclesActive * factor * 0.1).round().clamp(5, 30),
        totalVehiclesDeployed: (_resourceAnalytics.totalVehiclesDeployed * factor * 0.1).round().clamp(8, 40),
        fuelConsumptionLitres: double.parse((_resourceAnalytics.fuelConsumptionLitres * factor * 0.08).toStringAsFixed(1)),
        medicalKitsUsed: (_resourceAnalytics.medicalKitsUsed * factor * 0.08).round(),
        foodRationsDistributedKg: (_resourceAnalytics.foodRationsDistributedKg * factor * 0.08).round(),
        waterPacketsDistributedLitres: (_resourceAnalytics.waterPacketsDistributedLitres * factor * 0.08).round(),
        shelterOccupancyRatio: (_resourceAnalytics.shelterOccupancyRatio * factor).clamp(0.2, 0.98),
        hospitalCapacityRatio: (_resourceAnalytics.hospitalCapacityRatio * factor).clamp(0.3, 0.99),
      );
    }
    return _resourceAnalytics;
  }

  Future<List<TeamPerformanceItemModel>> getTeamPerformance({
    String? district,
    String? searchQuery,
    String? sortBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    var list = _teams.where((team) {
      if (district != null && district != 'All' && team.district != district) {
        return false;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final match = team.teamName.toLowerCase().contains(q) ||
            team.leaderName.toLowerCase().contains(q) ||
            team.district.toLowerCase().contains(q) ||
            team.teamId.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();

    if (sortBy == 'rescues') {
      list.sort((a, b) => b.rescuesCompleted.compareTo(a.rescuesCompleted));
    } else if (sortBy == 'responseTime') {
      list.sort((a, b) => a.avgResponseTimeMinutes.compareTo(b.avgResponseTimeMinutes));
    } else if (sortBy == 'successRate') {
      list.sort((a, b) => b.successRate.compareTo(a.successRate));
    } else {
      list.sort((a, b) => b.performanceScore.compareTo(a.performanceScore));
    }

    return list;
  }

  Future<List<DistrictAnalyticsItemModel>> getDistrictAnalytics({String? district}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (district != null && district != 'All') {
      return _districts.where((d) => d.district == district).toList();
    }
    return _districts;
  }

  Future<List<AIInsightItemModel>> getAIInsights({
    String? category,
    SeverityLevel? severity,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _aiInsights.where((ins) {
      if (category != null && category != 'All' && ins.category != category) {
        return false;
      }
      if (severity != null && ins.severity != severity) {
        return false;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final match = ins.title.toLowerCase().contains(q) ||
            ins.recommendation.toLowerCase().contains(q) ||
            ins.projectedImpact.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  Future<List<GeneratedReportModel>> getGeneratedReports() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_generatedReports);
  }

  Future<GeneratedReportModel> generateReport({
    required ReportTimeframe timeframe,
    required ReportFormat format,
    String? district,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final id = 'REP-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final districtLabel = district != null && district != 'All' ? '($district)' : 'Statewide';
    final title = 'Tamil Nadu Disaster ${timeframe.displayName} Report $districtLabel';
    
    String rangeLabel;
    if (timeframe == ReportTimeframe.daily) {
      rangeLabel = 'Past 24 Hours';
    } else if (timeframe == ReportTimeframe.weekly) {
      rangeLabel = 'Past 7 Days';
    } else if (timeframe == ReportTimeframe.monthly) {
      rangeLabel = 'Past 30 Days';
    } else {
      final s = customStartDate != null ? '${customStartDate.day}/${customStartDate.month}' : 'Start';
      final e = customEndDate != null ? '${customEndDate.day}/${customEndDate.month}' : 'End';
      rangeLabel = '$s - $e';
    }

    final newReport = GeneratedReportModel(
      id: id,
      title: title,
      timeframe: timeframe,
      format: format,
      generatedAt: DateTime.now(),
      dateRangeLabel: rangeLabel,
      dataItemsCount: _incidents.length,
      fileSizeKb: format == ReportFormat.pdf ? 1540 : (format == ReportFormat.json ? 2480 : 540),
      downloadUrl: 'https://resqlink.gov.in/reports/${id.toLowerCase()}.${format.name}',
    );

    _generatedReports.insert(0, newReport);
    return newReport;
  }
}
