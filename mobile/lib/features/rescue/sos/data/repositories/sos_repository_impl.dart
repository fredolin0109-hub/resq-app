import '../../domain/entities/sos_incident_entity.dart';
import '../../domain/repositories/sos_repository.dart';
import '../datasources/sos_mock_datasource.dart';
import '../models/sos_incident_model.dart';

/// Concrete repository implementation for SOS commands.
class SosRepositoryImpl implements SosRepository {
  final SosDataSource dataSource;

  SosRepositoryImpl({SosDataSource? dataSource})
      : dataSource = dataSource ?? SosMockDataSource();

  @override
  Future<List<SosIncidentEntity>> getAllIncidents() async {
    return await dataSource.fetchAllIncidents();
  }

  @override
  Future<SosIncidentEntity?> getIncidentById(String id) async {
    return await dataSource.fetchIncidentById(id);
  }

  @override
  Future<List<RescueTeamEntity>> getAvailableTeams() async {
    return await dataSource.fetchAvailableTeams();
  }

  @override
  Future<SosIncidentEntity> assignTeamToIncident({
    required String incidentId,
    required RescueTeamEntity team,
  }) async {
    final teamModel = RescueTeamModel(
      id: team.id,
      name: team.name,
      vehicle: team.vehicle,
      members: team.members,
      equipment: team.equipment,
      distanceKm: team.distanceKm,
      estimatedArrivalMinutes: team.estimatedArrivalMinutes,
      isAvailable: team.isAvailable,
    );
    return await dataSource.assignTeam(incidentId, teamModel);
  }

  @override
  Future<SosIncidentEntity> updateIncidentStatus({
    required String incidentId,
    required SosStatus status,
    String? note,
  }) async {
    return await dataSource.updateStatus(incidentId, status, note);
  }

  @override
  Future<SosSummaryMetrics> getSummaryMetrics() async {
    final incidents = await dataSource.fetchAllIncidents();
    int newAlerts = 0;
    int assigned = 0;
    int enRoute = 0;
    int resolved = 0;
    int highPriority = 0;

    for (final inc in incidents) {
      if (inc.status == SosStatus.received) newAlerts++;
      if (inc.status == SosStatus.assigned) assigned++;
      if (inc.status == SosStatus.enRoute || inc.status == SosStatus.onScene) enRoute++;
      if (inc.status == SosStatus.rescueCompleted || inc.status == SosStatus.closed) resolved++;
      if (inc.priority == SosPriority.critical || inc.priority == SosPriority.high) highPriority++;
    }

    return SosSummaryMetrics(
      newAlerts: newAlerts,
      assigned: assigned,
      enRoute: enRoute,
      resolved: resolved,
      highPriority: highPriority,
    );
  }
}
