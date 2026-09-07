import 'package:flutter/material.dart';

/// Heatmap overlay layer category.
enum HeatmapLayerType {
  flood,
  fire,
  cyclone,
  earthquake,
  landslide,
  storm,
  medical,
  infrastructure,
  populationDensity,
  riskDensity,
}

extension HeatmapLayerTypeX on HeatmapLayerType {
  String get displayName {
    switch (this) {
      case HeatmapLayerType.flood:
        return 'Flood Inundation';
      case HeatmapLayerType.fire:
        return 'Fire & Thermal';
      case HeatmapLayerType.cyclone:
        return 'Cyclone Wind Field';
      case HeatmapLayerType.earthquake:
        return 'Seismic Tremor';
      case HeatmapLayerType.landslide:
        return 'Landslide Hazard';
      case HeatmapLayerType.storm:
        return 'Storm Surge';
      case HeatmapLayerType.medical:
        return 'Medical Demand';
      case HeatmapLayerType.infrastructure:
        return 'Critical Infrastructure';
      case HeatmapLayerType.populationDensity:
        return 'Population Density';
      case HeatmapLayerType.riskDensity:
        return 'Composite Risk Density';
    }
  }

  IconData get icon {
    switch (this) {
      case HeatmapLayerType.flood:
        return Icons.flood_rounded;
      case HeatmapLayerType.fire:
        return Icons.local_fire_department_rounded;
      case HeatmapLayerType.cyclone:
        return Icons.cyclone_rounded;
      case HeatmapLayerType.earthquake:
        return Icons.vibration_rounded;
      case HeatmapLayerType.landslide:
        return Icons.landslide_rounded;
      case HeatmapLayerType.storm:
        return Icons.tsunami_rounded;
      case HeatmapLayerType.medical:
        return Icons.local_hospital_rounded;
      case HeatmapLayerType.infrastructure:
        return Icons.domain_rounded;
      case HeatmapLayerType.populationDensity:
        return Icons.people_alt_rounded;
      case HeatmapLayerType.riskDensity:
        return Icons.warning_amber_rounded;
    }
  }

  Color get defaultColor {
    switch (this) {
      case HeatmapLayerType.flood:
        return const Color(0xFF3B82F6);
      case HeatmapLayerType.fire:
        return const Color(0xFFEF4444);
      case HeatmapLayerType.cyclone:
        return const Color(0xFF8B5CF6);
      case HeatmapLayerType.earthquake:
        return const Color(0xFFD97706);
      case HeatmapLayerType.landslide:
        return const Color(0xFFB45309);
      case HeatmapLayerType.storm:
        return const Color(0xFF06B6D4);
      case HeatmapLayerType.medical:
        return const Color(0xFFEC4899);
      case HeatmapLayerType.infrastructure:
        return const Color(0xFF64748B);
      case HeatmapLayerType.populationDensity:
        return const Color(0xFF10B981);
      case HeatmapLayerType.riskDensity:
        return const Color(0xFFDC2626);
    }
  }
}

/// Physical and civil infrastructure asset type.
enum InfrastructureType {
  road,
  bridge,
  hospital,
  policeStation,
  fireStation,
  communicationTower,
  powerGrid,
  waterSupply,
}

extension InfrastructureTypeX on InfrastructureType {
  String get displayName {
    switch (this) {
      case InfrastructureType.road:
        return 'Highway / Road Network';
      case InfrastructureType.bridge:
        return 'River / Canal Bridge';
      case InfrastructureType.hospital:
        return 'Emergency Hospital';
      case InfrastructureType.policeStation:
        return 'Police Station / Command';
      case InfrastructureType.fireStation:
        return 'Fire & Rescue Station';
      case InfrastructureType.communicationTower:
        return 'Cellular / Sat Tower';
      case InfrastructureType.powerGrid:
        return 'Power Grid / Substation';
      case InfrastructureType.waterSupply:
        return 'Water Supply / Treatment';
    }
  }

