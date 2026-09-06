import 'package:flutter/material.dart';

/// Disaster category classification.
enum DisasterCategory {
  flood,
  cyclone,
  earthquake,
  fire,
  landslide,
  storm,
  medical,
  hazmat,
}

extension DisasterCategoryX on DisasterCategory {
  String get displayName {
    switch (this) {
      case DisasterCategory.flood:
        return 'Flood';
      case DisasterCategory.cyclone:
        return 'Cyclone';
      case DisasterCategory.earthquake:
        return 'Earthquake';
      case DisasterCategory.fire:
        return 'Fire & Thermal';
      case DisasterCategory.landslide:
        return 'Landslide';
      case DisasterCategory.storm:
        return 'Storm Surge';
      case DisasterCategory.medical:
        return 'Medical Outbreak';
      case DisasterCategory.hazmat:
        return 'Hazmat & Chemical';
    }
  }

  IconData get icon {
    switch (this) {
      case DisasterCategory.flood:
        return Icons.flood_rounded;
      case DisasterCategory.cyclone:
        return Icons.cyclone_rounded;
      case DisasterCategory.earthquake:
        return Icons.vibration_rounded;
      case DisasterCategory.fire:
        return Icons.local_fire_department_rounded;
      case DisasterCategory.landslide:
        return Icons.landslide_rounded;
      case DisasterCategory.storm:
        return Icons.tsunami_rounded;
      case DisasterCategory.medical:
        return Icons.medical_services_rounded;
      case DisasterCategory.hazmat:
        return Icons.warning_amber_rounded;
    }
  }

  Color get color {
    switch (this) {
      case DisasterCategory.flood:
        return const Color(0xFF3B82F6);
      case DisasterCategory.cyclone:
        return const Color(0xFF8B5CF6);
      case DisasterCategory.earthquake:
        return const Color(0xFFD97706);
      case DisasterCategory.fire:
        return const Color(0xFFEF4444);
      case DisasterCategory.landslide:
        return const Color(0xFFB45309);
      case DisasterCategory.storm:
        return const Color(0xFF06B6D4);
      case DisasterCategory.medical:
        return const Color(0xFFEC4899);
      case DisasterCategory.hazmat:
        return const Color(0xFFE11D48);
    }
  }
}

/// Severity classification.
enum SeverityLevel {
  low,
  moderate,
  high,
  critical,
  catastrophic,
}

extension SeverityLevelX on SeverityLevel {
  String get displayName {
    switch (this) {
      case SeverityLevel.low:
        return 'Low';
      case SeverityLevel.moderate:
        return 'Moderate';
      case SeverityLevel.high:
        return 'High';
      case SeverityLevel.critical:
        return 'Critical';
      case SeverityLevel.catastrophic:
        return 'Catastrophic';
    }
  }

  Color get color {
    switch (this) {
      case SeverityLevel.low:
        return const Color(0xFF10B981);
      case SeverityLevel.moderate:
        return const Color(0xFF3B82F6);
      case SeverityLevel.high:
        return const Color(0xFFF59E0B);
      case SeverityLevel.critical:
        return const Color(0xFFF97316);
      case SeverityLevel.catastrophic:
        return const Color(0xFFEF4444);
    }
  }
}

/// Incident response operational status.
enum IncidentStatus {
  reported,
  dispatched,
  inProgress,
  resolved,
  closed,
}

extension IncidentStatusX on IncidentStatus {
  String get displayName {
    switch (this) {
      case IncidentStatus.reported:
        return 'Reported';
      case IncidentStatus.dispatched:
        return 'Dispatched';
      case IncidentStatus.inProgress:
        return 'In Progress';
      case IncidentStatus.resolved:
        return 'Resolved';
      case IncidentStatus.closed:
        return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case IncidentStatus.reported:
        return const Color(0xFFF59E0B);
      case IncidentStatus.dispatched:
        return const Color(0xFF3B82F6);
      case IncidentStatus.inProgress:
        return const Color(0xFF8B5CF6);
      case IncidentStatus.resolved:
        return const Color(0xFF10B981);
      case IncidentStatus.closed:
        return const Color(0xFF6B7280);
    }
  }
}

