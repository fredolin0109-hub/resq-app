import 'package:flutter/material.dart';
import 'features/sos/presentation/screens/emergency_communication_screen.dart';

void main() {
  runApp(const ResqCivilianApp());
}

class ResqCivilianApp extends StatelessWidget {
  const ResqCivilianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQ Civilian',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: EmergencyCommunicationScreen(),
    );
  }
}
