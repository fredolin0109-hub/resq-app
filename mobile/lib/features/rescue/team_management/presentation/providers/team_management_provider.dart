import 'package:flutter/foundation.dart';
import '../../data/datasources/team_management_mock_datasource.dart';
import '../../data/repositories/team_management_repository_impl.dart';
import '../../domain/entities/team_management_entities.dart';
import '../../domain/repositories/team_management_repository.dart';
import '../../domain/usecases/team_management_usecases.dart';
import 'team_management_state.dart';

/// Riverpod / Notifier provider coordinating squads, fleet inventory, and dispatch actions.
class TeamManagementNotifier extends ChangeNotifier {
  final GetTeamsUseCase _getTeamsUseCase;
  final GetVehiclesUseCase _getVehiclesUseCase;
  final DispatchTeamUseCase _dispatchTeamUseCase;

  TeamManagementState _state = TeamManagementState.initial();

  TeamManagementNotifier({
    required GetTeamsUseCase getTeamsUseCase,
    required GetVehiclesUseCase getVehiclesUseCase,
    required DispatchTeamUseCase dispatchTeamUseCase,
  })  : _getTeamsUseCase = getTeamsUseCase,
        _getVehiclesUseCase = getVehiclesUseCase,
        _dispatchTeamUseCase = dispatchTeamUseCase;

  TeamManagementState get state => _state;

  Future<void> loadDashboard() async {
    _state = TeamManagementState.loading();
    notifyListeners();

    try {
      final teams = await _getTeamsUseCase();
      final vehicles = await _getVehiclesUseCase();
      final teamsSummary = await _getTeamsUseCase.getSummary();
      final fleetSummary = await _getVehiclesUseCase.getSummary();

      final filteredTeams = _applyTeamFilters(teams, _state.filterOptions);
      final filteredVehicles = _applyVehicleFilters(vehicles, _state.filterOptions);

      _state = _state.copyWith(
        status: filteredTeams.isEmpty ? TeamManagementStatus.empty : TeamManagementStatus.loaded,
        allTeams: teams,
        filteredTeams: filteredTeams,
        allVehicles: vehicles,
        filteredVehicles: filteredVehicles,
        teamsSummary: teamsSummary,
        fleetSummary: fleetSummary,
      );
      notifyListeners();
    } catch (e) {
      _state = TeamManagementState.error(e.toString().replaceFirst('Exception: ', ''));
      notifyListeners();
    }
  }

  void search(String query) {
    final opts = _state.filterOptions.copyWith(searchQuery: query);
    _state = _state.copyWith(filterOptions: opts);
    _reapplyFilters();
  }

  void updateFilters(TeamFilterOptions newOpts) {
    _state = _state.copyWith(filterOptions: newOpts);
    _reapplyFilters();
  }

  void selectTeam(RescueTeamDetailEntity team) {
    _state = _state.copyWith(selectedTeam: team);
    notifyListeners();
  }

  void selectTeamById(String id) {
    try {
      final team = _state.allTeams.firstWhere((t) => t.id == id);
      _state = _state.copyWith(selectedTeam: team);
      notifyListeners();
    } catch (_) {}
  }

  void selectVehicle(VehicleEntity vehicle) {
    _state = _state.copyWith(selectedVehicle: vehicle);
    notifyListeners();
  }

