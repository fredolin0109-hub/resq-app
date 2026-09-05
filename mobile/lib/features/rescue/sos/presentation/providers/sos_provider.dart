import 'package:flutter/foundation.dart';
import '../../data/datasources/sos_mock_datasource.dart';
import '../../data/repositories/sos_repository_impl.dart';
import '../../domain/entities/sos_incident_entity.dart';
import '../../domain/repositories/sos_repository.dart';
import '../../domain/usecases/sos_usecases.dart';
import 'sos_state.dart';

/// Riverpod / Notifier provider managing live SOS incident lifecycle, dispatching, and filtering.
class SosNotifier extends ChangeNotifier {
  final GetSosIncidentsUseCase _getIncidentsUseCase;
  final GetAvailableTeamsUseCase _getTeamsUseCase;
  final AssignTeamUseCase _assignTeamUseCase;
  final UpdateSosStatusUseCase _updateStatusUseCase;

  SosState _state = SosState.initial();

  SosNotifier({
    required GetSosIncidentsUseCase getIncidentsUseCase,
    required GetAvailableTeamsUseCase getTeamsUseCase,
    required AssignTeamUseCase assignTeamUseCase,
    required UpdateSosStatusUseCase updateStatusUseCase,
  })  : _getIncidentsUseCase = getIncidentsUseCase,
        _getTeamsUseCase = getTeamsUseCase,
        _assignTeamUseCase = assignTeamUseCase,
        _updateStatusUseCase = updateStatusUseCase;

  SosState get state => _state;

  Future<void> loadSosData() async {
    _state = SosState.loading();
    notifyListeners();

    try {
      final incidents = await _getIncidentsUseCase();
      final teams = await _getTeamsUseCase();
      final metrics = await _getIncidentsUseCase.getMetrics();

      final filtered = _applyFilterAndSearch(
        incidents,
        _state.searchQuery,
        _state.filterOptions,
      );

      _state = _state.copyWith(
        status: filtered.isEmpty ? SosCommandStatus.empty : SosCommandStatus.loaded,
        allIncidents: incidents,
        filteredIncidents: filtered,
        availableTeams: teams,
        metrics: metrics,
      );
      notifyListeners();
    } catch (e) {
      _state = SosState.error(e.toString().replaceFirst('Exception: ', ''));
      notifyListeners();
    }
  }

  void searchIncidents(String query) {
    _state = _state.copyWith(searchQuery: query);
    _reapplyFilters();
  }

  void updateFilters(SosFilterOptions newFilters) {
    _state = _state.copyWith(filterOptions: newFilters);
    _reapplyFilters();
  }

  void selectIncident(SosIncidentEntity incident) {
    _state = _state.copyWith(selectedIncident: incident);
    notifyListeners();
  }

