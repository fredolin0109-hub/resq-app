import 'package:flutter/material.dart';
import '../features/rescue/presentation/screens/rescue_dashboard_screen.dart';
import 'theme/theme.dart';

/// Main Application Widget for ResQLink AI.
class ResQApp extends StatelessWidget {
  const ResQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQLink AI - Rescue Command',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const RescueDashboardScreen(),
    );
  }
}
