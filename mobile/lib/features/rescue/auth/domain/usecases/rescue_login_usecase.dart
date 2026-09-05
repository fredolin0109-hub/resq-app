import '../entities/rescue_user.dart';
import '../repositories/rescue_auth_repository.dart';

/// UseCase responsible for authenticating Rescue personnel.
class RescueLoginUseCase {
  final RescueAuthRepository repository;

  const RescueLoginUseCase(this.repository);

  Future<RescueUser> call({
    required String rescueId,
    required String password,
  }) async {
    final cleanId = rescueId.trim();
    if (cleanId.isEmpty) {
      throw ArgumentError('Rescue ID cannot be empty');
    }
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    if (password.length < 8) {
      throw ArgumentError('Password must be at least 8 characters long');
    }

    return await repository.login(
      rescueId: cleanId,
      password: password,
    );
  }
}
