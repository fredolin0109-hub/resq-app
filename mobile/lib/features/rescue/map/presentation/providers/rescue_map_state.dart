import 'package:flutter/foundation.dart';
import '../../domain/entities/city_risk_entity.dart';

enum RescueMapStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// State container for the Rescue Mission Command Map.
@immutable
class RescueMapState {
  final RescueMapStatus status;
  final List<CityRiskEntity> allCities;
  final List<CityRiskEntity> filteredCities;
  final CityRiskEntity? selectedCity;
  final MapFilterOptions filterOptions;
  final String searchQuery;
  final MapCoordinate centerCoordinate;
  final double zoomLevel;
  final bool isFilterPanelOpen;
  final bool isInfoPanelOpen;
  final bool isRouteSheetOpen;
  final String? errorMessage;

  const RescueMapState({
    required this.status,
    this.allCities = const [],
    this.filteredCities = const [],
    this.selectedCity,
    this.filterOptions = const MapFilterOptions(),
    this.searchQuery = '',
    this.centerCoordinate = const MapCoordinate(latitude: 11.1271, longitude: 78.6569),
    this.zoomLevel = 7.2,
    this.isFilterPanelOpen = false,
    this.isInfoPanelOpen = false,
    this.isRouteSheetOpen = false,
    this.errorMessage,
  });

  factory RescueMapState.initial() => const RescueMapState(
        status: RescueMapStatus.initial,
      );

  factory RescueMapState.loading() => const RescueMapState(
        status: RescueMapStatus.loading,
      );

  factory RescueMapState.error(String message) => RescueMapState(
        status: RescueMapStatus.error,
        errorMessage: message,
      );

  bool get isLoading => status == RescueMapStatus.loading;
  bool get isLoaded => status == RescueMapStatus.loaded;
  bool get isEmpty => status == RescueMapStatus.empty;
  bool get isError => status == RescueMapStatus.error;

  RescueMapState copyWith({
    RescueMapStatus? status,
    List<CityRiskEntity>? allCities,
    List<CityRiskEntity>? filteredCities,
    CityRiskEntity? selectedCity,
    bool clearSelectedCity = false,
    MapFilterOptions? filterOptions,
    String? searchQuery,
    MapCoordinate? centerCoordinate,
    double? zoomLevel,
    bool? isFilterPanelOpen,
    bool? isInfoPanelOpen,
    bool? isRouteSheetOpen,
    String? errorMessage,
  }) {
    return RescueMapState(
      status: status ?? this.status,
      allCities: allCities ?? this.allCities,
      filteredCities: filteredCities ?? this.filteredCities,
      selectedCity: clearSelectedCity ? null : (selectedCity ?? this.selectedCity),
      filterOptions: filterOptions ?? this.filterOptions,
      searchQuery: searchQuery ?? this.searchQuery,
      centerCoordinate: centerCoordinate ?? this.centerCoordinate,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      isFilterPanelOpen: isFilterPanelOpen ?? this.isFilterPanelOpen,
      isInfoPanelOpen: isInfoPanelOpen ?? this.isInfoPanelOpen,
      isRouteSheetOpen: isRouteSheetOpen ?? this.isRouteSheetOpen,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