  IconData get icon {
    switch (this) {
      case InfrastructureType.road:
        return Icons.alt_route_rounded;
      case InfrastructureType.bridge:
        return Icons.apartment_rounded;
      case InfrastructureType.hospital:
        return Icons.local_hospital_rounded;
      case InfrastructureType.policeStation:
        return Icons.local_police_rounded;
      case InfrastructureType.fireStation:
        return Icons.local_fire_department_rounded;
      case InfrastructureType.communicationTower:
        return Icons.cell_tower_rounded;
      case InfrastructureType.powerGrid:
        return Icons.electric_bolt_rounded;
      case InfrastructureType.waterSupply:
        return Icons.water_drop_rounded;
    }
  }
}

/// Operational status of an infrastructure asset.
enum InfrastructureStatus {
  operational,
  damaged,
  offline,
  critical,
}

extension InfrastructureStatusX on InfrastructureStatus {
  String get displayName {
    switch (this) {
      case InfrastructureStatus.operational:
        return 'Operational';
      case InfrastructureStatus.damaged:
        return 'Damaged';
      case InfrastructureStatus.offline:
        return 'Offline';
      case InfrastructureStatus.critical:
        return 'Critical Breach';
    }
  }

  Color get color {
    switch (this) {
      case InfrastructureStatus.operational:
        return const Color(0xFF10B981); // Green
      case InfrastructureStatus.damaged:
        return const Color(0xFFF59E0B); // Amber/Yellow
      case InfrastructureStatus.offline:
        return const Color(0xFF6B7280); // Grey
      case InfrastructureStatus.critical:
        return const Color(0xFFEF4444); // Red
    }
  }
}

/// Timeline event category for chronological disaster audit stream.
enum TimelineEventType {
  incidentReported,
  aiAnalysis,
  resourcesAssigned,
  teamsDispatched,
  victimsRescued,
  sheltersActivated,
  missionCompleted,
}

extension TimelineEventTypeX on TimelineEventType {
  String get displayName {
    switch (this) {
      case TimelineEventType.incidentReported:
        return 'Incident Reported';
      case TimelineEventType.aiAnalysis:
        return 'AI Predictive Analysis';
      case TimelineEventType.resourcesAssigned:
        return 'Resources Assigned';
      case TimelineEventType.teamsDispatched:
        return 'Rescue Teams Dispatched';
      case TimelineEventType.victimsRescued:
        return 'Victims Rescued';
      case TimelineEventType.sheltersActivated:
        return 'Shelter Activated';
      case TimelineEventType.missionCompleted:
        return 'Mission Completed';
    }
  }

  IconData get icon {
    switch (this) {
      case TimelineEventType.incidentReported:
        return Icons.report_problem_rounded;
      case TimelineEventType.aiAnalysis:
        return Icons.psychology_rounded;
      case TimelineEventType.resourcesAssigned:
        return Icons.inventory_2_rounded;
      case TimelineEventType.teamsDispatched:
        return Icons.local_shipping_rounded;
      case TimelineEventType.victimsRescued:
        return Icons.healing_rounded;
      case TimelineEventType.sheltersActivated:
        return Icons.night_shelter_rounded;
      case TimelineEventType.missionCompleted:
        return Icons.check_circle_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TimelineEventType.incidentReported:
        return const Color(0xFFEF4444);
      case TimelineEventType.aiAnalysis:
        return const Color(0xFF6366F1);
      case TimelineEventType.resourcesAssigned:
        return const Color(0xFFF59E0B);
      case TimelineEventType.teamsDispatched:
        return const Color(0xFF3B82F6);
      case TimelineEventType.victimsRescued:
        return const Color(0xFF10B981);
      case TimelineEventType.sheltersActivated:
        return const Color(0xFF8B5CF6);
      case TimelineEventType.missionCompleted:
        return const Color(0xFF059669);
    }
  }
}

/// AI prediction category.
enum PredictionType {
  floodExpansion,
  fireSpread,
  roadBlockage,
  resourceShortage,
  hospitalLoad,
  evacuationRecommendation,
}

