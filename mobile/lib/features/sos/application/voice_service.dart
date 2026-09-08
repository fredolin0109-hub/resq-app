import 'dart:io';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class VoiceService {
  final AudioRecorder _record = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentRecordingPath;

  Future<void> startRecording() async {
    if (await _record.hasPermission()) {
      final Directory docDir = await getApplicationDocumentsDirectory();
      final String path = '${docDir.path}/emergency_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _currentRecordingPath = path;

      await _record.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 16000,
          numChannels: 1, // Mono audio for smaller size
        ),
        path: path,
      );
    }
  }

  Future<String?> stopRecording() async {
    await _record.stop();
    return _currentRecordingPath;
  }

  Future<void> pauseRecording() async {
    await _record.pause();
  }

  Future<void> resumeRecording() async {
    await _record.resume();
  }

  Future<void> playRecording(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
  }

  Future<void> stopPlayback() async {
    await _audioPlayer.stop();
  }

  Future<void> deleteRecording(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  void dispose() {
    _record.dispose();
    _audioPlayer.dispose();
  }
}
