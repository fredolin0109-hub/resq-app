import '../../domain/entities/rescue_user.dart';
import '../../domain/repositories/rescue_auth_repository.dart';
import '../datasources/rescue_auth_datasource.dart';

/// Concrete implementation of [RescueAuthRepository].
class RescueAuthRepositoryImpl implements RescueAuthRepository {
  final RescueAuthDataSource dataSource;

  RescueAuthRepositoryImpl({RescueAuthDataSource? dataSource})
      : dataSource = dataSource ?? RescueAuthMockDataSource();

  @override
  Future<RescueUser> login({
    required String rescueId,
    required String password,
  }) async {
    try {
      final model = await dataSource.login(
        rescueId: rescueId,
        password: password,
      );
      return model.toDomain();
    } catch (e) {
      throw Exception('Authentication failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }

  @override
  Future<RescueUser?> getCurrentUser() async {
    final cached = await dataSource.getCachedUser();
    return cached?.toDomain();
  }
}
