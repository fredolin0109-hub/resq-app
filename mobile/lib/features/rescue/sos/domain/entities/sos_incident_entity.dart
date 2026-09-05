import 'package:flutter/foundation.dart';

enum SosPriority {
  critical,
  high,
  medium,
  low,
}

enum SosStatus {
  received,
  assigned,
  enRoute,
  onScene,
  rescueCompleted,
  closed,
}

/// Rescue team squad available for emergency dispatch.
@immutable
class RescueTeamEntity {
  final String id;
  final String name;
  final String vehicle;
  final String members;
  final List<String> equipment;
  final double distanceKm;
  final int estimatedArrivalMinutes;
  final bool isAvailable;

  const RescueTeamEntity({
    required this.id,
    required this.name,
    required this.vehicle,
    required this.members,
    required this.equipment,
    required this.distanceKm,
    required this.estimatedArrivalMinutes,
    this.isAvailable = true,
  });
}

/// Step event in the rescue mission progression lifecycle.
@immutable
class SosTimelineEvent {
  final SosStatus status;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;

  const SosTimelineEvent({
    required this.status,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isCompleted,
  });

  SosTimelineEvent copyWith({
    SosStatus? status,
    String? title,
    String? description,
    DateTime? timestamp,
    bool? isCompleted,
  }) {
    return SosTimelineEvent(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Core domain entity representing an individual Live SOS distress incident.
@immutable
class SosIncidentEntity {
  final String id;
  final String emergencyType;
  final SosPriority priority;
  final SosStatus status;
  final String civilianName;
  final String civilianPhone;
  final String district;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final int peopleCount;
  final String riskLevel;
  final List<String> nearbyHospitals;
  final List<String> nearbyShelters;
  final RescueTeamEntity? assignedTeam;
  final List<String> imagePlaceholders;
  final String notes;
  final DateTime createdAt;
  final List<SosTimelineEvent> timeline;

  const SosIncidentEntity({
    required this.id,
    required this.emergencyType,
    required this.priority,
    required this.status,
    required this.civilianName,
    required this.civilianPhone,
    required this.district,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.peopleCount,
    required this.riskLevel,
    required this.nearbyHospitals,
    required this.nearbyShelters,
    this.assignedTeam,
    required this.imagePlaceholders,
    required this.notes,
    required this.createdAt,
    required this.timeline,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  SosIncidentEntity copyWith({
    String? id,
    String? emergencyType,
    SosPriority? priority,
    SosStatus? status,
    String? civilianName,
    String? civilianPhone,
    String? district,
    String? locationAddress,
    double? latitude,
    double? longitude,
    double? distanceKm,
    int? peopleCount,
    String? riskLevel,
    List<String>? nearbyHospitals,
    List<String>? nearbyShelters,
    RescueTeamEntity? assignedTeam,
    bool clearAssignedTeam = false,
    List<String>? imagePlaceholders,
    String? notes,
    DateTime? createdAt,
    List<SosTimelineEvent>? timeline,
  }) {
    return SosIncidentEntity(
      id: id ?? this.id,
      emergencyType: emergencyType ?? this.emergencyType,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      civilianName: civilianName ?? this.civilianName,
      civilianPhone: civilianPhone ?? this.civilianPhone,
      district: district ?? this.district,
      locationAddress: locationAddress ?? this.locationAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceKm: distanceKm ?? this.distanceKm,
      peopleCount: peopleCount ?? this.peopleCount,
      riskLevel: riskLevel ?? this.riskLevel,
      nearbyHospitals: nearbyHospitals ?? this.nearbyHospitals,
      nearbyShelters: nearbyShelters ?? this.nearbyShelters,
      assignedTeam: clearAssignedTeam ? null : (assignedTeam ?? this.assignedTeam),
      imagePlaceholders: imagePlaceholders ?? this.imagePlaceholders,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      timeline: timeline ?? this.timeline,
    );
  }
}

/// Dashboard top summary metric counters.
@immutable
class SosSummaryMetrics {
  final int newAlerts;
  final int assigned;
  final int enRoute;
  final int resolved;
  final int highPriority;

  const SosSummaryMetrics({
    required this.newAlerts,
    required this.assigned,
    required this.enRoute,
    required this.resolved,
    required this.highPriority,
  });
}

/// Filter criteria for querying SOS alerts.
@immutable
class SosFilterOptions {
  final String? emergencyType;
  final SosPriority? priority;
  final SosStatus? status;
  final String? district;

  const SosFilterOptions({
    this.emergencyType,
    this.priority,
    this.status,
    this.district,
  });

  bool get hasActiveFilter =>
      emergencyType != null || priority != null || status != null || district != null;

  SosFilterOptions copyWith({
    String? emergencyType,
    bool clearType = false,
    SosPriority? priority,
    bool clearPriority = false,
    SosStatus? status,
    bool clearStatus = false,
    String? district,
    bool clearDistrict = false,
  }) {
    return SosFilterOptions(
      emergencyType: clearType ? null : (emergencyType ?? this.emergencyType),
      priority: clearPriority ? null : (priority ?? this.priority),
      status: clearStatus ? null : (status ?? this.status),
      district: clearDistrict ? null : (district ?? this.district),
    );
  }
}
