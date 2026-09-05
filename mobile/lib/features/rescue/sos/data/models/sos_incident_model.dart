import '../../domain/entities/sos_incident_entity.dart';

/// DTO Model for [RescueTeamEntity].
class RescueTeamModel extends RescueTeamEntity {
  const RescueTeamModel({
    required super.id,
    required super.name,
    required super.vehicle,
    required super.members,
    required super.equipment,
    required super.distanceKm,
    required super.estimatedArrivalMinutes,
    super.isAvailable,
  });

  factory RescueTeamModel.fromJson(Map<String, dynamic> json) {
    return RescueTeamModel(
      id: json['id'] as String,
      name: json['name'] as String,
      vehicle: json['vehicle'] as String,
      members: json['members'] as String,
      equipment: (json['equipment'] as List<dynamic>?)?.cast<String>() ?? [],
      distanceKm: (json['distance_km'] as num).toDouble(),
      estimatedArrivalMinutes: json['estimated_arrival_minutes'] as int? ?? 10,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'vehicle': vehicle,
        'members': members,
        'equipment': equipment,
        'distance_km': distanceKm,
        'estimated_arrival_minutes': estimatedArrivalMinutes,
        'is_available': isAvailable,
      };
}

/// DTO Model for [SosTimelineEvent].
class SosTimelineEventModel extends SosTimelineEvent {
  const SosTimelineEventModel({
    required super.status,
    required super.title,
    required super.description,
    required super.timestamp,
    required super.isCompleted,
  });

  factory SosTimelineEventModel.fromJson(Map<String, dynamic> json) {
    return SosTimelineEventModel(
      status: _parseStatus(json['status'] as String?),
      title: json['title'] as String? ?? 'Event',
      description: json['description'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      isCompleted: json['is_completed'] as bool? ?? true,
    );
  }

  static SosStatus _parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'assigned':
        return SosStatus.assigned;
      case 'enroute':
      case 'en_route':
        return SosStatus.enRoute;
      case 'onscene':
      case 'on_scene':
        return SosStatus.onScene;
      case 'rescuecompleted':
      case 'rescue_completed':
        return SosStatus.rescueCompleted;
      case 'closed':
        return SosStatus.closed;
      case 'received':
      default:
        return SosStatus.received;
    }
  }
}

/// DTO Model for [SosIncidentEntity].
class SosIncidentModel extends SosIncidentEntity {
  const SosIncidentModel({
    required super.id,
    required super.emergencyType,
    required super.priority,
    required super.status,
    required super.civilianName,
    required super.civilianPhone,
    required super.district,
    required super.locationAddress,
    required super.latitude,
    required super.longitude,
    required super.distanceKm,
    required super.peopleCount,
    required super.riskLevel,
    required super.nearbyHospitals,
    required super.nearbyShelters,
    super.assignedTeam,
    required super.imagePlaceholders,
    required super.notes,
    required super.createdAt,
    required super.timeline,
  });

  factory SosIncidentModel.fromJson(Map<String, dynamic> json) {
    return SosIncidentModel(
      id: json['id'] as String,
      emergencyType: json['emergency_type'] as String,
      priority: _parsePriority(json['priority'] as String?),
      status: _parseStatus(json['status'] as String?),
      civilianName: json['civilian_name'] as String,
      civilianPhone: json['civilian_phone'] as String,
      district: json['district'] as String,
      locationAddress: json['location_address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distanceKm: (json['distance_km'] as num).toDouble(),
      peopleCount: json['people_count'] as int? ?? 1,
      riskLevel: json['risk_level'] as String? ?? 'Moderate',
      nearbyHospitals: (json['nearby_hospitals'] as List<dynamic>?)?.cast<String>() ?? [],
      nearbyShelters: (json['nearby_shelters'] as List<dynamic>?)?.cast<String>() ?? [],
      assignedTeam: json['assigned_team'] != null
          ? RescueTeamModel.fromJson(json['assigned_team'] as Map<String, dynamic>)
          : null,
      imagePlaceholders: (json['image_placeholders'] as List<dynamic>?)?.cast<String>() ?? [],
      notes: json['notes'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => SosTimelineEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  static SosPriority _parsePriority(String? p) {
    switch (p?.toLowerCase()) {
      case 'critical':
        return SosPriority.critical;
      case 'high':
        return SosPriority.high;
      case 'medium':
        return SosPriority.medium;
      case 'low':
      default:
        return SosPriority.low;
    }
  }

  static SosStatus _parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'assigned':
        return SosStatus.assigned;
      case 'enroute':
      case 'en_route':
        return SosStatus.enRoute;
      case 'onscene':
      case 'on_scene':
        return SosStatus.onScene;
      case 'rescuecompleted':
      case 'rescue_completed':
        return SosStatus.rescueCompleted;
      case 'closed':
        return SosStatus.closed;
      case 'received':
      default:
        return SosStatus.received;
    }
  }
}
