import 'dart:convert';
import '../domain/entities/analytics_entities.dart';

/// Service for generating, formatting, and exporting disaster analytics reports
/// into PDF, CSV, and JSON string representations.
class ReportExportService {
  /// Generate formatted export payload according to the requested format and parameters.
  Future<String> exportReportContent({
    required ReportTimeframe timeframe,
    required ReportFormat format,
    required AnalyticsSummary summary,
    required List<IncidentStatItem> incidents,
    required ResourceUsageAnalytics resources,
    required List<TeamPerformanceItem> teams,
    required List<DistrictAnalyticsItem> districts,
    required List<AIInsightItem> insights,
    String? districtFilter,
  }) async {
    switch (format) {
      case ReportFormat.json:
        return _generateJsonReport(
          timeframe: timeframe,
          summary: summary,
          incidents: incidents,
          resources: resources,
          teams: teams,
          districts: districts,
          insights: insights,
          districtFilter: districtFilter,
        );
      case ReportFormat.csv:
        return _generateCsvReport(
          timeframe: timeframe,
          summary: summary,
          incidents: incidents,
          resources: resources,
          teams: teams,
          districts: districts,
          insights: insights,
          districtFilter: districtFilter,
        );
      case ReportFormat.pdf:
        return _generatePdfFormattedReport(
          timeframe: timeframe,
          summary: summary,
          incidents: incidents,
          resources: resources,
          teams: teams,
          districts: districts,
          insights: insights,
          districtFilter: districtFilter,
        );
    }
  }

