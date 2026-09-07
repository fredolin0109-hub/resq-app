import 'package:flutter/material.dart';

/// Incident hazard type classified by AI Commander.
enum IncidentType {
  flood,
  cyclone,
  landslide,
  buildingCollapse,
  stormSurge,
  fire,
  damOverflow,
  coastalErosion,
}

extension IncidentTypeX on IncidentType {
  String get displayName {
    switch (this) {
      case IncidentType.flood:
        return 'Flash Flood';
      case IncidentType.cyclone:
        return 'Severe Cyclone';
      case IncidentType.landslide:
        return 'Hill Landslide';
      case IncidentType.buildingCollapse:
        return 'Structural Collapse';
      case IncidentType.stormSurge:
        return 'Coastal Storm Surge';
      case IncidentType.fire:
        return 'Urban / Wildfire';
      case IncidentType.damOverflow:
        return 'Dam Spillway Overflow';
      case IncidentType.coastalErosion:
        return 'Coastal Inundation';
    }
  }

  IconData get icon {
    switch (this) {
      case IncidentType.flood:
        return Icons.flood_rounded;
      case IncidentType.cyclone:
        return Icons.cyclone_rounded;
      case IncidentType.landslide:
        return Icons.landslide_rounded;
      case IncidentType.buildingCollapse:
        return Icons.domain_disabled_rounded;
      case IncidentType.stormSurge:
        return Icons.tsunami_rounded;
      case IncidentType.fire:
        return Icons.local_fire_department_rounded;
      case IncidentType.damOverflow:
        return Icons.water_damage_rounded;
      case IncidentType.coastalErosion:
        return Icons.waves_rounded;
    }
  }
}

/// Severity classification level.
enum IncidentSeverity {
  low,
  moderate,
  high,
  critical,
  catastrophic,
}

extension IncidentSeverityX on IncidentSeverity {
  String get displayName {
    switch (this) {
      case IncidentSeverity.low:
        return 'Low Severity';
      case IncidentSeverity.moderate:
        return 'Moderate';
      case IncidentSeverity.high:
        return 'High Severity';
      case IncidentSeverity.critical:
        return 'Critical';
      case IncidentSeverity.catastrophic:
        return 'Catastrophic';
    }
  }

  Color get color {
    switch (this) {
      case IncidentSeverity.low:
        return const Color(0xFF10B981); // Green
      case IncidentSeverity.moderate:
        return const Color(0xFF3B82F6); // Blue
      case IncidentSeverity.high:
        return const Color(0xFFF59E0B); // Amber
      case IncidentSeverity.critical:
        return const Color(0xFFF97316); // Orange
      case IncidentSeverity.catastrophic:
        return const Color(0xFFEF4444); // Red
    }
  }
}

/// Recommendation priority level.
enum RecommendationPriority {
  immediate,
  high,
  medium,
  advisory,
}

extension RecommendationPriorityX on RecommendationPriority {
  String get displayName {
    switch (this) {
      case RecommendationPriority.immediate:
        return 'Immediate Action';
      case RecommendationPriority.high:
        return 'High Priority';
      case RecommendationPriority.medium:
        return 'Medium Priority';
      case RecommendationPriority.advisory:
        return 'Advisory';
    }
  }

  Color get color {
    switch (this) {
      case RecommendationPriority.immediate:
        return const Color(0xFFEF4444);
      case RecommendationPriority.high:
        return const Color(0xFFF97316);
      case RecommendationPriority.medium:
        return const Color(0xFFF59E0B);
      case RecommendationPriority.advisory:
        return const Color(0xFF3B82F6);
    }
  }
}

/// Execution difficulty rating for tactical operations.
enum ExecutionDifficulty {
  low,
  moderate,
  high,
  complex,
}

extension ExecutionDifficultyX on ExecutionDifficulty {
  String get displayName {
    switch (this) {
      case ExecutionDifficulty.low:
        return 'Easy / Low Risk';
      case ExecutionDifficulty.moderate:
        return 'Moderate';
      case ExecutionDifficulty.high:
        return 'High Difficulty';
      case ExecutionDifficulty.complex:
        return 'Complex Tactical';
    }
  }

  Color get color {
    switch (this) {
      case ExecutionDifficulty.low:
        return const Color(0xFF10B981);
      case ExecutionDifficulty.moderate:
        return const Color(0xFF3B82F6);
      case ExecutionDifficulty.high:
        return const Color(0xFFF59E0B);
      case ExecutionDifficulty.complex:
        return const Color(0xFF8B5CF6);
    }
  }
}

/// Sender of chat message in AI Commander.
enum ChatSender {
  user,
  aiCommander,
  systemAlert,
}

/// Domain entity representing a tactical AI action recommendation.
class AIRecommendation {
  final String id;
  final String incidentId;
  final String title;
  final String recommendation;
  final String reasoning;
  final String estimatedImpact;
  final RecommendationPriority priority;
  final ExecutionDifficulty difficulty;
  final List<String> requiredResources;
  final DateTime timestamp;
  final bool isExecuted;

  const AIRecommendation({
    required this.id,
    required this.incidentId,
    required this.title,
    required this.recommendation,
    required this.reasoning,
    required this.estimatedImpact,
    required this.priority,
    required this.difficulty,
    required this.requiredResources,
    required this.timestamp,
    this.isExecuted = false,
  });