  void selectIncidentById(String id) {
    try {
      final inc = _state.allIncidents.firstWhere((i) => i.id == id);
      _state = _state.copyWith(selectedIncident: inc);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> assignTeam(String incidentId, RescueTeamEntity team) async {
    _state = _state.copyWith(isAssigning: true);
    notifyListeners();

    try {
      final updatedIncident = await _assignTeamUseCase(
        incidentId: incidentId,
        team: team,
      );

      final updatedAll = _state.allIncidents.map((i) {
        return i.id == incidentId ? updatedIncident : i;
      }).toList();

      final updatedFiltered = _applyFilterAndSearch(
        updatedAll,
        _state.searchQuery,
        _state.filterOptions,
      );

      final metrics = await _getIncidentsUseCase.getMetrics();

      _state = _state.copyWith(
        isAssigning: false,
        allIncidents: updatedAll,
        filteredIncidents: updatedFiltered,
        selectedIncident: updatedIncident,
        metrics: metrics,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        isAssigning: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> advanceStatus(String incidentId, SosStatus nextStatus, {String? note}) async {
    _state = _state.copyWith(isUpdatingStatus: true);
    notifyListeners();

    try {
      final updatedIncident = await _updateStatusUseCase(
        incidentId: incidentId,
        status: nextStatus,
        note: note,
      );

      final updatedAll = _state.allIncidents.map((i) {
        return i.id == incidentId ? updatedIncident : i;
      }).toList();

      final updatedFiltered = _applyFilterAndSearch(
        updatedAll,
        _state.searchQuery,
        _state.filterOptions,
      );

      final metrics = await _getIncidentsUseCase.getMetrics();

      _state = _state.copyWith(
        isUpdatingStatus: false,
        allIncidents: updatedAll,
        filteredIncidents: updatedFiltered,
        selectedIncident: updatedIncident,
        metrics: metrics,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        isUpdatingStatus: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
      return false;
    }
  }

  void _reapplyFilters() {
    final filtered = _applyFilterAndSearch(
      _state.allIncidents,
      _state.searchQuery,
      _state.filterOptions,
    );

    _state = _state.copyWith(
      status: filtered.isEmpty ? SosCommandStatus.empty : SosCommandStatus.loaded,
      filteredIncidents: filtered,
    );
    notifyListeners();
  }

  List<SosIncidentEntity> _applyFilterAndSearch(
    List<SosIncidentEntity> list,
    String query,
    SosFilterOptions filters,
  ) {
    return list.where((inc) {
      // 1. Query Search Match
      if (query.trim().isNotEmpty) {
        final q = query.toLowerCase().trim();
        final matchesQuery = inc.id.toLowerCase().contains(q) ||
            inc.civilianName.toLowerCase().contains(q) ||
            inc.district.toLowerCase().contains(q) ||
            inc.emergencyType.toLowerCase().contains(q) ||
            inc.locationAddress.toLowerCase().contains(q);
        if (!matchesQuery) return false;
      }

      // 2. Emergency Type Filter
      if (filters.emergencyType != null &&
          !inc.emergencyType.toLowerCase().contains(filters.emergencyType!.toLowerCase())) {
        return false;
      }

      // 3. Priority Filter
      if (filters.priority != null && inc.priority != filters.priority) {
        return false;
      }

      // 4. Status Filter
      if (filters.status != null && inc.status != filters.status) {
        return false;
      }

      // 5. District Filter
      if (filters.district != null &&
          !inc.district.toLowerCase().contains(filters.district!.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  }
}

/// Global Dependency Container for SOS Command Center
class SosDependencies {
  static SosDataSource? _dataSource;
  static SosRepository? _repository;
  static GetSosIncidentsUseCase? _getIncidentsUseCase;
  static GetAvailableTeamsUseCase? _getTeamsUseCase;
  static AssignTeamUseCase? _assignTeamUseCase;
  static UpdateSosStatusUseCase? _updateStatusUseCase;
  static SosNotifier? _notifier;

  static SosDataSource get dataSource => _dataSource ??= SosMockDataSource();

  static SosRepository get repository =>
      _repository ??= SosRepositoryImpl(dataSource: dataSource);

  static GetSosIncidentsUseCase get getIncidentsUseCase =>
      _getIncidentsUseCase ??= GetSosIncidentsUseCase(repository);

  static GetAvailableTeamsUseCase get getTeamsUseCase =>
      _getTeamsUseCase ??= GetAvailableTeamsUseCase(repository);

  static AssignTeamUseCase get assignTeamUseCase =>
      _assignTeamUseCase ??= AssignTeamUseCase(repository);

  static UpdateSosStatusUseCase get updateStatusUseCase =>
      _updateStatusUseCase ??= UpdateSosStatusUseCase(repository);

  static SosNotifier get notifier => _notifier ??= SosNotifier(
        getIncidentsUseCase: getIncidentsUseCase,
        getTeamsUseCase: getTeamsUseCase,
        assignTeamUseCase: assignTeamUseCase,
        updateStatusUseCase: updateStatusUseCase,
      );

  @visibleForTesting
  static void overrideWith({
    SosDataSource? mockDataSource,
    SosRepository? mockRepository,
    SosNotifier? mockNotifier,
  }) {
    _dataSource = mockDataSource;
    _repository = mockRepository;
    _notifier = mockNotifier;
  }

  @visibleForTesting
  static void reset() {
    _dataSource = null;
    _repository = null;
    _getIncidentsUseCase = null;
    _getTeamsUseCase = null;
    _assignTeamUseCase = null;
    _updateStatusUseCase = null;
    _notifier = null;
  }
}