extension PredictionTypeX on PredictionType {
  String get displayName {
    switch (this) {
      case PredictionType.floodExpansion:
        return 'Flood Inundation Expansion';
      case PredictionType.fireSpread:
        return 'Thermal Fire Spread';
      case PredictionType.roadBlockage:
        return 'Road Transit Blockage';
      case PredictionType.resourceShortage:
        return 'Resource Stockpile Depletion';
      case PredictionType.hospitalLoad:
        return 'Hospital ICU Surge';
      case PredictionType.evacuationRecommendation:
        return 'Evacuation Necessity';
    }
  }

  IconData get icon {
    switch (this) {
      case PredictionType.floodExpansion:
        return Icons.waves_rounded;
      case PredictionType.fireSpread:
        return Icons.local_fire_department_rounded;
      case PredictionType.roadBlockage:
        return Icons.no_transfer_rounded;
      case PredictionType.resourceShortage:
        return Icons.remove_shopping_cart_rounded;
      case PredictionType.hospitalLoad:
        return Icons.local_hospital_rounded;
      case PredictionType.evacuationRecommendation:
        return Icons.directions_run_rounded;
    }
  }
}

/// Simulation scenario hazard model.
enum SimulationType {
  flood,
  cyclone,
  earthquake,
  fire,
  landslide,
}

extension SimulationTypeX on SimulationType {
  String get displayName {
    switch (this) {
      case SimulationType.flood:
        return 'Flood Simulation';
      case SimulationType.cyclone:
        return 'Cyclone Wind Simulation';
      case SimulationType.earthquake:
        return 'Earthquake Tremor Simulation';
      case SimulationType.fire:
        return 'Urban Fire Spread Simulation';
      case SimulationType.landslide:
        return 'Landslide Runout Simulation';
    }
  }

  IconData get icon {
    switch (this) {
      case SimulationType.flood:
        return Icons.flood_rounded;
      case SimulationType.cyclone:
        return Icons.cyclone_rounded;
      case SimulationType.earthquake:
        return Icons.vibration_rounded;
      case SimulationType.fire:
        return Icons.local_fire_department_rounded;
      case SimulationType.landslide:
        return Icons.landslide_rounded;
    }
  }
}

/// Heatmap coordinate point in the Digital Twin.
class HeatmapPoint {
  final String id;
  final double latitude;
  final double longitude;
  final double intensity; // 0.0 - 1.0
  final double radiusMeters;
  final HeatmapLayerType layerType;
  final String district;
  final String description;

  const HeatmapPoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.intensity,
    required this.radiusMeters,
    required this.layerType,
    required this.district,
    required this.description,
  });
}

/// Infrastructure asset monitoring entity.
class InfrastructureAsset {
  final String id;
  final String name;
  final InfrastructureType type;
  final InfrastructureStatus status;
  final String district;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final double operationalCapacityRatio; // 0.0 - 1.0
  final DateTime lastInspected;
  final String telemetryNotes;

  const InfrastructureAsset({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.district,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.operationalCapacityRatio,
    required this.lastInspected,
    required this.telemetryNotes,
  });

  int get capacityPercent => (operationalCapacityRatio * 100).toInt();
}

/// Chronological event item in disaster operational history stream.
class TimelineEvent {
  final String id;
  final String title;
  final String description;
  final TimelineEventType eventType;
  final String district;
  final String incidentId;
  final DateTime timestamp;
  final int affectedCount;
  final String loggedBy;

  const TimelineEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.eventType,
    required this.district,
    required this.incidentId,
    required this.timestamp,
    required this.affectedCount,
    required this.loggedBy,
  });
}

/// Domain entity representing an AI Prediction forecast.
class DigitalTwinPrediction {
  final String id;
  final String title;
  final PredictionType type;
  final String district;
  final String affectedZone;
  final int riskScore; // 0 - 100
  final double confidenceRatio; // 0.0 - 1.0
  final String timeHorizon; // e.g. "Next 2 hours", "Next 6 hours"
  final String projectedOutcome;
  final String preventiveAction;
  final DateTime generatedAt;

  const DigitalTwinPrediction({
    required this.id,
    required this.title,
    required this.type,
    required this.district,
    required this.affectedZone,
    required this.riskScore,
    required this.confidenceRatio,
    required this.timeHorizon,
    required this.projectedOutcome,
    required this.preventiveAction,
    required this.generatedAt,
  });