  AIRecommendation copyWith({
    String? id,
    String? incidentId,
    String? title,
    String? recommendation,
    String? reasoning,
    String? estimatedImpact,
    RecommendationPriority? priority,
    ExecutionDifficulty? difficulty,
    List<String>? requiredResources,
    DateTime? timestamp,
    bool? isExecuted,
  }) {
    return AIRecommendation(
      id: id ?? this.id,
      incidentId: incidentId ?? this.incidentId,
      title: title ?? this.title,
      recommendation: recommendation ?? this.recommendation,
      reasoning: reasoning ?? this.reasoning,
      estimatedImpact: estimatedImpact ?? this.estimatedImpact,
      priority: priority ?? this.priority,
      difficulty: difficulty ?? this.difficulty,
      requiredResources: requiredResources ?? this.requiredResources,
      timestamp: timestamp ?? this.timestamp,
      isExecuted: isExecuted ?? this.isExecuted,
    );
  }
}

/// Recommended action item inside an incident analysis.
class ActionItem {
  final String id;
  final String action;
  final String responsibleUnit;
  final bool isCompleted;

  const ActionItem({
    required this.id,
    required this.action,
    required this.responsibleUnit,
    this.isCompleted = false,
  });

  ActionItem copyWith({
    String? id,
    String? action,
    String? responsibleUnit,
    bool? isCompleted,
  }) {
    return ActionItem(
      id: id ?? this.id,
      action: action ?? this.action,
      responsibleUnit: responsibleUnit ?? this.responsibleUnit,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Domain entity representing deep multi-sensor AI incident analysis.
class IncidentAnalysis {
  final String id;
  final String title;
  final IncidentType incidentType;
  final IncidentSeverity severity;
  final String district;
  final String affectedArea;
  final int estimatedPopulation;
  final int riskScore; // 0 - 100
  final double aiConfidence; // 0.0 - 1.0 (e.g. 0.94 for 94%)
  final List<ActionItem> recommendedActions;
  final List<String> environmentalFactors;
  final DateTime analyzedAt;
  final String summaryNotes;
  final double latitude;
  final double longitude;

  const IncidentAnalysis({
    required this.id,
    required this.title,
    required this.incidentType,
    required this.severity,
    required this.district,
    required this.affectedArea,
    required this.estimatedPopulation,
    required this.riskScore,
    required this.aiConfidence,
    required this.recommendedActions,
    required this.environmentalFactors,
    required this.analyzedAt,
    required this.summaryNotes,
    required this.latitude,
    required this.longitude,
  });

  int get confidencePercent => (aiConfidence * 100).toInt();

  IncidentAnalysis copyWith({
    String? id,
    String? title,
    IncidentType? incidentType,
    IncidentSeverity? severity,
    String? district,
    String? affectedArea,
    int? estimatedPopulation,
    int? riskScore,
    double? aiConfidence,
    List<ActionItem>? recommendedActions,
    List<String>? environmentalFactors,
    DateTime? analyzedAt,
    String? summaryNotes,
    double? latitude,
    double? longitude,
  }) {
    return IncidentAnalysis(
      id: id ?? this.id,
      title: title ?? this.title,
      incidentType: incidentType ?? this.incidentType,
      severity: severity ?? this.severity,
      district: district ?? this.district,
      affectedArea: affectedArea ?? this.affectedArea,
      estimatedPopulation: estimatedPopulation ?? this.estimatedPopulation,
      riskScore: riskScore ?? this.riskScore,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      recommendedActions: recommendedActions ?? this.recommendedActions,
      environmentalFactors: environmentalFactors ?? this.environmentalFactors,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      summaryNotes: summaryNotes ?? this.summaryNotes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

/// Message within an AI Commander tactical dialogue.
class AIChatMessage {
  final String id;
  final String text;
  final ChatSender sender;
  final DateTime timestamp;
  final List<String>? actionSuggestions;
  final String? relatedIncidentId;
  final bool isGenerating;

  const AIChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.actionSuggestions,
    this.relatedIncidentId,
    this.isGenerating = false,
  });
}

/// Chat dialogue session entity.
class AIChatSession {
  final String id;
  final String title;
  final String district;
  final DateTime createdAt;
  final List<AIChatMessage> messages;

  const AIChatSession({
    required this.id,
    required this.title,
    required this.district,
    required this.createdAt,
    required this.messages,
  });
}

/// Real-time disaster situation summary (SitRep) generated by AI Commander.
class SituationSummary {
  final String id;
  final String headline;
  final String incidentOverview;
  final List<String> resourcesDeployed;
  final List<String> emergingRisks;
  final List<String> suggestedNextActions;
  final DateTime? generatedAt;
  final String primaryDistrict;
  final int totalEvacuees;
  final int activeMissions;

  const SituationSummary({
    required this.id,
    required this.headline,
    required this.incidentOverview,
    required this.resourcesDeployed,
    required this.emergingRisks,
    required this.suggestedNextActions,
    this.generatedAt,
    required this.primaryDistrict,
    required this.totalEvacuees,
    required this.activeMissions,
  });

  static const SituationSummary empty = SituationSummary(
    id: '',
    headline: '',
    incidentOverview: '',
    resourcesDeployed: [],
    emergingRisks: [],
    suggestedNextActions: [],
    generatedAt: null,
    primaryDistrict: '',
    totalEvacuees: 0,
    activeMissions: 0,
  );
}

/// High-level metrics for AI Commander dashboard.
class AICommanderSummary {
  final int activeAISessions;
  final int incidentsAnalyzed;
  final int recommendationsGenerated;
  final int highRiskAlerts;
  final double averageConfidence;
  final int executedRecommendations;

  const AICommanderSummary({
    required this.activeAISessions,
    required this.incidentsAnalyzed,
    required this.recommendationsGenerated,
    required this.highRiskAlerts,
    required this.averageConfidence,
    required this.executedRecommendations,
  });

  static const AICommanderSummary empty = AICommanderSummary(
    activeAISessions: 0,
    incidentsAnalyzed: 0,
    recommendationsGenerated: 0,
    highRiskAlerts: 0,
    averageConfidence: 0.0,
    executedRecommendations: 0,
  );
}
