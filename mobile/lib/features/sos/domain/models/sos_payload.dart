class SosPayload {
  final String sosId;
  final double latitude;
  final double longitude;
  final int batteryLevel;
  final String? voiceMessagePath;
  final String? voiceToTextTranscription;
  final String status;
  final DateTime timestamp;

  SosPayload({
    required this.sosId,
    required this.latitude,
    required this.longitude,
    required this.batteryLevel,
    this.voiceMessagePath,
    this.voiceToTextTranscription,
    this.status = 'PENDING',
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sosId': sosId,
      'latitude': latitude,
      'longitude': longitude,
      'batteryLevel': batteryLevel,
      'voiceMessagePath': voiceMessagePath,
      'voiceToTextTranscription': voiceToTextTranscription,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SosPayload.fromMap(Map<String, dynamic> map) {
    return SosPayload(
      sosId: map['sosId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      batteryLevel: map['batteryLevel'],
      voiceMessagePath: map['voiceMessagePath'],
      voiceToTextTranscription: map['voiceToTextTranscription'],
      status: map['status'] ?? 'PENDING',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
