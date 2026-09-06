import '../../domain/entities/ai_commander_entities.dart';

/// DTO Model for ActionItem.
class ActionItemModel extends ActionItem {
  const ActionItemModel({
    required super.id,
    required super.action,
    required super.responsibleUnit,
    super.isCompleted,
  });

  factory ActionItemModel.fromJson(Map<String, dynamic> json) {
    return ActionItemModel(
      id: json['id'] as String? ?? '',
      action: json['action'] as String? ?? '',
      responsibleUnit: json['responsibleUnit'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'action': action,
        'responsibleUnit': responsibleUnit,
        'isCompleted': isCompleted,
      };
}

/// DTO Model for IncidentAnalysis.
class IncidentAnalysisModel extends IncidentAnalysis {
  const IncidentAnalysisModel({
    required super.id,
    required super.title,
    required super.incidentType,
    required super.severity,
    required super.district,
    required super.affectedArea,
    required super.estimatedPopulation,
    required super.riskScore,
    required super.aiConfidence,
    required super.recommendedActions,
    required super.environmentalFactors,
    required super.analyzedAt,
    required super.summaryNotes,
    required super.latitude,
    required super.longitude,
  });

  factory IncidentAnalysisModel.fromJson(Map<String, dynamic> json) {
    final typeIdx = (json['incidentType'] as num?)?.toInt() ?? 0;
    final sevIdx = (json['severity'] as num?)?.toInt() ?? 0;

    final actionsList = (json['recommendedActions'] as List<dynamic>?)
            ?.map((e) => ActionItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final factorsList = (json['environmentalFactors'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return IncidentAnalysisModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      incidentType: typeIdx >= 0 && typeIdx < IncidentType.values.length
          ? IncidentType.values[typeIdx]
          : IncidentType.flood,
      severity: sevIdx >= 0 && sevIdx < IncidentSeverity.values.length
          ? IncidentSeverity.values[sevIdx]
          : IncidentSeverity.high,
      district: json['district'] as String? ?? '',
      affectedArea: json['affectedArea'] as String? ?? '',
      estimatedPopulation: (json['estimatedPopulation'] as num?)?.toInt() ?? 0,
      riskScore: (json['riskScore'] as num?)?.toInt() ?? 50,
      aiConfidence: (json['aiConfidence'] as num?)?.toDouble() ?? 0.85,
      recommendedActions: actionsList,
      environmentalFactors: factorsList,
      analyzedAt: json['analyzedAt'] != null
          ? DateTime.tryParse(json['analyzedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      summaryNotes: json['summaryNotes'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'incidentType': incidentType.index,
        'severity': severity.index,
        'district': district,
        'affectedArea': affectedArea,
        'estimatedPopulation': estimatedPopulation,
        'riskScore': riskScore,
        'aiConfidence': aiConfidence,
        'recommendedActions': recommendedActions.map((e) {
          if (e is ActionItemModel) return e.toJson();
          return {
            'id': e.id,
            'action': e.action,
            'responsibleUnit': e.responsibleUnit,
            'isCompleted': e.isCompleted,
          };
        }).toList(),
        'environmentalFactors': environmentalFactors,
        'analyzedAt': analyzedAt.toIso8601String(),
        'summaryNotes': summaryNotes,
        'latitude': latitude,
        'longitude': longitude,
      };

  IncidentAnalysis toEntity() => this;
}

/// DTO Model for AIRecommendation.
class AIRecommendationModel extends AIRecommendation {
  const AIRecommendationModel({
    required super.id,
    required super.incidentId,
    required super.title,
    required super.recommendation,
    required super.reasoning,
    required super.estimatedImpact,
    required super.priority,
    required super.difficulty,
    required super.requiredResources,
    required super.timestamp,
    super.isExecuted,
  });

  factory AIRecommendationModel.fromJson(Map<String, dynamic> json) {
    final prioIdx = (json['priority'] as num?)?.toInt() ?? 0;
    final diffIdx = (json['difficulty'] as num?)?.toInt() ?? 0;
    final resList = (json['requiredResources'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return AIRecommendationModel(
      id: json['id'] as String? ?? '',
      incidentId: json['incidentId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      recommendation: json['recommendation'] as String? ?? '',
      reasoning: json['reasoning'] as String? ?? '',
      estimatedImpact: json['estimatedImpact'] as String? ?? '',
      priority: prioIdx >= 0 && prioIdx < RecommendationPriority.values.length
          ? RecommendationPriority.values[prioIdx]
          : RecommendationPriority.high,
      difficulty: diffIdx >= 0 && diffIdx < ExecutionDifficulty.values.length
          ? ExecutionDifficulty.values[diffIdx]
          : ExecutionDifficulty.moderate,
      requiredResources: resList,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      isExecuted: json['isExecuted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'incidentId': incidentId,
        'title': title,
        'recommendation': recommendation,
        'reasoning': reasoning,
        'estimatedImpact': estimatedImpact,
        'priority': priority.index,
        'difficulty': difficulty.index,
        'requiredResources': requiredResources,
        'timestamp': timestamp.toIso8601String(),
        'isExecuted': isExecuted,
      };

  AIRecommendation toEntity() => this;
}

/// DTO Model for AIChatMessage.
class AIChatMessageModel extends AIChatMessage {
  const AIChatMessageModel({
    required super.id,
    required super.text,
    required super.sender,
    required super.timestamp,
    super.actionSuggestions,
    super.relatedIncidentId,
    super.isGenerating,
  });

  factory AIChatMessageModel.fromJson(Map<String, dynamic> json) {
    final senderIdx = (json['sender'] as num?)?.toInt() ?? 0;
    final suggestions = (json['actionSuggestions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return AIChatMessageModel(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      sender: senderIdx >= 0 && senderIdx < ChatSender.values.length
          ? ChatSender.values[senderIdx]
          : ChatSender.user,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      actionSuggestions: suggestions,
      relatedIncidentId: json['relatedIncidentId'] as String?,
      isGenerating: json['isGenerating'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'sender': sender.index,
        'timestamp': timestamp.toIso8601String(),
        'actionSuggestions': actionSuggestions,
        'relatedIncidentId': relatedIncidentId,
        'isGenerating': isGenerating,
      };

  AIChatMessage toEntity() => this;
}

/// DTO Model for AIChatSession.
class AIChatSessionModel extends AIChatSession {
  const AIChatSessionModel({
    required super.id,
    required super.title,
    required super.district,
    required super.createdAt,
    required super.messages,
  });

  factory AIChatSessionModel.fromJson(Map<String, dynamic> json) {
    final msgs = (json['messages'] as List<dynamic>?)
            ?.map((e) => AIChatMessageModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return AIChatSessionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      district: json['district'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      messages: msgs,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'district': district,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((e) {
          if (e is AIChatMessageModel) return e.toJson();
          return {
            'id': e.id,
            'text': e.text,
            'sender': e.sender.index,
            'timestamp': e.timestamp.toIso8601String(),
            'actionSuggestions': e.actionSuggestions,
            'relatedIncidentId': e.relatedIncidentId,
            'isGenerating': e.isGenerating,
          };
        }).toList(),
      };

  AIChatSession toEntity() => this;
}
