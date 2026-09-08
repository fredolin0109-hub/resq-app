import 'package:flutter/foundation.dart';
import '../../data/datasources/rescue_dashboard_mock_datasource.dart';
import '../../data/repositories/rescue_dashboard_repository_impl.dart';
import '../../domain/repositories/rescue_dashboard_repository.dart';
import '../../domain/usecases/get_rescue_dashboard_data_usecase.dart';
import 'rescue_dashboard_state.dart';

/// State Notifier managing dashboard lifecycle, live updates, and data fetching.
class RescueDashboardNotifier extends ChangeNotifier {
  final GetRescueDashboardDataUseCase _getDashboardUseCase;
  RescueDashboardState _state = RescueDashboardState.initial();

  RescueDashboardNotifier(this._getDashboardUseCase);

  RescueDashboardState get state => _state;

  Future<void> loadDashboardData() async {
    _state = RescueDashboardState.loading();
    notifyListeners();

    try {
      final data = await _getDashboardUseCase(forceRefresh: false);
      if (data.incidents.isEmpty) {
        _state = RescueDashboardState.empty(data);
      } else {
        _state = RescueDashboardState.loaded(data);
      }
      notifyListeners();
    } catch (e) {
      _state = RescueDashboardState.error(
        e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _state = _state.copyWith(isRefreshing: true);
    notifyListeners();

    try {
      final data = await _getDashboardUseCase(forceRefresh: true);
      if (data.incidents.isEmpty) {
        _state = RescueDashboardState.empty(data);
      } else {
        _state = RescueDashboardState.loaded(data);
      }
      notifyListeners();
    } catch (e) {
      _state = RescueDashboardState.error(
        e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
    }
  }

  void forceSetEmptyState() async {
    _state = RescueDashboardState.loading();
    notifyListeners();
    const emptyDataSource = RescueDashboardMockDataSource(
      simulatedDelay: Duration.zero,
      simulateEmpty: true,
    );
    final data = await emptyDataSource.fetchDashboardData();
    _state = RescueDashboardState.empty(data);
    notifyListeners();
  }

  void forceSetErrorState(String message) {
    _state = RescueDashboardState.error(message);
    notifyListeners();
  }
}

/// Global Dependency Container for Rescue Dashboard
class RescueDashboardDependencies {
  static RescueDashboardDataSource? _dataSource;
  static RescueDashboardRepository? _repository;
  static GetRescueDashboardDataUseCase? _useCase;
  static RescueDashboardNotifier? _notifier;

  static RescueDashboardDataSource get dataSource =>
      _dataSource ??= const RescueDashboardMockDataSource();

  static RescueDashboardRepository get repository =>
      _repository ??= RescueDashboardRepositoryImpl(dataSource: dataSource);

  static GetRescueDashboardDataUseCase get useCase =>
      _useCase ??= GetRescueDashboardDataUseCase(repository);

  static RescueDashboardNotifier get notifier =>
      _notifier ??= RescueDashboardNotifier(useCase);

  @visibleForTesting
  static void overrideWith({
    RescueDashboardDataSource? mockDataSource,
    RescueDashboardRepository? mockRepository,
    GetRescueDashboardDataUseCase? mockUseCase,
    RescueDashboardNotifier? mockNotifier,
  }) {
    _dataSource = mockDataSource;
    _repository = mockRepository;
    _useCase = mockUseCase;
    _notifier = mockNotifier;
  }

  @visibleForTesting
  static void reset() {
    _dataSource = null;
    _repository = null;
    _useCase = null;
    _notifier = null;
  }
}
