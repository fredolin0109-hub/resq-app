import '../entities/team_management_entities.dart';
import '../repositories/team_management_repository.dart';

/// UseCase retrieving teams and summary metrics.
class GetTeamsUseCase {
  final TeamManagementRepository repository;

  const GetTeamsUseCase(this.repository);

  Future<List<RescueTeamDetailEntity>> call() async {
    return await repository.getTeams();
  }

  Future<TeamsSummaryMetrics> getSummary() async {
    return await repository.getTeamsSummary();
  }
}

/// UseCase retrieving fleet vehicles and assets.
class GetVehiclesUseCase {
  final TeamManagementRepository repository;

  const GetVehiclesUseCase(this.repository);

  Future<List<VehicleEntity>> call() async {
    return await repository.getVehicles();
  }

  Future<FleetSummaryMetrics> getSummary() async {
    return await repository.getFleetSummary();
  }
}

/// UseCase dispatching a squad with vehicle and gear assignments.
class DispatchTeamUseCase {
  final TeamManagementRepository repository;

  const DispatchTeamUseCase(this.repository);

  Future<RescueTeamDetailEntity> call({
    required String teamId,
    required String missionId,
    required String priority,
    required String targetLocation,
    VehicleEntity? vehicle,
    List<String>? equipment,
  }) async {
    return await repository.dispatchTeam(
      teamId: teamId,
      missionId: missionId,
      priority: priority,
      targetLocation: targetLocation,
      vehicle: vehicle,
      equipment: equipment,
    );
  }
}
