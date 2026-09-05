import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../mobile/lib/features/rescue/auth/data/datasources/rescue_auth_datasource.dart';
import '../../../../mobile/lib/features/rescue/auth/data/models/rescue_user_model.dart';
import '../../../../mobile/lib/features/rescue/auth/domain/entities/rescue_user.dart';
import '../../../../mobile/lib/features/rescue/auth/domain/repositories/rescue_auth_repository.dart';
import '../../../../mobile/lib/features/rescue/auth/domain/usecases/rescue_login_usecase.dart';
import '../../../../mobile/lib/features/rescue/auth/presentation/providers/rescue_auth_provider.dart';
import '../../../../mobile/lib/features/rescue/auth/presentation/providers/rescue_auth_state.dart';
import '../../../../mobile/lib/features/rescue/auth/presentation/screens/rescue_dashboard_placeholder_screen.dart';
import '../../../../mobile/lib/features/rescue/auth/presentation/screens/rescue_forgot_password_screen.dart';
import '../../../../mobile/lib/features/rescue/auth/presentation/screens/rescue_login_screen.dart';

/// Test Mock DataSource for fast test execution
class TestRescueAuthDataSource implements RescueAuthDataSource {
  final Duration delay;
  final bool shouldFail;

  TestRescueAuthDataSource({
    this.delay = Duration.zero,
    this.shouldFail = false,
  });

