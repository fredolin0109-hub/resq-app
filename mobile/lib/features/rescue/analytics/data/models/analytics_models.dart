import '../../domain/entities/analytics_entities.dart';

/// DTO Model for IncidentStatItem with JSON serialization.
class IncidentStatItemModel extends IncidentStatItem {
  const IncidentStatItemModel({
    required super.id,
    required super.title,
    required super.disasterCategory,
    required super.district,
    required super.severity,
    required super.status,
    required super.timestamp,
    required super.victimsCount,
    required super.responseTimeMinutes,
    required super.rescueDurationMinutes,
  });

  factory IncidentStatItemModel.fromJson(Map<String, dynamic> json) {
    final catIdx = (json['disasterCategory'] as num?)?.toInt() ?? 0;
    final sevIdx = (json['severity'] as num?)?.toInt() ?? 0;
    final statIdx = (json['status'] as num?)?.toInt() ?? 0;

    return IncidentStatItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      disasterCategory: catIdx >= 0 && catIdx < DisasterCategory.values.length
          ? DisasterCategory.values[catIdx]
          : DisasterCategory.flood,
      district: json['district'] as String? ?? 'Chennai',
      severity: sevIdx >= 0 && sevIdx < SeverityLevel.values.length
          ? SeverityLevel.values[sevIdx]
          : SeverityLevel.moderate,
      status: statIdx >= 0 && statIdx < IncidentStatus.values.length
          ? IncidentStatus.values[statIdx]
          : IncidentStatus.reported,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      victimsCount: (json['victimsCount'] as num?)?.toInt() ?? 0,
      responseTimeMinutes: (json['responseTimeMinutes'] as num?)?.toInt() ?? 15,
      rescueDurationMinutes:
          (json['rescueDurationMinutes'] as num?)?.toInt() ?? 45,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'disasterCategory': disasterCategory.index,
        'district': district,
        'severity': severity.index,
        'status': status.index,
        'timestamp': timestamp.toIso8601String(),
        'victimsCount': victimsCount,
        'responseTimeMinutes': responseTimeMinutes,
        'rescueDurationMinutes': rescueDurationMinutes,
      };

  IncidentStatItem toEntity() => this;
}

/// DTO Model for TeamPerformanceItem with JSON serialization.
class TeamPerformanceItemModel extends TeamPerformanceItem {
  const TeamPerformanceItemModel({
    required super.teamId,
    required super.teamName,
    required super.district,
    required super.leaderName,
    required super.missionCount,
    required super.avgResponseTimeMinutes,
    required super.successRate,
    required super.rescuesCompleted,
    required super.distanceTravelledKm,
    required super.performanceScore,
  });

  factory TeamPerformanceItemModel.fromJson(Map<String, dynamic> json) {
    return TeamPerformanceItemModel(
      teamId: json['teamId'] as String? ?? '',
      teamName: json['teamName'] as String? ?? '',
      district: json['district'] as String? ?? 'Chennai',
      leaderName: json['leaderName'] as String? ?? '',
      missionCount: (json['missionCount'] as num?)?.toInt() ?? 0,
      avgResponseTimeMinutes:
          (json['avgResponseTimeMinutes'] as num?)?.toDouble() ?? 12.0,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.95,
      rescuesCompleted: (json['rescuesCompleted'] as num?)?.toInt() ?? 0,
      distanceTravelledKm:
          (json['distanceTravelledKm'] as num?)?.toDouble() ?? 0.0,
      performanceScore: (json['performanceScore'] as num?)?.toDouble() ?? 90.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'teamId': teamId,
        'teamName': teamName,
        'district': district,
        'leaderName': leaderName,
        'missionCount': missionCount,
        'avgResponseTimeMinutes': avgResponseTimeMinutes,
        'successRate': successRate,
        'rescuesCompleted': rescuesCompleted,
        'distanceTravelledKm': distanceTravelledKm,
        'performanceScore': performanceScore,
      };

  TeamPerformanceItem toEntity() => this;
}

/// DTO Model for DistrictAnalyticsItem with JSON serialization.
class DistrictAnalyticsItemModel extends DistrictAnalyticsItem {
  const DistrictAnalyticsItemModel({
    required super.district,
    required super.incidentCount,
    required super.populationImpacted,
    required super.sheltersOpen,
    required super.totalShelters,
    required super.hospitalsActive,
    required super.totalHospitals,
    required super.resourcesAvailable,
    required super.riskTier,
    required super.activeMissionsCount,
  });