  int get confidencePercent => (confidenceRatio * 100).toInt();
}

/// Real-time live analytics telemetry datapoint.
class LiveAnalyticsData {
  final int incidentCount;
  final List<double> riskTrend; // e.g. [65, 70, 78, 85, 92, 88, 84]
  final List<double> precipitationTrend; // mm/hr [12, 25, 45, 60, 52, 38, 20]
  final int populationImpacted;
  final double roadAvailabilityRatio; // 0.74 (74% operational)
  final double waterLevelMeters;
  final double waterLevelDangerThreshold;
  final bool powerGridStable;
  final double communicationTowerUptime; // 0.96 (96% online)

  const LiveAnalyticsData({
    required this.incidentCount,
    required this.riskTrend,
    required this.precipitationTrend,
    required this.populationImpacted,
    required this.roadAvailabilityRatio,
    required this.waterLevelMeters,
    required this.waterLevelDangerThreshold,
    required this.powerGridStable,
    required this.communicationTowerUptime,
  });

  int get roadAvailabilityPercent => (roadAvailabilityRatio * 100).toInt();
  int get commsUptimePercent => (communicationTowerUptime * 100).toInt();
}

/// Digital Twin summary metrics for command center dashboard.
class DigitalTwinSummary {
  final int activeIncidents;
  final int highRiskDistricts;
  final int activeRescueTeams;
  final int availableResourcesCount;
  final int sheltersOccupied;
  final int totalShelters;
  final int hospitalsAvailable;
  final int totalHospitals;
  final int populationAtRisk;
  final double aiPredictionAccuracy; // 0.94 (94%)

  const DigitalTwinSummary({
    required this.activeIncidents,
    required this.highRiskDistricts,
    required this.activeRescueTeams,
    required this.availableResourcesCount,
    required this.sheltersOccupied,
    required this.totalShelters,
    required this.hospitalsAvailable,
    required this.totalHospitals,
    required this.populationAtRisk,
    required this.aiPredictionAccuracy,
  });

  static const DigitalTwinSummary empty = DigitalTwinSummary(
    activeIncidents: 0,
    highRiskDistricts: 0,
    activeRescueTeams: 0,
    availableResourcesCount: 0,
    sheltersOccupied: 0,
    totalShelters: 0,
    hospitalsAvailable: 0,
    totalHospitals: 0,
    populationAtRisk: 0,
    aiPredictionAccuracy: 0.90,
  );
}

/// Interactive Disaster Simulation State.
class DisasterSimulation {
  final SimulationType type;
  final String title;
  final String district;
  final double progress; // 0.0 to 1.0 (0% to 100%)
  final bool isPlaying;
  final double speedMultiplier; // 1.0, 2.0, 5.0, 10.0
  final int simulatedCasualtiesPrevented;
  final int estimatedEvacuated;
  final String statusDescription;

  const DisasterSimulation({
    required this.type,
    required this.title,
    required this.district,
    required this.progress,
    required this.isPlaying,
    required this.speedMultiplier,
    required this.simulatedCasualtiesPrevented,
    required this.estimatedEvacuated,
    required this.statusDescription,
  });

  DisasterSimulation copyWith({
    SimulationType? type,
    String? title,
    String? district,
    double? progress,
    bool? isPlaying,
    double? speedMultiplier,
    int? simulatedCasualtiesPrevented,
    int? estimatedEvacuated,
    String? statusDescription,
  }) {
    return DisasterSimulation(
      type: type ?? this.type,
      title: title ?? this.title,
      district: district ?? this.district,
      progress: progress ?? this.progress,
      isPlaying: isPlaying ?? this.isPlaying,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      simulatedCasualtiesPrevented: simulatedCasualtiesPrevented ?? this.simulatedCasualtiesPrevented,
      estimatedEvacuated: estimatedEvacuated ?? this.estimatedEvacuated,
      statusDescription: statusDescription ?? this.statusDescription,
    );
  }
}
