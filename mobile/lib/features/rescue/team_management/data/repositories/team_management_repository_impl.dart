import '../../domain/entities/team_management_entities.dart';
import '../../domain/repositories/team_management_repository.dart';
import '../datasources/team_management_mock_datasource.dart';

/// Concrete repository implementation for Rescue Team and Fleet operations.
class TeamManagementRepositoryImpl implements TeamManagementRepository {
  final TeamManagementDataSource dataSource;

  TeamManagementRepositoryImpl({TeamManagementDataSource? dataSource})
      : dataSource = dataSource ?? TeamManagementMockDataSource();

  @override
  Future<List<RescueTeamDetailEntity>> getTeams() async {
    return await dataSource.fetchTeams();
  }

  @override
  Future<RescueTeamDetailEntity?> getTeamById(String id) async {
    return await dataSource.fetchTeamById(id);
  }

  @override
  Future<List<VehicleEntity>> getVehicles() async {
    return await dataSource.fetchVehicles();
  }

  @override
  Future<VehicleEntity?> getVehicleById(String id) async {
    return await dataSource.fetchVehicleById(id);
  }

  @override
  Future<List<TeamMemberEntity>> getPersonnel() async {
    return await dataSource.fetchPersonnel();
  }

  @override
  Future<TeamsSummaryMetrics> getTeamsSummary() async {
    final teams = await dataSource.fetchTeams();
    int active = 0;
    int available = 0;
    int onMission = 0;

    for (final t in teams) {
      if (t.status != TeamStatus.offline) active++;
      if (t.status == TeamStatus.available) available++;
      if (t.status == TeamStatus.busy || t.status == TeamStatus.emergency) onMission++;
    }

    return TeamsSummaryMetrics(
      totalTeams: teams.length,
      activeTeams: active,
      availableTeams: available,
      teamsOnMission: onMission,
    );
  }

  @override
  Future<FleetSummaryMetrics> getFleetSummary() async {
    final vehicles = await dataSource.fetchVehicles();
    int ambulances = 0;
    int fireTrucks = 0;
    int boats = 0;
    int drones = 0;
    int earthMovers = 0;
    int support = 0;

    for (final v in vehicles) {
      switch (v.type) {
        case VehicleType.ambulance:
          ambulances++;
          break;
        case VehicleType.fireTruck:
          fireTrucks++;
          break;
        case VehicleType.rescueBoat:
          boats++;
          break;
        case VehicleType.drone:
          drones++;
          break;
        case VehicleType.earthMover:
          earthMovers++;
          break;
        case VehicleType.supportVehicle:
          support++;
          break;
      }
    }

    return FleetSummaryMetrics(
      ambulances: ambulances,
      fireTrucks: fireTrucks,
      rescueBoats: boats,
      drones: drones,
      earthMovers: earthMovers,
      supportVehicles: support,
    );
  }

  @override
  Future<RescueTeamDetailEntity> dispatchTeam({
    required String teamId,
    required String missionId,
    required String priority,
    required String targetLocation,
    VehicleEntity? vehicle,
    List<String>? equipment,
  }) async {
    return await dataSource.dispatchTeam(
      teamId: teamId,
      missionId: missionId,
      priority: priority,
      targetLocation: targetLocation,
      vehicle: vehicle,
      equipment: equipment,
    );
  }
}
