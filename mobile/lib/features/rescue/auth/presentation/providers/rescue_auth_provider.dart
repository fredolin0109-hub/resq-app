import 'package:flutter/foundation.dart';
import '../../data/datasources/rescue_auth_datasource.dart';
import '../../data/repositories/rescue_auth_repository_impl.dart';
import '../../domain/repositories/rescue_auth_repository.dart';
import '../../domain/usecases/rescue_login_usecase.dart';
import 'rescue_auth_state.dart';

/// State Controller / Notifier for Rescue Authentication.
class RescueAuthNotifier extends ChangeNotifier {
  final RescueLoginUseCase _loginUseCase;
  RescueAuthState _state = RescueAuthState.idle();

  RescueAuthNotifier(this._loginUseCase);

  RescueAuthState get state => _state;

  Future<bool> login({
    required String rescueId,
    required String password,
  }) async {
    _state = RescueAuthState.loading();
    notifyListeners();

    try {
      final user = await _loginUseCase(
        rescueId: rescueId,
        password: password,
      );
      _state = RescueAuthState.success(user);
      notifyListeners();
      return true;
    } catch (e) {
      final message = e is ArgumentError ? e.message.toString() : e.toString().replaceFirst('Exception: ', '');
      _state = RescueAuthState.error(message);
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _state = RescueAuthState.idle();
    notifyListeners();
  }
}

/// Global Dependency Factory & Provider Container for Rescue Auth
class RescueAuthDependencies {
  static RescueAuthDataSource? _mockDataSource;
  static RescueAuthRepository? _repository;
  static RescueLoginUseCase? _loginUseCase;
  static RescueAuthNotifier? _authNotifier;

  static RescueAuthDataSource get dataSource =>
      _mockDataSource ??= RescueAuthMockDataSource();

  static RescueAuthRepository get repository =>
      _repository ??= RescueAuthRepositoryImpl(dataSource: dataSource);

  static RescueLoginUseCase get loginUseCase =>
      _loginUseCase ??= RescueLoginUseCase(repository);

  static RescueAuthNotifier get authNotifier =>
      _authNotifier ??= RescueAuthNotifier(loginUseCase);

  @visibleForTesting
  static void overrideWith({
    RescueAuthDataSource? mockDataSource,
    RescueAuthRepository? mockRepository,
    RescueLoginUseCase? mockUseCase,
    RescueAuthNotifier? mockNotifier,
  }) {
    _mockDataSource = mockDataSource;
    _repository = mockRepository;
    _loginUseCase = mockUseCase;
    _authNotifier = mockNotifier;
  }

  @visibleForTesting
  static void reset() {
    _mockDataSource = null;
    _repository = null;
    _loginUseCase = null;
    _authNotifier = null;
  }
}
