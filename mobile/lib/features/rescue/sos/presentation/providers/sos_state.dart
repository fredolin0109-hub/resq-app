import 'package:flutter/foundation.dart';
import '../../domain/entities/sos_incident_entity.dart';

enum SosCommandStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// Immutable state container for the Live SOS Command Center.
@immutable
class SosState {
  final SosCommandStatus status;
  final List<SosIncidentEntity> allIncidents;
  final List<SosIncidentEntity> filteredIncidents;
  final SosIncidentEntity? selectedIncident;
  final List<RescueTeamEntity> availableTeams;
  final SosSummaryMetrics? metrics;
  final SosFilterOptions filterOptions;
  final String searchQuery;
  final String? errorMessage;
  final bool isAssigning;
  final bool isUpdatingStatus;

  const SosState({
    required this.status,
    this.allIncidents = const [],
    this.filteredIncidents = const [],
    this.selectedIncident,
    this.availableTeams = const [],
    this.metrics,
    this.filterOptions = const SosFilterOptions(),
    this.searchQuery = '',
    this.errorMessage,
    this.isAssigning = false,
    this.isUpdatingStatus = false,
  });

  factory SosState.initial() => const SosState(status: SosCommandStatus.initial);

  factory SosState.loading() => const SosState(status: SosCommandStatus.loading);

  factory SosState.error(String message) => SosState(
        status: SosCommandStatus.error,
        errorMessage: message,
      );

  bool get isLoading => status == SosCommandStatus.loading;
  bool get isLoaded => status == SosCommandStatus.loaded;
  bool get isEmpty => status == SosCommandStatus.empty;
  bool get isError => status == SosCommandStatus.error;

  SosState copyWith({
    SosCommandStatus? status,
    List<SosIncidentEntity>? allIncidents,
    List<SosIncidentEntity>? filteredIncidents,
    SosIncidentEntity? selectedIncident,
    bool clearSelectedIncident = false,
    List<RescueTeamEntity>? availableTeams,
    SosSummaryMetrics? metrics,
    SosFilterOptions? filterOptions,
    String? searchQuery,
    String? errorMessage,
    bool? isAssigning,
    bool? isUpdatingStatus,
  }) {
    return SosState(
      status: status ?? this.status,
      allIncidents: allIncidents ?? this.allIncidents,
      filteredIncidents: filteredIncidents ?? this.filteredIncidents,
      selectedIncident: clearSelectedIncident ? null : (selectedIncident ?? this.selectedIncident),
      availableTeams: availableTeams ?? this.availableTeams,
      metrics: metrics ?? this.metrics,
      filterOptions: filterOptions ?? this.filterOptions,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      isAssigning: isAssigning ?? this.isAssigning,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
    );
  }
}
