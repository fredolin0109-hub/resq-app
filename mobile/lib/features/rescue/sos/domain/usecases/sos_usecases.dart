import '../entities/sos_incident_entity.dart';
import '../repositories/sos_repository.dart';

/// UseCase retrieving active and historical SOS incidents.
class GetSosIncidentsUseCase {
  final SosRepository repository;

  const GetSosIncidentsUseCase(this.repository);

  Future<List<SosIncidentEntity>> call() async {
    return await repository.getAllIncidents();
  }

  Future<SosSummaryMetrics> getMetrics() async {
    return await repository.getSummaryMetrics();
  }
}

/// UseCase retrieving available rescue teams for emergency assignment.
class GetAvailableTeamsUseCase {
  final SosRepository repository;

  const GetAvailableTeamsUseCase(this.repository);

  Future<List<RescueTeamEntity>> call() async {
    return await repository.getAvailableTeams();
  }
}

/// UseCase assigning a rescue team to an active SOS mission.
class AssignTeamUseCase {
  final SosRepository repository;

  const AssignTeamUseCase(this.repository);

  Future<SosIncidentEntity> call({
    required String incidentId,
    required RescueTeamEntity team,
  }) async {
    return await repository.assignTeamToIncident(
      incidentId: incidentId,
      team: team,
    );
  }
}

/// UseCase updating live SOS mission lifecycle status.
class UpdateSosStatusUseCase {
  final SosRepository repository;

  const UpdateSosStatusUseCase(this.repository);

  Future<SosIncidentEntity> call({
    required String incidentId,
    required SosStatus status,
    String? note,
  }) async {
    return await repository.updateIncidentStatus(
      incidentId: incidentId,
      status: status,
      note: note,
    );
  }
}
