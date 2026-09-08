import 'package:flutter/material.dart';

/// Form Controller managing input validation, focus, and state for Rescue Login.
class RescueLoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController rescueIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode rescueIdFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  String? validateRescueId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Rescue ID cannot be empty';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  bool validateAndSave() {
    return formKey.currentState?.validate() ?? false;
  }

  void clear() {
    rescueIdController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    rescueIdController.dispose();
    passwordController.dispose();
    rescueIdFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