  @override
  Future<RescueUserModel> login({
    required String rescueId,
    required String password,
  }) async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    if (shouldFail) {
      throw Exception('Invalid rescue credentials');
    }
    return RescueUserModel(
      id: 'test_usr_123',
      rescueId: rescueId.toUpperCase(),
      name: 'Test Officer',
      role: 'Squad Commander',
      teamId: 'TEAM-TEST-9',
      token: 'test_token',
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<RescueUserModel?> getCachedUser() async => null;
}

/// Helper to pump the RescueLoginScreen within a MaterialApp test harness
Widget createTestWidget({
  RescueAuthNotifier? notifier,
  VoidCallback? onLoginSuccess,
}) {
  return MaterialApp(
    routes: {
      RescueDashboardPlaceholderScreen.routeName: (ctx) =>
          const RescueDashboardPlaceholderScreen(),
      RescueForgotPasswordScreen.routeName: (ctx) =>
          const RescueForgotPasswordScreen(),
    },
    home: RescueLoginScreen(
      authNotifier: notifier,
      onLoginSuccess: onLoginSuccess,
    ),
  );
}

void main() {
  group('Rescue Auth - Unit & Domain Tests', () {
    test('RescueLoginUseCase throws ArgumentError for empty rescue ID', () async {
      final mockDataSource = TestRescueAuthDataSource();
      final repository = RescueAuthRepositoryMockDirect(mockDataSource);
      final useCase = RescueLoginUseCase(repository);

      expect(
        () => useCase(rescueId: '', password: 'validPassword123'),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Rescue ID cannot be empty'),
        )),
      );
    });

    test('RescueLoginUseCase throws ArgumentError for short password (<8 chars)', () async {
      final mockDataSource = TestRescueAuthDataSource();
      final repository = RescueAuthRepositoryMockDirect(mockDataSource);
      final useCase = RescueLoginUseCase(repository);

      expect(
        () => useCase(rescueId: 'RESQ-001', password: '123'),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('at least 8 characters'),
        )),
      );
    });

    test('RescueAuthNotifier updates state to success on valid login', () async {
      final mockDataSource = TestRescueAuthDataSource();
      final repository = RescueAuthRepositoryMockDirect(mockDataSource);
      final useCase = RescueLoginUseCase(repository);
      final notifier = RescueAuthNotifier(useCase);

      expect(notifier.state.isIdle, isTrue);

      final success = await notifier.login(
        rescueId: 'RESQ-100',
        password: 'securePassword123',
      );

      expect(success, isTrue);
      expect(notifier.state.isSuccess, isTrue);
      expect(notifier.state.user?.rescueId, equals('RESQ-100'));
    });
  });

  group('Rescue Login Screen - Widget Tests', () {
    testWidgets('Renders all initial UI components correctly', (tester) async {
      final notifier = RescueAuthNotifier(
        RescueLoginUseCase(RescueAuthRepositoryMockDirect(TestRescueAuthDataSource())),
      );

      await tester.pumpWidget(createTestWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Check header, fields, buttons
      expect(find.text('ResQLink AI'), findsOneWidget);
      expect(find.text('Rescue Team Login'), findsOneWidget);
      expect(find.text('Rescue ID'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('1. Empty fields validation displays error messages', (tester) async {
      final notifier = RescueAuthNotifier(
        RescueLoginUseCase(RescueAuthRepositoryMockDirect(TestRescueAuthDataSource())),
      );

      await tester.pumpWidget(createTestWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Tap Sign In button without entering data
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Errors must appear
      expect(find.text('Rescue ID cannot be empty'), findsOneWidget);
      expect(find.text('Password cannot be empty'), findsOneWidget);
    });

    testWidgets('2. Invalid password length displays error message', (tester) async {
      final notifier = RescueAuthNotifier(
        RescueLoginUseCase(RescueAuthRepositoryMockDirect(TestRescueAuthDataSource())),
      );

      await tester.pumpWidget(createTestWidget(notifier: notifier));
      await tester.pumpAndSettle();

      // Enter valid Rescue ID, but short password (<8 chars)
      await tester.enterText(find.byType(TextFormField).first, 'RESQ-9901');
      await tester.enterText(find.byType(TextFormField).last, 'pass12');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Rescue ID cannot be empty'), findsNothing);
      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('3. Displays Loading state and progress indicator during authentication', (tester) async {
      final mockDataSource = TestRescueAuthDataSource(
        delay: const Duration(milliseconds: 500),
      );
      final notifier = RescueAuthNotifier(
        RescueLoginUseCase(RescueAuthRepositoryMockDirect(mockDataSource)),
      );

      await tester.pumpWidget(createTestWidget(notifier: notifier));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'RESQ-8822');
      await tester.enterText(find.byType(TextFormField).last, 'ValidPassword99#');
      await tester.tap(find.text('Sign In'));
      await tester.pump(); // Start async operation

      // Verify loading spinner is present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(); // Settle async timer
    });

    testWidgets('4. Successful login invokes success callback / navigates to dashboard', (tester) async {
      bool loginSucceeded = false;
      final mockDataSource = TestRescueAuthDataSource(
        delay: const Duration(milliseconds: 100),
      );
      final notifier = RescueAuthNotifier(
        RescueLoginUseCase(RescueAuthRepositoryMockDirect(mockDataSource)),
      );

      await tester.pumpWidget(
        createTestWidget(
          notifier: notifier,
          onLoginSuccess: () {
            loginSucceeded = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'RESQ-3344');
      await tester.enterText(find.byType(TextFormField).last, 'AlphaPassword123');
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(loginSucceeded, isTrue);
    });

    testWidgets('Navigates to Forgot Password screen when link tapped', (tester) async {
      final notifier = RescueAuthNotifier(
        RescueLoginUseCase(RescueAuthRepositoryMockDirect(TestRescueAuthDataSource())),
      );

      await tester.pumpWidget(createTestWidget(notifier: notifier));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      expect(find.text('Credential Recovery'), findsOneWidget);
      expect(
        find.text('Contact your administrator to reset your Rescue credentials.'),
        findsOneWidget,
      );
    });
  });
}

/// Helper Mock Repository for Direct In-Memory testing
class RescueAuthRepositoryMockDirect implements RescueAuthRepository {
  final RescueAuthDataSource dataSource;

  RescueAuthRepositoryMockDirect(this.dataSource);

  @override
  Future<RescueUser> login({
    required String rescueId,
    required String password,
  }) async {
    final model = await dataSource.login(rescueId: rescueId, password: password);
    return model.toDomain();
  }

  @override
  Future<void> logout() => dataSource.logout();

  @override
  Future<RescueUser?> getCurrentUser() async {
    final cached = await dataSource.getCachedUser();
    return cached?.toDomain();
  }
}
