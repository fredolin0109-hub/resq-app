import 'package:url_launcher/url_launcher.dart';
import '../domain/models/emergency_contact.dart';
import '../domain/models/sos_payload.dart';

class SmsService {
  Future<void> sendEmergencySms(List<EmergencyContact> contacts, SosPayload payload) async {
    if (contacts.isEmpty) return;

    final String phones = contacts.map((e) => e.phoneNumber).join(',');
    final String message = _buildEmergencyMessage(payload);

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phones,
      queryParameters: <String, String>{
        'body': message,
      },
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw Exception('Could not launch SMS app');
    }
  }

  String _buildEmergencyMessage(SosPayload payload) {
    StringBuffer sb = StringBuffer();
    sb.writeln('RESQ EMERGENCY 🚨');
    sb.writeln('I need emergency assistance.');
    
    if (payload.voiceToTextTranscription != null && payload.voiceToTextTranscription!.isNotEmpty) {
      sb.writeln('Voice emergency message:');
      sb.writeln('"${payload.voiceToTextTranscription}"');
    }
    
    sb.writeln('Location: ${payload.latitude.toStringAsFixed(4)}, ${payload.longitude.toStringAsFixed(4)}');
    sb.writeln('Map: https://maps.google.com/?q=${payload.latitude},${payload.longitude}');
    sb.writeln('Battery: ${payload.batteryLevel}%');
    sb.writeln('ID: ${payload.sosId}');
    sb.writeln('Please contact me immediately.');
    
    return sb.toString();
  }
}
