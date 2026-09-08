import 'package:flutter/foundation.dart';

enum TeamStatus {
  available,
  busy,
  emergency,
  offline,
}

enum VehicleType {
  ambulance,
  fireTruck,
  rescueBoat,
  drone,
  earthMover,
  supportVehicle,
}

enum VehicleStatus {
  available,
  dispatched,
  maintenance,
  offline,
}

enum MemberRole {
  teamLeader,
  paramedic,
  scubaDiver,
  heavyExtricationSpecialist,
  dronePilot,
  driverMechanic,
  generalResponder,
}

/// Rescue team personnel entity.
@immutable
class TeamMemberEntity {
  final String id;
  final String name;
  final MemberRole role;
  final String roleTitle;
  final String phone;
  final String badgeNumber;
  final bool isLeader;
  final String bloodGroup;
  final String certification;
  final bool isOnline;

  const TeamMemberEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.roleTitle,
    required this.phone,
    required this.badgeNumber,
    this.isLeader = false,
    required this.bloodGroup,
    required this.certification,
    this.isOnline = true,
  });
}

/// Rescue vehicle / fleet asset entity.
@immutable
class VehicleEntity {
  final String id;
  final String vehicleNumber;
  final VehicleType type;
  final String typeName;
  final int capacity;
  final int fuelPercentage;
  final int batteryPercentage;
  final String maintenanceStatus;
  final String currentDriver;
  final String location;
  final String district;
  final VehicleStatus status;

  const VehicleEntity({
    required this.id,
    required this.vehicleNumber,
    required this.type,
    required this.typeName,
    required this.capacity,
    required this.fuelPercentage,
    required this.batteryPercentage,
    required this.maintenanceStatus,
    required this.currentDriver,
    required this.location,
    required this.district,
    required this.status,
  });

  bool get isAvailable => status == VehicleStatus.available;
}

/// Full rescue squad telemetry entity.
@immutable
class RescueTeamDetailEntity {
  final String id;
  final String name;
  final String district;
  final TeamStatus status;
  final String leaderName;
  final String leaderPhone;
  final int membersCount;
  final List<TeamMemberEntity> members;
  final VehicleEntity? assignedVehicle;
  final String? currentMission;
  final List<String> equipment;
  final List<String> medicalKits;
  final List<String> communicationDevices;
  final int fuelLevel;
  final int batteryLevel;
  final String gpsCoordinates;
  final int missionHistoryCount;
  final List<String> pastMissions;

  const RescueTeamDetailEntity({
    required this.id,
    required this.name,
    required this.district,
    required this.status,
    required this.leaderName,
    required this.leaderPhone,
    required this.membersCount,
    required this.members,
    this.assignedVehicle,
    this.currentMission,
    required this.equipment,
    required this.medicalKits,
    required this.communicationDevices,
    required this.fuelLevel,
    required this.batteryLevel,
    required this.gpsCoordinates,
    required this.missionHistoryCount,
    required this.pastMissions,
  });

  bool get isAvailable => status == TeamStatus.available;

  RescueTeamDetailEntity copyWith({
    String? id,
    String? name,
    String? district,
    TeamStatus? status,
    String? leaderName,
    String? leaderPhone,
    int? membersCount,
    List<TeamMemberEntity>? members,
    VehicleEntity? assignedVehicle,
    bool clearVehicle = false,
    String? currentMission,
    bool clearMission = false,
    List<String>? equipment,
    List<String>? medicalKits,
    List<String>? communicationDevices,
    int? fuelLevel,
    int? batteryLevel,
    String? gpsCoordinates,
    int? missionHistoryCount,
    List<String>? pastMissions,
  }) {
    return RescueTeamDetailEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      status: status ?? this.status,
      leaderName: leaderName ?? this.leaderName,
      leaderPhone: leaderPhone ?? this.leaderPhone,
      membersCount: membersCount ?? this.membersCount,
      members: members ?? this.members,
      assignedVehicle: clearVehicle ? null : (assignedVehicle ?? this.assignedVehicle),
      currentMission: clearMission ? null : (currentMission ?? this.currentMission),
      equipment: equipment ?? this.equipment,
      medicalKits: medicalKits ?? this.medicalKits,
      communicationDevices: communicationDevices ?? this.communicationDevices,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      gpsCoordinates: gpsCoordinates ?? this.gpsCoordinates,
      missionHistoryCount: missionHistoryCount ?? this.missionHistoryCount,
      pastMissions: pastMissions ?? this.pastMissions,
    );
  }
}

/// Aggregate metrics for teams.
@immutable
class TeamsSummaryMetrics {
  final int totalTeams;
  final int activeTeams;
  final int availableTeams;
  final int teamsOnMission;

  const TeamsSummaryMetrics({
    required this.totalTeams,
    required this.activeTeams,
    required this.availableTeams,
    required this.teamsOnMission,
  });
}

/// Aggregate metrics for fleet assets.
@immutable
class FleetSummaryMetrics {
  final int ambulances;
  final int fireTrucks;
  final int rescueBoats;
  final int drones;
  final int earthMovers;
  final int supportVehicles;

  const FleetSummaryMetrics({
    required this.ambulances,
    required this.fireTrucks,
    required this.rescueBoats,
    required this.drones,
    required this.earthMovers,
    required this.supportVehicles,
  });

  int get totalVehicles =>
      ambulances + fireTrucks + rescueBoats + drones + earthMovers + supportVehicles;
}

/// Filter options for querying teams and vehicles.
@immutable
class TeamFilterOptions {
  final String? district;
  final TeamStatus? status;
  final VehicleType? vehicleType;
  final String searchQuery;

  const TeamFilterOptions({
    this.district,
    this.status,
    this.vehicleType,
    this.searchQuery = '',
  });

  bool get hasActiveFilters => district != null || status != null || vehicleType != null;

  TeamFilterOptions copyWith({
    String? district,
    bool clearDistrict = false,
    TeamStatus? status,
    bool clearStatus = false,
    VehicleType? vehicleType,
    bool clearVehicleType = false,
    String? searchQuery,
  }) {
    return TeamFilterOptions(
      district: clearDistrict ? null : (district ?? this.district),
      status: clearStatus ? null : (status ?? this.status),
      vehicleType: clearVehicleType ? null : (vehicleType ?? this.vehicleType),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
