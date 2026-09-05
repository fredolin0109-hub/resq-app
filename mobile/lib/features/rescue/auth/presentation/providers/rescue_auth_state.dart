import 'package:flutter/foundation.dart';
import '../../domain/entities/rescue_user.dart';

enum RescueAuthStatus {
  idle,
  loading,
  success,
  error,
}

/// Immutable state for Rescue Authentication.
@immutable
class RescueAuthState {
  final RescueAuthStatus status;
  final RescueUser? user;
  final String? errorMessage;

  const RescueAuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  factory RescueAuthState.idle() => const RescueAuthState(
        status: RescueAuthStatus.idle,
      );

  factory RescueAuthState.loading() => const RescueAuthState(
        status: RescueAuthStatus.loading,
      );

  factory RescueAuthState.success(RescueUser user) => RescueAuthState(
        status: RescueAuthStatus.success,
        user: user,
      );

  factory RescueAuthState.error(String message) => RescueAuthState(
        status: RescueAuthStatus.error,
        errorMessage: message,
      );

  bool get isIdle => status == RescueAuthStatus.idle;
  bool get isLoading => status == RescueAuthStatus.loading;
  bool get isSuccess => status == RescueAuthStatus.success;
  bool get isError => status == RescueAuthStatus.error;

  RescueAuthState copyWith({
    RescueAuthStatus? status,
    RescueUser? user,
    String? errorMessage,
  }) {
    return RescueAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RescueAuthState &&
        other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, user, errorMessage);
}
