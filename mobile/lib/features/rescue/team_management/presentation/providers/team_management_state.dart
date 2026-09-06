import 'package:flutter/foundation.dart';
import '../../domain/entities/team_management_entities.dart';

enum TeamManagementStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// Immutable state container for Rescue Teams & Fleet Management.
@immutable
class TeamManagementState {
  final TeamManagementStatus status;
  final List<RescueTeamDetailEntity> allTeams;
  final List<RescueTeamDetailEntity> filteredTeams;
  final RescueTeamDetailEntity? selectedTeam;
  final List<VehicleEntity> allVehicles;
  final List<VehicleEntity> filteredVehicles;
  final VehicleEntity? selectedVehicle;
  final TeamsSummaryMetrics? teamsSummary;
  final FleetSummaryMetrics? fleetSummary;
  final TeamFilterOptions filterOptions;
  final String? errorMessage;
  final bool isDispatching;

  const TeamManagementState({
    required this.status,
    this.allTeams = const [],
    this.filteredTeams = const [],
    this.selectedTeam,
    this.allVehicles = const [],
    this.filteredVehicles = const [],
    this.selectedVehicle,
    this.teamsSummary,
    this.fleetSummary,
    this.filterOptions = const TeamFilterOptions(),
    this.errorMessage,
    this.isDispatching = false,
  });

  factory TeamManagementState.initial() =>
      const TeamManagementState(status: TeamManagementStatus.initial);

  factory TeamManagementState.loading() =>
      const TeamManagementState(status: TeamManagementStatus.loading);

  factory TeamManagementState.error(String message) => TeamManagementState(
        status: TeamManagementStatus.error,
        errorMessage: message,
      );

  bool get isLoading => status == TeamManagementStatus.loading;
  bool get isLoaded => status == TeamManagementStatus.loaded;
  bool get isEmpty => status == TeamManagementStatus.empty;
  bool get isError => status == TeamManagementStatus.error;

  TeamManagementState copyWith({
    TeamManagementStatus? status,
    List<RescueTeamDetailEntity>? allTeams,
    List<RescueTeamDetailEntity>? filteredTeams,
    RescueTeamDetailEntity? selectedTeam,
    bool clearSelectedTeam = false,
    List<VehicleEntity>? allVehicles,
    List<VehicleEntity>? filteredVehicles,
    VehicleEntity? selectedVehicle,
    bool clearSelectedVehicle = false,
    TeamsSummaryMetrics? teamsSummary,
    FleetSummaryMetrics? fleetSummary,
    TeamFilterOptions? filterOptions,
    String? errorMessage,
    bool? isDispatching,
  }) {
    return TeamManagementState(
      status: status ?? this.status,
      allTeams: allTeams ?? this.allTeams,
      filteredTeams: filteredTeams ?? this.filteredTeams,
      selectedTeam: clearSelectedTeam ? null : (selectedTeam ?? this.selectedTeam),
      allVehicles: allVehicles ?? this.allVehicles,
      filteredVehicles: filteredVehicles ?? this.filteredVehicles,
      selectedVehicle: clearSelectedVehicle ? null : (selectedVehicle ?? this.selectedVehicle),
      teamsSummary: teamsSummary ?? this.teamsSummary,
      fleetSummary: fleetSummary ?? this.fleetSummary,
      filterOptions: filterOptions ?? this.filterOptions,
      errorMessage: errorMessage ?? this.errorMessage,
      isDispatching: isDispatching ?? this.isDispatching,
    );
  }
}