/// District risk tier rating.
enum RiskTier {
  low,
  medium,
  high,
  critical,
}

extension RiskTierX on RiskTier {
  String get displayName {
    switch (this) {
      case RiskTier.low:
        return 'Low Risk';
      case RiskTier.medium:
        return 'Medium Risk';
      case RiskTier.high:
        return 'High Risk';
      case RiskTier.critical:
        return 'Critical Hazard';
    }
  }

  Color get color {
    switch (this) {
      case RiskTier.low:
        return const Color(0xFF10B981);
      case RiskTier.medium:
        return const Color(0xFFF59E0B);
      case RiskTier.high:
        return const Color(0xFFF97316);
      case RiskTier.critical:
        return const Color(0xFFEF4444);
    }
  }
}

/// Report generation timeframe.
enum ReportTimeframe {
  daily,
  weekly,
  monthly,
  custom,
}

extension ReportTimeframeX on ReportTimeframe {
  String get displayName {
    switch (this) {
      case ReportTimeframe.daily:
        return 'Daily SitRep';
      case ReportTimeframe.weekly:
        return 'Weekly Summary';
      case ReportTimeframe.monthly:
        return 'Monthly Audit';
      case ReportTimeframe.custom:
        return 'Custom Date Range';
    }
  }
}

/// Export format.
enum ReportFormat {
  pdf,
  csv,
  json,
}

extension ReportFormatX on ReportFormat {
  String get displayName => name.toUpperCase();
  IconData get icon {
    switch (this) {
      case ReportFormat.pdf:
        return Icons.picture_as_pdf_rounded;
      case ReportFormat.csv:
        return Icons.table_chart_rounded;
      case ReportFormat.json:
        return Icons.code_rounded;
    }
  }
}

/// Top-level Aggregated Analytics Summary.
class AnalyticsSummary {
  final int totalIncidents;
  final int activeIncidents;
  final int resolvedIncidents;
  final double avgResponseTimeMinutes;
  final double avgRescueTimeMinutes;
  final int activeRescueTeams;
  final int totalResourcesUsed;
  final int aiPredictionsGenerated;
  final int totalVictimsRescued;
  final double totalDistanceTravelledKm;

  const AnalyticsSummary({
    required this.totalIncidents,
    required this.activeIncidents,
    required this.resolvedIncidents,
    required this.avgResponseTimeMinutes,
    required this.avgRescueTimeMinutes,
    required this.activeRescueTeams,
    required this.totalResourcesUsed,
    required this.aiPredictionsGenerated,
    required this.totalVictimsRescued,
    required this.totalDistanceTravelledKm,
  });

  static const AnalyticsSummary empty = AnalyticsSummary(
    totalIncidents: 0,
    activeIncidents: 0,
    resolvedIncidents: 0,
    avgResponseTimeMinutes: 0.0,
    avgRescueTimeMinutes: 0.0,
    activeRescueTeams: 0,
    totalResourcesUsed: 0,
    aiPredictionsGenerated: 0,
    totalVictimsRescued: 0,
    totalDistanceTravelledKm: 0.0,
  );
}

/// Incident record for statistical analysis.
class IncidentStatItem {
  final String id;
  final String title;
  final DisasterCategory disasterCategory;
  final String district;
  final SeverityLevel severity;
  final IncidentStatus status;
  final DateTime timestamp;
  final int victimsCount;
  final int responseTimeMinutes;
  final int rescueDurationMinutes;

  const IncidentStatItem({
    required this.id,
    required this.title,
    required this.disasterCategory,
    required this.district,
    required this.severity,
    required this.status,
    required this.timestamp,
    required this.victimsCount,
    required this.responseTimeMinutes,
    required this.rescueDurationMinutes,
  });
}

