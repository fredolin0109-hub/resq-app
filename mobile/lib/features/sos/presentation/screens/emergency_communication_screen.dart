import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'emergency_contacts_screen.dart';
import 'voice_record_screen.dart';
import 'emergency_status_screen.dart';
import '../../application/call_service.dart';
import '../../application/sos_orchestrator.dart';
import '../../application/sms_service.dart';
import '../../application/ble_service.dart';
import '../../data/local/sos_local_queue.dart';
import '../../data/local/contacts_repository.dart';

class EmergencyCommunicationScreen extends StatelessWidget {
  final CallService _callService = CallService();
  
  EmergencyCommunicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('🚨 EMERGENCY COMMUNICATION', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()));
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBigButton(
                title: '🔴 FAST SOS SMS',
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () => _triggerCompleteSos(context),
              ),
              const SizedBox(height: 16),
              _buildBigButton(
                title: '📞 EMERGENCY CALL',
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () => _callService.callEmergencyServices(),
              ),
              const SizedBox(height: 16),
              _buildBigButton(
                title: '🎙️ RECORD VOICE MESSAGE',
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceRecordScreen()));
                },
              ),
              const SizedBox(height: 16),
              _buildBigButton(
                title: '📡 BLE SOS',
                color: Colors.purple,
                textColor: Colors.white,
                onPressed: () {
                  // Trigger BLE SOS logic
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('BLE Broadcasting Activated')));
                },
              ),
              const SizedBox(height: 16),
              _buildBigButton(
                title: '📍 SHARE LIVE LOCATION',
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  // Trigger live location logic
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Live Location Started')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigButton({required String title, required Color color, required Color textColor, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  void _triggerCompleteSos(BuildContext context) async {
    final orchestrator = SosOrchestrator(SmsService(), SosLocalQueue(), ContactsRepository(), BleService());
    final payload = await orchestrator.sendCompleteSos();
    
    if (context.mounted) {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => EmergencyStatusScreen(payload: payload))
      );
    }
  }
}
