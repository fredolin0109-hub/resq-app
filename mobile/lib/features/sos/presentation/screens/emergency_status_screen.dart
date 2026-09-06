import 'package:flutter/material.dart';
import '../../domain/models/sos_payload.dart';
import '../../application/call_service.dart';

class EmergencyStatusScreen extends StatelessWidget {
  final SosPayload payload;
  final CallService _callService = CallService();

  EmergencyStatusScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚨 SOS ACTIVE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusRow('SMS', payload.status == 'SMS_SENT' ? '✓ Sent to emergency contacts' : 'Pending'),
          _buildStatusRow('BLE', '✓ Broadcasting'), // Mocked
          _buildStatusRow('Internet', '⚠ Offline'), // Mocked
          _buildStatusRow('Location', '✓ Last location captured\n${payload.latitude}, ${payload.longitude}'),
          _buildStatusRow('Live Location', '✓ Active'), // Mocked
          _buildStatusRow('Voice', payload.voiceMessagePath != null ? '✓ Recorded' : '○ Not recorded'),
          _buildStatusRow('Battery', '${payload.batteryLevel}%'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _callService.callEmergencyServices(),
            child: const Text('📞 CALL 112'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Go back to main SOS screen to record/re-trigger
            },
            child: const Text('🛑 END SOS'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