  factory DistrictAnalyticsItemModel.fromJson(Map<String, dynamic> json) {
    final tierIdx = (json['riskTier'] as num?)?.toInt() ?? 0;
    return DistrictAnalyticsItemModel(
      district: json['district'] as String? ?? '',
      incidentCount: (json['incidentCount'] as num?)?.toInt() ?? 0,
      populationImpacted: (json['populationImpacted'] as num?)?.toInt() ?? 0,
      sheltersOpen: (json['sheltersOpen'] as num?)?.toInt() ?? 0,
      totalShelters: (json['totalShelters'] as num?)?.toInt() ?? 0,
      hospitalsActive: (json['hospitalsActive'] as num?)?.toInt() ?? 0,
      totalHospitals: (json['totalHospitals'] as num?)?.toInt() ?? 0,
      resourcesAvailable: (json['resourcesAvailable'] as num?)?.toInt() ?? 0,
      riskTier: tierIdx >= 0 && tierIdx < RiskTier.values.length
          ? RiskTier.values[tierIdx]
          : RiskTier.low,
      activeMissionsCount: (json['activeMissionsCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'district': district,
        'incidentCount': incidentCount,
        'populationImpacted': populationImpacted,
        'sheltersOpen': sheltersOpen,
        'totalShelters': totalShelters,
        'hospitalsActive': hospitalsActive,
        'totalHospitals': totalHospitals,
        'resourcesAvailable': resourcesAvailable,
        'riskTier': riskTier.index,
        'activeMissionsCount': activeMissionsCount,
      };

  DistrictAnalyticsItem toEntity() => this;
}

/// DTO Model for AIInsightItem with JSON serialization.
class AIInsightItemModel extends AIInsightItem {
  const AIInsightItemModel({
    required super.id,
    required super.title,
    required super.category,
    required super.severity,
    required super.projectedImpact,
    required super.recommendation,
    required super.confidenceScore,
    required super.timestamp,
  });

  factory AIInsightItemModel.fromJson(Map<String, dynamic> json) {
    final sevIdx = (json['severity'] as num?)?.toInt() ?? 2;
    return AIInsightItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General Risk',
      severity: sevIdx >= 0 && sevIdx < SeverityLevel.values.length
          ? SeverityLevel.values[sevIdx]
          : SeverityLevel.high,
      projectedImpact: json['projectedImpact'] as String? ?? '',
      recommendation: json['recommendation'] as String? ?? '',
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.9,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'severity': severity.index,
        'projectedImpact': projectedImpact,
        'recommendation': recommendation,
        'confidenceScore': confidenceScore,
        'timestamp': timestamp.toIso8601String(),
      };

  AIInsightItem toEntity() => this;
}

/// DTO Model for GeneratedReport with JSON serialization.
class GeneratedReportModel extends GeneratedReport {
  const GeneratedReportModel({
    required super.id,
    required super.title,
    required super.timeframe,
    required super.format,
    required super.generatedAt,
    required super.dateRangeLabel,
    required super.dataItemsCount,
    required super.fileSizeKb,
    required super.downloadUrl,
  });

  factory GeneratedReportModel.fromJson(Map<String, dynamic> json) {
    final tfIdx = (json['timeframe'] as num?)?.toInt() ?? 0;
    final fmtIdx = (json['format'] as num?)?.toInt() ?? 0;

    return GeneratedReportModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      timeframe: tfIdx >= 0 && tfIdx < ReportTimeframe.values.length
          ? ReportTimeframe.values[tfIdx]
          : ReportTimeframe.daily,
      format: fmtIdx >= 0 && fmtIdx < ReportFormat.values.length
          ? ReportFormat.values[fmtIdx]
          : ReportFormat.pdf,
      generatedAt: json['generatedAt'] != null
          ? DateTime.tryParse(json['generatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      dateRangeLabel: json['dateRangeLabel'] as String? ?? '',
      dataItemsCount: (json['dataItemsCount'] as num?)?.toInt() ?? 0,
      fileSizeKb: (json['fileSizeKb'] as num?)?.toInt() ?? 256,
      downloadUrl: json['downloadUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'timeframe': timeframe.index,
        'format': format.index,
        'generatedAt': generatedAt.toIso8601String(),
        'dateRangeLabel': dateRangeLabel,
        'dataItemsCount': dataItemsCount,
        'fileSizeKb': fileSizeKb,
        'downloadUrl': downloadUrl,
      };

  GeneratedReport toEntity() => this;
}
