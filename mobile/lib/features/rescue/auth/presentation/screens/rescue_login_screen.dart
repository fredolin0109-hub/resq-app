import 'package:flutter/material.dart';
import '../controllers/rescue_login_controller.dart';
import '../providers/rescue_auth_provider.dart';
import '../providers/rescue_auth_state.dart';
import '../widgets/rescue_logo_header.dart';
import '../widgets/rescue_primary_button.dart';
import '../widgets/rescue_text_form_field.dart';
import 'rescue_dashboard_placeholder_screen.dart';
import 'rescue_fade_route.dart';
import 'rescue_forgot_password_screen.dart';

/// Production-ready Rescue Login Screen adhering to Clean Architecture
/// and ResQLink AI platform design guidelines.
class RescueLoginScreen extends StatefulWidget {
  final RescueAuthNotifier? authNotifier;
  final VoidCallback? onLoginSuccess;

  const RescueLoginScreen({
    super.key,
    this.authNotifier,
    this.onLoginSuccess,
  });

  static const String routeName = '/rescue/login';

  @override
  State<RescueLoginScreen> createState() => _RescueLoginScreenState();
}

class _RescueLoginScreenState extends State<RescueLoginScreen> {
  late final RescueLoginController _controller;
  late final RescueAuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _controller = RescueLoginController();
    _authNotifier = widget.authNotifier ?? RescueAuthDependencies.authNotifier;
    _authNotifier.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authNotifier.removeListener(_onAuthStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (!mounted) return;
    final state = _authNotifier.state;

    if (state.isSuccess) {
      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!();
      } else {
        _navigateToDashboard(state);
      }
    } else if (state.isError && state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _navigateToDashboard(RescueAuthState state) {
    Navigator.of(context).pushReplacement(
      RescueFadeRoute(
        settings: const RouteSettings(name: RescueDashboardPlaceholderScreen.routeName),
        page: RescueDashboardPlaceholderScreen(user: state.user),
      ),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.of(context).push(
      RescueFadeRoute(
        settings: const RouteSettings(name: RescueForgotPasswordScreen.routeName),
        page: const RescueForgotPasswordScreen(),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    // Dismiss soft keyboard
    FocusScope.of(context).unfocus();

    if (_controller.validateAndSave()) {
      await _authNotifier.login(
        rescueId: _controller.rescueIdController.text,
        password: _controller.passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _authNotifier]),
          builder: (context, _) {
            final authState = _authNotifier.state;
            final isLoading = authState.isLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Card(
                    elevation: 0,
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28.0,
                        vertical: 36.0,
                      ),
                      child: Form(
                        key: _controller.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. App Logo & Header
                            const RescueLogoHeader(),
                            const SizedBox(height: 32),

                            // 2. Rescue ID Input Field
                            RescueTextFormField(
                              controller: _controller.rescueIdController,
                              focusNode: _controller.rescueIdFocusNode,
                              label: 'Rescue ID',
                              hint: 'e.g. RESQ-9014',
                              prefixIcon: Icons.badge_rounded,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              enabled: !isLoading,
                              validator: _controller.validateRescueId,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_controller.passwordFocusNode);
                              },
                            ),
                            const SizedBox(height: 20),

                            // 3. Password Input Field
                            RescueTextFormField(
                              controller: _controller.passwordController,
                              focusNode: _controller.passwordFocusNode,
                              label: 'Password',
                              hint: 'Minimum 8 characters',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: !_controller.isPasswordVisible,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              enabled: !isLoading,
                              validator: _controller.validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _controller.isPasswordVisible
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                tooltip: _controller.isPasswordVisible
                                    ? 'Hide password'
                                    : 'Show password',
                                onPressed: _controller.togglePasswordVisibility,
                              ),
                              onFieldSubmitted: (_) => _handleSignIn(),
                            ),
                            const SizedBox(height: 8),

                            // 4. Forgot Password Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: isLoading ? null : _navigateToForgotPassword,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  minimumSize: const Size(48, 48),
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 5. Sign In Button
                            RescuePrimaryButton(
                              label: 'Sign In',
                              icon: Icons.login_rounded,
                              isLoading: isLoading,
                              onPressed: _handleSignIn,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
