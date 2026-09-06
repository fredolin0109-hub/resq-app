import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import '../domain/models/sos_payload.dart';
import '../data/local/sos_local_queue.dart';
import '../data/local/contacts_repository.dart';
import 'sms_service.dart';
import 'ble_service.dart';

class SosOrchestrator {
  final SmsService _smsService;
  final SosLocalQueue _localQueue;
  final ContactsRepository _contactsRepository;
  final BleService _bleService;
  final Uuid _uuid = const Uuid();
  final Battery _battery = Battery();

  SosOrchestrator(this._smsService, this._localQueue, this._contactsRepository, this._bleService);

  Future<SosPayload> sendCompleteSos({
    String? voiceMessagePath,
    String? voiceTranscription,
  }) async {
    // 1. Get Battery Level
    int batteryLevel = await _battery.batteryLevel;

    // 2. Get Location
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: batteryLevel < 15 ? LocationAccuracy.low : LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      position = await Geolocator.getLastKnownPosition();
    }

    // 3. Create Payload
    final payload = SosPayload(
      sosId: 'RESQ-SOS-${_uuid.v4().substring(0, 6).toUpperCase()}',
      latitude: position?.latitude ?? 0.0,
      longitude: position?.longitude ?? 0.0,
      batteryLevel: batteryLevel,
      voiceMessagePath: voiceMessagePath,
      voiceToTextTranscription: voiceTranscription,
      timestamp: DateTime.now(),
    );

    // 4. Save to Local Queue (Offline First)
    await _localQueue.queueSos(payload);

    // 5. Trigger SMS
    final contacts = await _contactsRepository.getContacts();
    try {
      await _smsService.sendEmergencySms(contacts, payload);
      await _localQueue.updateSosStatus(payload.sosId, 'SMS_SENT');
    } catch (e) {
      // Failed to send SMS or open intent
    }

    // 6. BLE SOS
    try {
      await _bleService.broadcastSos(payload);
    } catch (e) {
      // Failed to broadcast BLE
    }
    
    // 7. Internet Delivery (Mocked logic)
    // if (await _networkInfo.isConnected) {
    //   await _backendService.sendSos(payload);
    //   await _localQueue.updateSosStatus(payload.sosId, 'DELIVERED');
    // }

    return payload;
  }
}
