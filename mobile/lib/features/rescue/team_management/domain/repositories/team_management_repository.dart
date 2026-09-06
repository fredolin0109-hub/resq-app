import '../entities/team_management_entities.dart';

/// Contract for managing rescue squads, fleet assets, and personnel dispatches.
abstract class TeamManagementRepository {
  Future<List<RescueTeamDetailEntity>> getTeams();
  Future<RescueTeamDetailEntity?> getTeamById(String id);
  Future<List<VehicleEntity>> getVehicles();
  Future<VehicleEntity?> getVehicleById(String id);
  Future<List<TeamMemberEntity>> getPersonnel();
  Future<TeamsSummaryMetrics> getTeamsSummary();
  Future<FleetSummaryMetrics> getFleetSummary();
  Future<RescueTeamDetailEntity> dispatchTeam({
    required String teamId,
    required String missionId,
    required String priority,
    required String targetLocation,
    VehicleEntity? vehicle,
    List<String>? equipment,
  });
}