  Future<bool> dispatchSquad({
    required String teamId,
    required String missionId,
    required String priority,
    required String targetLocation,
    VehicleEntity? vehicle,
    List<String>? equipment,
  }) async {
    _state = _state.copyWith(isDispatching: true);
    notifyListeners();

    try {
      final updated = await _dispatchTeamUseCase(
        teamId: teamId,
        missionId: missionId,
        priority: priority,
        targetLocation: targetLocation,
        vehicle: vehicle,
        equipment: equipment,
      );

      final updatedAll = _state.allTeams.map((t) => t.id == teamId ? updated : t).toList();
      final teamsSummary = await _getTeamsUseCase.getSummary();
      final fleetSummary = await _getVehiclesUseCase.getSummary();
      final vehicles = await _getVehiclesUseCase();

      final filtered = _applyTeamFilters(updatedAll, _state.filterOptions);

      _state = _state.copyWith(
        isDispatching: false,
        allTeams: updatedAll,
        filteredTeams: filtered,
        selectedTeam: updated,
        teamsSummary: teamsSummary,
        fleetSummary: fleetSummary,
        allVehicles: vehicles,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        isDispatching: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
      return false;
    }
  }

  void _reapplyFilters() {
    final filteredTeams = _applyTeamFilters(_state.allTeams, _state.filterOptions);
    final filteredVehicles = _applyVehicleFilters(_state.allVehicles, _state.filterOptions);

    _state = _state.copyWith(
      status: filteredTeams.isEmpty && filteredVehicles.isEmpty
          ? TeamManagementStatus.empty
          : TeamManagementStatus.loaded,
      filteredTeams: filteredTeams,
      filteredVehicles: filteredVehicles,
    );
    notifyListeners();
  }

  List<RescueTeamDetailEntity> _applyTeamFilters(
    List<RescueTeamDetailEntity> list,
    TeamFilterOptions opts,
  ) {
    return list.where((team) {
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final matches = team.name.toLowerCase().contains(q) ||
            team.leaderName.toLowerCase().contains(q) ||
            team.district.toLowerCase().contains(q) ||
            (team.assignedVehicle?.vehicleNumber.toLowerCase().contains(q) ?? false);
        if (!matches) return false;
      }

      if (opts.district != null &&
          !team.district.toLowerCase().contains(opts.district!.toLowerCase())) {
        return false;
      }

      if (opts.status != null && team.status != opts.status) {
        return false;
      }

      if (opts.vehicleType != null && team.assignedVehicle?.type != opts.vehicleType) {
        return false;
      }

      return true;
    }).toList();
  }

  List<VehicleEntity> _applyVehicleFilters(
    List<VehicleEntity> list,
    TeamFilterOptions opts,
  ) {
    return list.where((v) {
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final matches = v.vehicleNumber.toLowerCase().contains(q) ||
            v.typeName.toLowerCase().contains(q) ||
            v.currentDriver.toLowerCase().contains(q) ||
            v.district.toLowerCase().contains(q);
        if (!matches) return false;
      }

      if (opts.district != null &&
          !v.district.toLowerCase().contains(opts.district!.toLowerCase())) {
        return false;
      }

      if (opts.vehicleType != null && v.type != opts.vehicleType) {
        return false;
      }

      return true;
    }).toList();
  }
}

/// Dependency Container for Team and Fleet Management
class TeamManagementDependencies {
  static TeamManagementDataSource? _dataSource;
  static TeamManagementRepository? _repository;
  static GetTeamsUseCase? _getTeamsUseCase;
  static GetVehiclesUseCase? _getVehiclesUseCase;
  static DispatchTeamUseCase? _dispatchTeamUseCase;
  static TeamManagementNotifier? _notifier;

  static TeamManagementDataSource get dataSource =>
      _dataSource ??= TeamManagementMockDataSource();

  static TeamManagementRepository get repository =>
      _repository ??= TeamManagementRepositoryImpl(dataSource: dataSource);

  static GetTeamsUseCase get getTeamsUseCase =>
      _getTeamsUseCase ??= GetTeamsUseCase(repository);

  static GetVehiclesUseCase get getVehiclesUseCase =>
      _getVehiclesUseCase ??= GetVehiclesUseCase(repository);

  static DispatchTeamUseCase get dispatchTeamUseCase =>
      _dispatchTeamUseCase ??= DispatchTeamUseCase(repository);

  static TeamManagementNotifier get notifier => _notifier ??= TeamManagementNotifier(
        getTeamsUseCase: getTeamsUseCase,
        getVehiclesUseCase: getVehiclesUseCase,
        dispatchTeamUseCase: dispatchTeamUseCase,
      );

  @visibleForTesting
  static void overrideWith({
    TeamManagementDataSource? mockDataSource,
    TeamManagementRepository? mockRepository,
    TeamManagementNotifier? mockNotifier,
  }) {
    _dataSource = mockDataSource;
    _repository = mockRepository;
    _notifier = mockNotifier;
  }

  @visibleForTesting
  static void reset() {
    _dataSource = null;
    _repository = null;
    _getTeamsUseCase = null;
    _getVehiclesUseCase = null;
    _dispatchTeamUseCase = null;
    _notifier = null;
  }
}
