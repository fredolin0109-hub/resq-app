import '../models/rescue_user_model.dart';

/// Interface for Rescue Auth Data Sources.
abstract class RescueAuthDataSource {
  Future<RescueUserModel> login({
    required String rescueId,
    required String password,
  });

  Future<void> logout();

  Future<RescueUserModel?> getCachedUser();
}

/// Mock Implementation returning successful response after 2-second delay.
/// Does NOT connect to backend as per instructions.
class RescueAuthMockDataSource implements RescueAuthDataSource {
  RescueUserModel? _currentUser;

  @override
  Future<RescueUserModel> login({
    required String rescueId,
    required String password,
  }) async {
    // Simulate network authentication delay
    await Future.delayed(const Duration(seconds: 2));

    final mockUser = RescueUserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      rescueId: rescueId.toUpperCase(),
      name: 'Responder ${rescueId.toUpperCase()}',
      role: 'Tactical Lead',
      teamId: 'TEAM-BRAVO-7',
      token: 'mock_jwt_token_rescue_${DateTime.now().millisecondsSinceEpoch}',
    );

    _currentUser = mockUser;
    return mockUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  @override
  Future<RescueUserModel?> getCachedUser() async {
    return _currentUser;
  }
}
