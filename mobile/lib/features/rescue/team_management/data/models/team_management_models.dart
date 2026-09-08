import '../../domain/entities/team_management_entities.dart';

/// DTO Model for [TeamMemberEntity].
class TeamMemberModel extends TeamMemberEntity {
  const TeamMemberModel({
    required super.id,
    required super.name,
    required super.role,
    required super.roleTitle,
    required super.phone,
    required super.badgeNumber,
    super.isLeader,
    required super.bloodGroup,
    required super.certification,
    super.isOnline,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: _parseRole(json['role'] as String?),
      roleTitle: json['role_title'] as String? ?? 'Field Responder',
      phone: json['phone'] as String? ?? '+91 90000 00000',
      badgeNumber: json['badge_number'] as String? ?? 'RSQ-00',
      isLeader: json['is_leader'] as bool? ?? false,
      bloodGroup: json['blood_group'] as String? ?? 'O+',
      certification: json['certification'] as String? ?? 'Level 1 Responder',
      isOnline: json['is_online'] as bool? ?? true,
    );
  }

  static MemberRole _parseRole(String? r) {
    switch (r?.toLowerCase()) {
      case 'team_leader':
      case 'teamleader':
        return MemberRole.teamLeader;
      case 'paramedic':
        return MemberRole.paramedic;
      case 'scuba_diver':
      case 'scubadiver':
        return MemberRole.scubaDiver;
      case 'heavy_extrication':
      case 'heavy_extrication_specialist':
        return MemberRole.heavyExtricationSpecialist;
      case 'drone_pilot':
      case 'dronepilot':
        return MemberRole.dronePilot;
      case 'driver_mechanic':
      case 'driver':
        return MemberRole.driverMechanic;
      default:
        return MemberRole.generalResponder;
    }
  }
}

/// DTO Model for [VehicleEntity].
class VehicleModel extends VehicleEntity {
  const VehicleModel({
    required super.id,
    required super.vehicleNumber,
    required super.type,
    required super.typeName,
    required super.capacity,
    required super.fuelPercentage,
    required super.batteryPercentage,
    required super.maintenanceStatus,
    required super.currentDriver,
    required super.location,
    required super.district,
    required super.status,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      vehicleNumber: json['vehicle_number'] as String,
      type: _parseVehicleType(json['type'] as String?),
      typeName: json['type_name'] as String? ?? 'Support Vehicle',
      capacity: json['capacity'] as int? ?? 4,
      fuelPercentage: json['fuel_percentage'] as int? ?? 100,
      batteryPercentage: json['battery_percentage'] as int? ?? 100,
      maintenanceStatus: json['maintenance_status'] as String? ?? 'Operational',
      currentDriver: json['current_driver'] as String? ?? 'Officer Driver',
      location: json['location'] as String? ?? 'Central Depot',
      district: json['district'] as String? ?? 'Dindigul',
      status: _parseVehicleStatus(json['status'] as String?),
    );
  }

  static VehicleType _parseVehicleType(String? t) {
    switch (t?.toLowerCase()) {
      case 'ambulance':
        return VehicleType.ambulance;
      case 'fire_truck':
      case 'firetruck':
        return VehicleType.fireTruck;
      case 'rescue_boat':
      case 'rescueboat':
        return VehicleType.rescueBoat;
      case 'drone':
        return VehicleType.drone;
      case 'earth_mover':
      case 'earthmover':
        return VehicleType.earthMover;
      case 'support_vehicle':
      default:
        return VehicleType.supportVehicle;
    }
  }

  static VehicleStatus _parseVehicleStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'dispatched':
        return VehicleStatus.dispatched;
      case 'maintenance':
        return VehicleStatus.maintenance;
      case 'offline':
        return VehicleStatus.offline;
      case 'available':
      default:
        return VehicleStatus.available;
    }
  }
}

/// DTO Model for [RescueTeamDetailEntity].
class RescueTeamDetailModel extends RescueTeamDetailEntity {
  const RescueTeamDetailModel({
    required super.id,
    required super.name,
    required super.district,
    required super.status,
    required super.leaderName,
    required super.leaderPhone,
    required super.membersCount,
    required super.members,
    super.assignedVehicle,
    super.currentMission,
    required super.equipment,
    required super.medicalKits,
    required super.communicationDevices,
    required super.fuelLevel,
    required super.batteryLevel,
    required super.gpsCoordinates,
    required super.missionHistoryCount,
    required super.pastMissions,
  });

  factory RescueTeamDetailModel.fromJson(Map<String, dynamic> json) {
    return RescueTeamDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      district: json['district'] as String,
      status: _parseTeamStatus(json['status'] as String?),
      leaderName: json['leader_name'] as String,
      leaderPhone: json['leader_phone'] as String,
      membersCount: json['members_count'] as int? ?? 4,
      members: (json['members'] as List<dynamic>?)
              ?.map((m) => TeamMemberModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      assignedVehicle: json['assigned_vehicle'] != null
          ? VehicleModel.fromJson(json['assigned_vehicle'] as Map<String, dynamic>)
          : null,
      currentMission: json['current_mission'] as String?,
      equipment: (json['equipment'] as List<dynamic>?)?.cast<String>() ?? [],
      medicalKits: (json['medical_kits'] as List<dynamic>?)?.cast<String>() ?? [],
      communicationDevices: (json['communication_devices'] as List<dynamic>?)?.cast<String>() ?? [],
      fuelLevel: json['fuel_level'] as int? ?? 100,
      batteryLevel: json['battery_level'] as int? ?? 100,
      gpsCoordinates: json['gps_coordinates'] as String? ?? '10.3673° N, 77.9803° E',
      missionHistoryCount: json['mission_history_count'] as int? ?? 0,
      pastMissions: (json['past_missions'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  static TeamStatus _parseTeamStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'busy':
        return TeamStatus.busy;
      case 'emergency':
        return TeamStatus.emergency;
      case 'offline':
        return TeamStatus.offline;
      case 'available':
      default:
        return TeamStatus.available;
    }
  }
}
