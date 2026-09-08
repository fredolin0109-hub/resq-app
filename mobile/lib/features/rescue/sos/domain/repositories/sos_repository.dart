import '../entities/sos_incident_entity.dart';

/// Contract for managing Live SOS distress alerts, dispatches, and mission histories.
abstract class SosRepository {
  Future<List<SosIncidentEntity>> getAllIncidents();
  Future<SosIncidentEntity?> getIncidentById(String id);
  Future<List<RescueTeamEntity>> getAvailableTeams();
  Future<SosIncidentEntity> assignTeamToIncident({
    required String incidentId,
    required RescueTeamEntity team,
  });
  Future<SosIncidentEntity> updateIncidentStatus({
    required String incidentId,
    required SosStatus status,
    String? note,
  });
  Future<SosSummaryMetrics> getSummaryMetrics();
}
