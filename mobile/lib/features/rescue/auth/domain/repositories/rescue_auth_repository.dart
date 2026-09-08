import '../entities/rescue_user.dart';

/// Contract for Rescue Authentication Repository.
abstract class RescueAuthRepository {
  /// Authenticates rescue personnel with rescue ID and password.
  Future<RescueUser> login({
    required String rescueId,
    required String password,
  });

  /// Logs out the currently authenticated user.
  Future<void> logout();

  /// Retrieves the currently cached/authenticated rescue user, if any.
  Future<RescueUser?> getCurrentUser();
}
