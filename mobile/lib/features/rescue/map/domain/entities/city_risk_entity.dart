import 'package:flutter/foundation.dart';

enum RiskLevel {
  safe,
  moderate,
  highRisk,
}

enum RoadStatus {
  open,
  passableWithCaution,
  blockedFlooded,
}

enum HazardType {
  flood,
  fire,
  landslide,
  cyclone,
}

/// Geographic coordinate representation.
@immutable
class MapCoordinate {
  final double latitude;
  final double longitude;

  const MapCoordinate({
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapCoordinate &&
          other.latitude == latitude &&
          other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

/// Domain entity representing a Tamil Nadu city and its real-time disaster risk telemetry.
@immutable
class CityRiskEntity {
  final String id;
  final String name;
  final String district;
  final String area;
  final double latitude;
  final double longitude;
  final String population;
  final RiskLevel riskLevel;
  final int riskPercentage;
  final double severityRadiusKm;
  final int hospitalsCount;
  final List<String> hospitalNames;
  final int sheltersCount;
  final List<String> shelterNames;
  final int availableRescueTeams;
  final List<String> assignedTeams;
  final String weather;
  final RoadStatus roadStatus;
  final List<HazardType> activeHazards;
  final DateTime lastUpdated;

  const CityRiskEntity({
    required this.id,
    required this.name,
    required this.district,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.population,
    required this.riskLevel,
    required this.riskPercentage,
    required this.severityRadiusKm,
    required this.hospitalsCount,
    required this.hospitalNames,
    required this.sheltersCount,
    required this.shelterNames,
    required this.availableRescueTeams,
    required this.assignedTeams,
    required this.weather,
    required this.roadStatus,
    required this.activeHazards,
    required this.lastUpdated,
  });

  MapCoordinate get coordinate => MapCoordinate(latitude: latitude, longitude: longitude);

  CityRiskEntity copyWith({
    String? id,
    String? name,
    String? district,
    String? area,
    double? latitude,
    double? longitude,
    String? population,
    RiskLevel? riskLevel,
    int? riskPercentage,
    double? severityRadiusKm,
    int? hospitalsCount,
    List<String>? hospitalNames,
    int? sheltersCount,
    List<String>? shelterNames,
    int? availableRescueTeams,
    List<String>? assignedTeams,
    String? weather,
    RoadStatus? roadStatus,
    List<HazardType>? activeHazards,
    DateTime? lastUpdated,
  }) {
    return CityRiskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      area: area ?? this.area,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      population: population ?? this.population,
      riskLevel: riskLevel ?? this.riskLevel,
      riskPercentage: riskPercentage ?? this.riskPercentage,
      severityRadiusKm: severityRadiusKm ?? this.severityRadiusKm,
      hospitalsCount: hospitalsCount ?? this.hospitalsCount,
      hospitalNames: hospitalNames ?? this.hospitalNames,
      sheltersCount: sheltersCount ?? this.sheltersCount,
      shelterNames: shelterNames ?? this.shelterNames,
      availableRescueTeams: availableRescueTeams ?? this.availableRescueTeams,
      assignedTeams: assignedTeams ?? this.assignedTeams,
      weather: weather ?? this.weather,
      roadStatus: roadStatus ?? this.roadStatus,
      activeHazards: activeHazards ?? this.activeHazards,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Map display layer filter options.
@immutable
class MapFilterOptions {
  final bool showHospitals;
  final bool showShelters;
  final bool showRescueTeams;
  final bool showFloodLayer;
  final bool showFireLayer;
  final bool showLandslideLayer;
  final bool showTraffic;
  final bool showRiskCircles;

  const MapFilterOptions({
    this.showHospitals = true,
    this.showShelters = true,
    this.showRescueTeams = true,
    this.showFloodLayer = true,
    this.showFireLayer = true,
    this.showLandslideLayer = true,
    this.showTraffic = true,
    this.showRiskCircles = true,
  });

  MapFilterOptions copyWith({
    bool? showHospitals,
    bool? showShelters,
    bool? showRescueTeams,
    bool? showFloodLayer,
    bool? showFireLayer,
    bool? showLandslideLayer,
    bool? showTraffic,
    bool? showRiskCircles,
  }) {
    return MapFilterOptions(
      showHospitals: showHospitals ?? this.showHospitals,
      showShelters: showShelters ?? this.showShelters,
      showRescueTeams: showRescueTeams ?? this.showRescueTeams,
      showFloodLayer: showFloodLayer ?? this.showFloodLayer,
      showFireLayer: showFireLayer ?? this.showFireLayer,
      showLandslideLayer: showLandslideLayer ?? this.showLandslideLayer,
      showTraffic: showTraffic ?? this.showTraffic,
      showRiskCircles: showRiskCircles ?? this.showRiskCircles,
    );
  }
}
