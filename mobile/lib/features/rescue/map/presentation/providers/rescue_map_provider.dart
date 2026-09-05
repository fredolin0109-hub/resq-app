import 'package:flutter/foundation.dart';
import '../../data/datasources/rescue_map_mock_datasource.dart';
import '../../data/repositories/rescue_map_repository_impl.dart';
import '../../domain/entities/city_risk_entity.dart';
import '../../domain/repositories/rescue_map_repository.dart';
import '../../domain/usecases/get_tamil_nadu_cities_usecase.dart';
import 'rescue_map_state.dart';

/// Riverpod / Notifier provider managing Tamil Nadu Map state and filters.
class RescueMapNotifier extends ChangeNotifier {
  final GetTamilNaduCitiesUseCase _getCitiesUseCase;
  RescueMapState _state = RescueMapState.initial();

  RescueMapNotifier(this._getCitiesUseCase);

  RescueMapState get state => _state;

  static const MapCoordinate defaultTamilNaduCenter =
      MapCoordinate(latitude: 11.1271, longitude: 78.6569);
  static const double defaultTamilNaduZoom = 7.2;

  Future<void> loadMapData() async {
    _state = RescueMapState.loading();
    notifyListeners();

    try {
      final cities = await _getCitiesUseCase();
      if (cities.isEmpty) {
        _state = _state.copyWith(
          status: RescueMapStatus.empty,
          allCities: [],
          filteredCities: [],
        );
      } else {
        _state = _state.copyWith(
          status: RescueMapStatus.loaded,
          allCities: cities,
          filteredCities: cities,
          centerCoordinate: defaultTamilNaduCenter,
          zoomLevel: defaultTamilNaduZoom,
        );
      }
      notifyListeners();
    } catch (e) {
      _state = RescueMapState.error(
        e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
    }
  }

  void searchCities(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) {
      _state = _state.copyWith(
        searchQuery: '',
        filteredCities: _state.allCities,
      );
    } else {
      final matches = _state.allCities.where((city) {
        return city.name.toLowerCase().contains(q) ||
            city.district.toLowerCase().contains(q) ||
            city.area.toLowerCase().contains(q);
      }).toList();

      _state = _state.copyWith(
        searchQuery: query,
        filteredCities: matches,
      );
    }
    notifyListeners();
  }

  void selectCity(CityRiskEntity city) {
    _state = _state.copyWith(
      selectedCity: city,
      centerCoordinate: city.coordinate,
      zoomLevel: 11.5,
      isInfoPanelOpen: true,
      isFilterPanelOpen: false,
    );
    notifyListeners();
  }

  void deselectCity() {
    _state = _state.copyWith(
      clearSelectedCity: true,
      isInfoPanelOpen: false,
      isRouteSheetOpen: false,
    );
    notifyListeners();
  }

  void resetToTamilNadu() {
    _state = _state.copyWith(
      clearSelectedCity: true,
      centerCoordinate: defaultTamilNaduCenter,
      zoomLevel: defaultTamilNaduZoom,
      searchQuery: '',
      filteredCities: _state.allCities,
      isInfoPanelOpen: false,
      isFilterPanelOpen: false,
      isRouteSheetOpen: false,
    );
    notifyListeners();
  }

  void toggleFilterPanel() {
    _state = _state.copyWith(
      isFilterPanelOpen: !_state.isFilterPanelOpen,
      isInfoPanelOpen: false,
    );
    notifyListeners();
  }

  void updateFilters(MapFilterOptions newFilters) {
    _state = _state.copyWith(filterOptions: newFilters);
    notifyListeners();
  }

  void toggleRouteSheet(bool isOpen) {
    _state = _state.copyWith(isRouteSheetOpen: isOpen);
    notifyListeners();
  }

  void zoomIn() {
    _state = _state.copyWith(zoomLevel: (_state.zoomLevel + 0.8).clamp(5.0, 18.0));
    notifyListeners();
  }

  void zoomOut() {
    _state = _state.copyWith(zoomLevel: (_state.zoomLevel - 0.8).clamp(5.0, 18.0));
    notifyListeners();
  }
}

/// Global Dependency Container for Rescue Map
class RescueMapDependencies {
  static RescueMapDataSource? _dataSource;
  static RescueMapRepository? _repository;
  static GetTamilNaduCitiesUseCase? _useCase;
  static RescueMapNotifier? _notifier;

  static RescueMapDataSource get dataSource =>
      _dataSource ??= const RescueMapMockDataSource();

  static RescueMapRepository get repository =>
      _repository ??= RescueMapRepositoryImpl(dataSource: dataSource);

  static GetTamilNaduCitiesUseCase get useCase =>
      _useCase ??= GetTamilNaduCitiesUseCase(repository);

  static RescueMapNotifier get notifier =>
      _notifier ??= RescueMapNotifier(useCase);

  @visibleForTesting
  static void overrideWith({
    RescueMapDataSource? mockDataSource,
    RescueMapRepository? mockRepository,
    GetTamilNaduCitiesUseCase? mockUseCase,
    RescueMapNotifier? mockNotifier,
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
