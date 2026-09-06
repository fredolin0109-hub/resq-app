import '../../domain/entities/digital_twin_entities.dart';

/// DTO Model for HeatmapPoint.
class HeatmapPointModel extends HeatmapPoint {
  const HeatmapPointModel({
    required super.id,
    required super.latitude,
    required super.longitude,
    required super.intensity,
    required super.radiusMeters,
    required super.layerType,
    required super.district,
    required super.description,
  });

  factory HeatmapPointModel.fromJson(Map<String, dynamic> json) {
    final layerIdx = (json['layerType'] as num?)?.toInt() ?? 0;
    return HeatmapPointModel(
      id: json['id'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      intensity: (json['intensity'] as num?)?.toDouble() ?? 0.5,
      radiusMeters: (json['radiusMeters'] as num?)?.toDouble() ?? 500.0,
      layerType: layerIdx >= 0 && layerIdx < HeatmapLayerType.values.length
          ? HeatmapLayerType.values[layerIdx]
          : HeatmapLayerType.flood,
      district: json['district'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'intensity': intensity,
        'radiusMeters': radiusMeters,
        'layerType': layerType.index,
        'district': district,
        'description': description,
      };

  HeatmapPoint toEntity() => this;
}

/// DTO Model for InfrastructureAsset.
class InfrastructureAssetModel extends InfrastructureAsset {
  const InfrastructureAssetModel({
    required super.id,
    required super.name,
    required super.type,
    required super.status,
    required super.district,
    required super.locationAddress,
    required super.latitude,
    required super.longitude,
    required super.operationalCapacityRatio,
    required super.lastInspected,
    required super.telemetryNotes,
  });

  factory InfrastructureAssetModel.fromJson(Map<String, dynamic> json) {
    final typeIdx = (json['type'] as num?)?.toInt() ?? 0;
    final statusIdx = (json['status'] as num?)?.toInt() ?? 0;

    return InfrastructureAssetModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: typeIdx >= 0 && typeIdx < InfrastructureType.values.length
          ? InfrastructureType.values[typeIdx]
          : InfrastructureType.road,
      status: statusIdx >= 0 && statusIdx < InfrastructureStatus.values.length
          ? InfrastructureStatus.values[statusIdx]
          : InfrastructureStatus.operational,
      district: json['district'] as String? ?? '',
      locationAddress: json['locationAddress'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      operationalCapacityRatio: (json['operationalCapacityRatio'] as num?)?.toDouble() ?? 1.0,
      lastInspected: json['lastInspected'] != null
          ? DateTime.tryParse(json['lastInspected'] as String) ?? DateTime.now()
          : DateTime.now(),
      telemetryNotes: json['telemetryNotes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.index,
        'status': status.index,
        'district': district,
        'locationAddress': locationAddress,
        'latitude': latitude,
        'longitude': longitude,
        'operationalCapacityRatio': operationalCapacityRatio,
        'lastInspected': lastInspected.toIso8601String(),
        'telemetryNotes': telemetryNotes,
      };

  InfrastructureAsset toEntity() => this;
}

/// DTO Model for TimelineEvent.
class TimelineEventModel extends TimelineEvent {
  const TimelineEventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.eventType,
    required super.district,
    required super.incidentId,
    required super.timestamp,
    required super.affectedCount,
    required super.loggedBy,
  });

  factory TimelineEventModel.fromJson(Map<String, dynamic> json) {
    final typeIdx = (json['eventType'] as num?)?.toInt() ?? 0;
    return TimelineEventModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      eventType: typeIdx >= 0 && typeIdx < TimelineEventType.values.length
          ? TimelineEventType.values[typeIdx]
          : TimelineEventType.incidentReported,
      district: json['district'] as String? ?? '',
      incidentId: json['incidentId'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      affectedCount: (json['affectedCount'] as num?)?.toInt() ?? 0,
      loggedBy: json['loggedBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'eventType': eventType.index,
        'district': district,
        'incidentId': incidentId,
        'timestamp': timestamp.toIso8601String(),
        'affectedCount': affectedCount,
        'loggedBy': loggedBy,
      };

  TimelineEvent toEntity() => this;
}

/// DTO Model for DigitalTwinPrediction.
class DigitalTwinPredictionModel extends DigitalTwinPrediction {
  const DigitalTwinPredictionModel({
    required super.id,
    required super.title,
    required super.type,
    required super.district,
    required super.affectedZone,
    required super.riskScore,
    required super.confidenceRatio,
    required super.timeHorizon,
    required super.projectedOutcome,
    required super.preventiveAction,
    required super.generatedAt,
  });

  factory DigitalTwinPredictionModel.fromJson(Map<String, dynamic> json) {
    final typeIdx = (json['type'] as num?)?.toInt() ?? 0;
    return DigitalTwinPredictionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: typeIdx >= 0 && typeIdx < PredictionType.values.length
          ? PredictionType.values[typeIdx]
          : PredictionType.floodExpansion,
      district: json['district'] as String? ?? '',
      affectedZone: json['affectedZone'] as String? ?? '',
      riskScore: (json['riskScore'] as num?)?.toInt() ?? 50,
      confidenceRatio: (json['confidenceRatio'] as num?)?.toDouble() ?? 0.85,
      timeHorizon: json['timeHorizon'] as String? ?? 'Next 2 hours',
      projectedOutcome: json['projectedOutcome'] as String? ?? '',
      preventiveAction: json['preventiveAction'] as String? ?? '',
      generatedAt: json['generatedAt'] != null
          ? DateTime.tryParse(json['generatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.index,
        'district': district,
        'affectedZone': affectedZone,
        'riskScore': riskScore,
        'confidenceRatio': confidenceRatio,
        'timeHorizon': timeHorizon,
        'projectedOutcome': projectedOutcome,
        'preventiveAction': preventiveAction,
        'generatedAt': generatedAt.toIso8601String(),
      };

  DigitalTwinPrediction toEntity() => this;
}
