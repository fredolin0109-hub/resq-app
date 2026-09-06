import 'package:url_launcher/url_launcher.dart';

class CallService {
  Future<void> callNumber(String phoneNumber) async {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw Exception('Could not launch dialer');
    }
  }

  Future<void> callEmergencyServices() async {
    await callNumber('112');
  }
}
