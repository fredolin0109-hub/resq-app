import 'package:flutter/foundation.dart';
import '../../domain/entities/rescue_dashboard_data.dart';

enum RescueDashboardStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// Immutable state container for Rescue Dashboard.
@immutable
class RescueDashboardState {
  final RescueDashboardStatus status;
  final RescueDashboardData? data;
  final String? errorMessage;
  final bool isRefreshing;

  const RescueDashboardState({
    required this.status,
    this.data,
    this.errorMessage,
    this.isRefreshing = false,
  });

  factory RescueDashboardState.initial() => const RescueDashboardState(
        status: RescueDashboardStatus.initial,
      );

  factory RescueDashboardState.loading() => const RescueDashboardState(
        status: RescueDashboardStatus.loading,
      );

  factory RescueDashboardState.loaded(RescueDashboardData data) =>
      RescueDashboardState(
        status: RescueDashboardStatus.loaded,
        data: data,
      );

  factory RescueDashboardState.empty(RescueDashboardData data) =>
      RescueDashboardState(
        status: RescueDashboardStatus.empty,
        data: data,
      );

  factory RescueDashboardState.error(String message) => RescueDashboardState(
        status: RescueDashboardStatus.error,
        errorMessage: message,
      );

  bool get isInitial => status == RescueDashboardStatus.initial;
  bool get isLoading => status == RescueDashboardStatus.loading;
  bool get isLoaded => status == RescueDashboardStatus.loaded;
  bool get isEmpty => status == RescueDashboardStatus.empty;
  bool get isError => status == RescueDashboardStatus.error;

  RescueDashboardState copyWith({
    RescueDashboardStatus? status,
    RescueDashboardData? data,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return RescueDashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RescueDashboardState &&
        other.status == status &&
        other.data == data &&
        other.errorMessage == errorMessage &&
        other.isRefreshing == isRefreshing;
  }

  @override
  int get hashCode => Object.hash(status, data, errorMessage, isRefreshing);
}