  String _generateJsonReport({
    required ReportTimeframe timeframe,
    required AnalyticsSummary summary,
    required List<IncidentStatItem> incidents,
    required ResourceUsageAnalytics resources,
    required List<TeamPerformanceItem> teams,
    required List<DistrictAnalyticsItem> districts,
    required List<AIInsightItem> insights,
    String? districtFilter,
  }) {
    final payload = {
      'reportHeader': {
        'title': 'ResQLink AI Disaster Analytics & SitRep',
        'generatedAt': DateTime.now().toIso8601String(),
        'timeframe': timeframe.displayName,
        'districtFilter': districtFilter ?? 'All Districts (Tamil Nadu)',
        'version': '2.0-PROD',
      },
      'executiveSummary': {
        'totalIncidents': summary.totalIncidents,
        'activeIncidents': summary.activeIncidents,
        'resolvedIncidents': summary.resolvedIncidents,
        'avgResponseTimeMinutes': summary.avgResponseTimeMinutes,
        'avgRescueTimeMinutes': summary.avgRescueTimeMinutes,
        'activeRescueTeams': summary.activeRescueTeams,
        'totalResourcesUsed': summary.totalResourcesUsed,
        'totalVictimsRescued': summary.totalVictimsRescued,
        'totalDistanceTravelledKm': summary.totalDistanceTravelledKm,
      },
      'resourceUtilization': {
        'totalVehiclesActive': resources.totalVehiclesActive,
        'totalVehiclesDeployed': resources.totalVehiclesDeployed,
        'fuelConsumptionLitres': resources.fuelConsumptionLitres,
        'medicalKitsUsed': resources.medicalKitsUsed,
        'foodRationsDistributedKg': resources.foodRationsDistributedKg,
        'waterPacketsDistributedLitres':
            resources.waterPacketsDistributedLitres,
        'shelterOccupancyPercent': resources.shelterOccupancyPercent,
        'hospitalCapacityPercent': resources.hospitalCapacityPercent,
      },
      'incidentsCount': incidents.length,
      'districtsCoverage': districts.map((d) => {
            'district': d.district,
            'incidentCount': d.incidentCount,
            'populationImpacted': d.populationImpacted,
            'sheltersOpen': d.sheltersOpen,
            'totalShelters': d.totalShelters,
            'hospitalsActive': d.hospitalsActive,
            'riskTier': d.riskTier.displayName,
          }).toList(),
      'teamPerformanceSummary': teams.take(10).map((t) => {
            'teamName': t.teamName,
            'district': t.district,
            'rescuesCompleted': t.rescuesCompleted,
            'successRatePercent': t.successRatePercent,
            'performanceScore': t.performanceScore,
          }).toList(),
      'aiInsights': insights.map((i) => {
            'title': i.title,
            'category': i.category,
            'severity': i.severity.displayName,
            'recommendation': i.recommendation,
            'confidencePercent': i.confidencePercent,
          }).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  String _generateCsvReport({
    required ReportTimeframe timeframe,
    required AnalyticsSummary summary,
    required List<IncidentStatItem> incidents,
    required ResourceUsageAnalytics resources,
    required List<TeamPerformanceItem> teams,
    required List<DistrictAnalyticsItem> districts,
    required List<AIInsightItem> insights,
    String? districtFilter,
  }) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('# ResQLink AI Disaster Analytics SitRep Export');
    buffer.writeln('# Timeframe: ${timeframe.displayName}');
    buffer.writeln('# District: ${districtFilter ?? "All Tamil Nadu Districts"}');
    buffer.writeln('# Timestamp: ${DateTime.now().toIso8601String()}');
    buffer.writeln('');

    // Summary Section
    buffer.writeln('--- EXECUTIVE SUMMARY ---');
    buffer.writeln('Metric,Value');
    buffer.writeln('Total Incidents,${summary.totalIncidents}');
    buffer.writeln('Active Incidents,${summary.activeIncidents}');
    buffer.writeln('Resolved Incidents,${summary.resolvedIncidents}');
    buffer.writeln('Victims Rescued,${summary.totalVictimsRescued}');
    buffer.writeln('Avg Response Time (min),${summary.avgResponseTimeMinutes}');
    buffer.writeln('Avg Rescue Time (min),${summary.avgRescueTimeMinutes}');
    buffer.writeln('Active Teams,${summary.activeRescueTeams}');
    buffer.writeln('Total Distance Travelled (km),${summary.totalDistanceTravelledKm}');
    buffer.writeln('Shelter Occupancy (%),${resources.shelterOccupancyPercent}');
    buffer.writeln('Hospital Capacity (%),${resources.hospitalCapacityPercent}');
    buffer.writeln('');

    // Incidents Table
    buffer.writeln('--- INCIDENT BREAKDOWN ---');
    buffer.writeln('Incident ID,Title,Category,District,Severity,Status,Victims,Response Time (min),Rescue Duration (min),Timestamp');
    for (final inc in incidents) {
      buffer.writeln(
        '${inc.id},"${inc.title}",${inc.disasterCategory.displayName},${inc.district},${inc.severity.displayName},${inc.status.displayName},${inc.victimsCount},${inc.responseTimeMinutes},${inc.rescueDurationMinutes},${inc.timestamp.toIso8601String()}',
      );
    }
    buffer.writeln('');

    // District Table
    buffer.writeln('--- DISTRICT PROFILES ---');
    buffer.writeln('District,Incidents,Population Impacted,Shelters Open,Total Shelters,Hospitals Active,Risk Tier,Active Missions');
    for (final dist in districts) {
      buffer.writeln(
        '${dist.district},${dist.incidentCount},${dist.populationImpacted},${dist.sheltersOpen},${dist.totalShelters},${dist.hospitalsActive},${dist.riskTier.displayName},${dist.activeMissionsCount}',
      );
    }
    buffer.writeln('');

    // Team Performance Table
    buffer.writeln('--- RESCUE TEAM PERFORMANCE ---');
    buffer.writeln('Team ID,Team Name,District,Leader,Missions,Avg Response Time (min),Success Rate (%),Rescues,Distance (km),Score');
    for (final team in teams) {
      buffer.writeln(
        '${team.teamId},"${team.teamName}",${team.district},"${team.leaderName}",${team.missionCount},${team.avgResponseTimeMinutes},${team.successRatePercent},${team.rescuesCompleted},${team.distanceTravelledKm},${team.performanceScore}',
      );
    }

    return buffer.toString();
  }

  String _generatePdfFormattedReport({
    required ReportTimeframe timeframe,
    required AnalyticsSummary summary,
    required List<IncidentStatItem> incidents,
    required ResourceUsageAnalytics resources,
    required List<TeamPerformanceItem> teams,
    required List<DistrictAnalyticsItem> districts,
    required List<AIInsightItem> insights,
    String? districtFilter,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('================================================================================');
    buffer.writeln('                   RESQLINK AI COMMAND CENTER SITREP REPORT                    ');
    buffer.writeln('================================================================================');
    buffer.writeln('Report Type:    ${timeframe.displayName.toUpperCase()}');
    buffer.writeln('Jurisdiction:   ${districtFilter ?? "All Tamil Nadu Districts (13 Districts)"}');
    buffer.writeln('Generated Date: ${DateTime.now().toLocal().toString()}');
    buffer.writeln('Classification: OFFICIAL RESCUE TELEMETRY / ACTIONABLE');
    buffer.writeln('--------------------------------------------------------------------------------');
    buffer.writeln('');
    buffer.writeln('1. EXECUTIVE SUMMARY & TELEMETRY');
    buffer.writeln('--------------------------------------------------------------------------------');
    buffer.writeln('  * Total Disasters Reported:  ${summary.totalIncidents}');
    buffer.writeln('  * Active Operations:        ${summary.activeIncidents}');
    buffer.writeln('  * Operations Resolved:      ${summary.resolvedIncidents}');
    buffer.writeln('  * Civilians Rescued:        ${summary.totalVictimsRescued}');
    buffer.writeln('  * Average Response Time:    ${summary.avgResponseTimeMinutes} mins');
    buffer.writeln('  * Average Mission Duration: ${summary.avgRescueTimeMinutes} mins');
    buffer.writeln('  * Active Rescue Squads:     ${summary.activeRescueTeams}');
    buffer.writeln('  * Distance Logged:          ${summary.totalDistanceTravelledKm} km');
    buffer.writeln('');
    buffer.writeln('2. RESOURCE & LOGISTICS UTILIZATION');
    buffer.writeln('--------------------------------------------------------------------------------');
    buffer.writeln('  * Active Rescue Vehicles:   ${resources.totalVehiclesActive} / ${resources.totalVehiclesDeployed}');
    buffer.writeln('  * Emergency Fuel Consumed:  ${resources.fuelConsumptionLitres} L');
    buffer.writeln('  * First Aid / Trauma Kits:  ${resources.medicalKitsUsed} deployed');
    buffer.writeln('  * Food Supplies Allocated:  ${resources.foodRationsDistributedKg} kg');
    buffer.writeln('  * Drinking Water Distributed: ${resources.waterPacketsDistributedLitres} L');
    buffer.writeln('  * Shelter Capacity Status:  ${resources.shelterOccupancyPercent}% occupied');
    buffer.writeln('  * Hospital Bed Load:        ${resources.hospitalCapacityPercent}% occupied');
    buffer.writeln('');
    buffer.writeln('3. AI PREDICTIVE INSIGHTS & EARLY ALERTS');
    buffer.writeln('--------------------------------------------------------------------------------');
    for (final ins in insights) {
      buffer.writeln('  [${ins.severity.displayName.toUpperCase()}] ${ins.title} (${ins.confidencePercent}% Confidence)');
      buffer.writeln('    Category:       ${ins.category}');
      buffer.writeln('    Impact:         ${ins.projectedImpact}');
      buffer.writeln('    Action Advised: ${ins.recommendation}');
      buffer.writeln('');
    }
    buffer.writeln('4. DISTRICT RISK & LOGISTICS OVERVIEW');
    buffer.writeln('--------------------------------------------------------------------------------');
    for (final d in districts) {
      buffer.writeln('  * ${d.district.padRight(16)} | Incidents: ${d.incidentCount.toString().padRight(4)} | Impacted: ${d.populationImpacted.toString().padRight(6)} | Shelters: ${d.sheltersOpen}/${d.totalShelters} | Risk: ${d.riskTier.displayName}');
    }
    buffer.writeln('');
    buffer.writeln('5. TOP SQUAD PERFORMANCE & LEADERBOARD');
    buffer.writeln('--------------------------------------------------------------------------------');
    for (final t in teams.take(10)) {
      buffer.writeln('  * ${t.teamName.padRight(24)} (${t.district}) - ${t.rescuesCompleted} rescues, ${t.successRatePercent}% success, Score: ${t.performanceScore}/100');
    }
    buffer.writeln('');
    buffer.writeln('================================================================================');
    buffer.writeln('                          END OF RESQLINK REPORT                                ');
    buffer.writeln('================================================================================');

    return buffer.toString();
  }
}