/// Comprehensive Resource Utilization Telemetry.
class ResourceUsageAnalytics {
  final int totalVehiclesActive;
  final int totalVehiclesDeployed;
  final double fuelConsumptionLitres;
  final int medicalKitsUsed;
  final int foodRationsDistributedKg;
  final int waterPacketsDistributedLitres;
  final double shelterOccupancyRatio; // 0.0 to 1.0
  final double hospitalCapacityRatio; // 0.0 to 1.0

  const ResourceUsageAnalytics({
    required this.totalVehiclesActive,
    required this.totalVehiclesDeployed,
    required this.fuelConsumptionLitres,
    required this.medicalKitsUsed,
    required this.foodRationsDistributedKg,
    required this.waterPacketsDistributedLitres,
    required this.shelterOccupancyRatio,
    required this.hospitalCapacityRatio,
  });

  int get shelterOccupancyPercent => (shelterOccupancyRatio * 100).toInt();
  int get hospitalCapacityPercent => (hospitalCapacityRatio * 100).toInt();
}

/// Rescue team performance scorecard & leaderboard item.
class TeamPerformanceItem {
  final String teamId;
  final String teamName;
  final String district;
  final String leaderName;
  final int missionCount;
  final double avgResponseTimeMinutes;
  final double successRate; // 0.0 to 1.0
  final int rescuesCompleted;
  final double distanceTravelledKm;
  final double performanceScore; // 0.0 to 100.0

  const TeamPerformanceItem({
    required this.teamId,
    required this.teamName,
    required this.district,
    required this.leaderName,
    required this.missionCount,
    required this.avgResponseTimeMinutes,
    required this.successRate,
    required this.rescuesCompleted,
    required this.distanceTravelledKm,
    required this.performanceScore,
  });

  int get successRatePercent => (successRate * 100).toInt();
}

/// District operational disaster profile.
class DistrictAnalyticsItem {
  final String district;
  final int incidentCount;
  final int populationImpacted;
  final int sheltersOpen;
  final int totalShelters;
  final int hospitalsActive;
  final int totalHospitals;
  final int resourcesAvailable;
  final RiskTier riskTier;
  final int activeMissionsCount;

  const DistrictAnalyticsItem({
    required this.district,
    required this.incidentCount,
    required this.populationImpacted,
    required this.sheltersOpen,
    required this.totalShelters,
    required this.hospitalsActive,
    required this.totalHospitals,
    required this.resourcesAvailable,
    required this.riskTier,
    required this.activeMissionsCount,
  });
}

/// AI generated operational insights card.
class AIInsightItem {
  final String id;
  final String title;
  final String category; // 'High Risk District', 'Resource Shortage', 'Suggested Allocation', 'Weather Risk', 'Infrastructure Risk'
  final SeverityLevel severity;
  final String projectedImpact;
  final String recommendation;
  final double confidenceScore; // 0.0 to 1.0
  final DateTime timestamp;

  const AIInsightItem({
    required this.id,
    required this.title,
    required this.category,
    required this.severity,
    required this.projectedImpact,
    required this.recommendation,
    required this.confidenceScore,
    required this.timestamp,
  });

  int get confidencePercent => (confidenceScore * 100).toInt();
}

/// Generated report metadata for download and export.
class GeneratedReport {
  final String id;
  final String title;
  final ReportTimeframe timeframe;
  final ReportFormat format;
  final DateTime generatedAt;
  final String dateRangeLabel;
  final int dataItemsCount;
  final int fileSizeKb;
  final String downloadUrl;

  const GeneratedReport({
    required this.id,
    required this.title,
    required this.timeframe,
    required this.format,
    required this.generatedAt,
    required this.dateRangeLabel,
    required this.dataItemsCount,
    required this.fileSizeKb,
    required this.downloadUrl,
  });
}
