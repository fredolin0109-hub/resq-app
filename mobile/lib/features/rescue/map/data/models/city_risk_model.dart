import '../../domain/entities/city_risk_entity.dart';

/// DTO Model for [CityRiskEntity].
class CityRiskModel extends CityRiskEntity {
  const CityRiskModel({
    required super.id,
    required super.name,
    required super.district,
    required super.area,
    required super.latitude,
    required super.longitude,
    required super.population,
    required super.riskLevel,
    required super.riskPercentage,
    required super.severityRadiusKm,
    required super.hospitalsCount,
    required super.hospitalNames,
    required super.sheltersCount,
    required super.shelterNames,
    required super.availableRescueTeams,
    required super.assignedTeams,
    required super.weather,
    required super.roadStatus,
    required super.activeHazards,
    required super.lastUpdated,
  });

  factory CityRiskModel.fromJson(Map<String, dynamic> json) {
    return CityRiskModel(
      id: json['id'] as String,
      name: json['name'] as String,
      district: json['district'] as String,
      area: json['area'] as String? ?? json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      population: json['population'] as String,
      riskLevel: _parseRisk(json['risk_level'] as String?),
      riskPercentage: json['risk_percentage'] as int? ?? 0,
      severityRadiusKm: (json['severity_radius_km'] as num?)?.toDouble() ?? 10.0,
      hospitalsCount: json['hospitals_count'] as int? ?? 0,
      hospitalNames: (json['hospital_names'] as List<dynamic>?)?.cast<String>() ?? [],
      sheltersCount: json['shelters_count'] as int? ?? 0,
      shelterNames: (json['shelter_names'] as List<dynamic>?)?.cast<String>() ?? [],
      availableRescueTeams: json['available_rescue_teams'] as int? ?? 0,
      assignedTeams: (json['assigned_teams'] as List<dynamic>?)?.cast<String>() ?? [],
      weather: json['weather'] as String? ?? '28°C Fair',
      roadStatus: _parseRoad(json['road_status'] as String?),
      activeHazards: (json['active_hazards'] as List<dynamic>?)
              ?.map((h) => _parseHazard(h as String?))
              .toList() ??
          [],
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : DateTime.now(),
    );
  }

  static RiskLevel _parseRisk(String? level) {
    switch (level?.toLowerCase()) {
      case 'high':
      case 'high_risk':
      case 'highrisk':
        return RiskLevel.highRisk;
      case 'moderate':
      case 'medium':
        return RiskLevel.moderate;
      case 'safe':
      case 'low':
      default:
        return RiskLevel.safe;
    }
  }

  static RoadStatus _parseRoad(String? road) {
    switch (road?.toLowerCase()) {
      case 'blocked':
      case 'blocked_flooded':
      case 'flooded':
        return RoadStatus.blockedFlooded;
      case 'caution':
      case 'passable':
      case 'passable_with_caution':
        return RoadStatus.passableWithCaution;
      case 'open':
      default:
        return RoadStatus.open;
    }
  }

  static HazardType _parseHazard(String? hazard) {
    switch (hazard?.toLowerCase()) {
      case 'flood':
        return HazardType.flood;
      case 'fire':
        return HazardType.fire;
      case 'landslide':
        return HazardType.landslide;
      case 'cyclone':
      default:
        return HazardType.cyclone;
    }
  }
}
