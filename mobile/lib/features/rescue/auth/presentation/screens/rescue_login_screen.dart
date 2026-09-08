import 'package:flutter/material.dart';
import '../../../../civilian/presentation/screens/civilian_portal_screen.dart';
import '../../../presentation/screens/rescue_dashboard_screen.dart';
import '../controllers/rescue_login_controller.dart';
import '../providers/rescue_auth_provider.dart';
import '../providers/rescue_auth_state.dart';
import '../widgets/rescue_logo_header.dart';
import '../widgets/rescue_primary_button.dart';
import '../widgets/rescue_text_form_field.dart';
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
        settings: const RouteSettings(name: RescueDashboardScreen.routeName),
        page: const RescueDashboardScreen(),
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

  void _navigateToCivilian() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CivilianPortalScreen(),
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

  Future<void> _handleQuickDemoSignIn() async {
    _controller.rescueIdController.text = 'RESQ-9014';
    _controller.passwordController.text = 'Resq@2026';
    await _handleSignIn();
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 28.0,
                      ),
                      child: Form(
                        key: _controller.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. App Logo & Header
                            const RescueLogoHeader(),
                            const SizedBox(height: 24),

                            // 2. Rescue ID Input Field
                            RescueTextFormField(
                              controller: _controller.rescueIdController,
                              focusNode: _controller.rescueIdFocusNode,
                              label: 'Rescue Officer ID',
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
                            const SizedBox(height: 16),

                            // 3. Password Input Field
                            RescueTextFormField(
                              controller: _controller.passwordController,
                              focusNode: _controller.passwordFocusNode,
                              label: 'Access Password',
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
                            const SizedBox(height: 6),

                            // 4. Forgot Password Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: isLoading ? null : _navigateToForgotPassword,
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 5. Sign In Button
                            RescuePrimaryButton(
                              label: 'Sign In (Rescue Command)',
                              icon: Icons.shield_rounded,
                              isLoading: isLoading,
                              onPressed: _handleSignIn,
                            ),
                            const SizedBox(height: 12),

                            // 6. Quick Demo Login Button
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: isLoading ? null : _handleQuickDemoSignIn,
                              icon: const Icon(Icons.flash_on_rounded, color: Colors.amber),
                              label: const Text(
                                'Quick Demo Sign-In (Commander)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('OR', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // 7. Civilian Distress Portal Button
                            FilledButton.tonalIcon(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1E1B4B),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _navigateToCivilian,
                              icon: const Icon(Icons.emergency_rounded, color: Colors.redAccent),
                              label: const Text(
                                'Continue as Civilian (SOS & Shelters)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
