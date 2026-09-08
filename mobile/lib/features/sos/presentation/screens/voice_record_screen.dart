import 'dart:async';
import 'package:flutter/material.dart';
import '../../application/voice_service.dart';
import '../../application/sos_orchestrator.dart';
import '../../application/sms_service.dart';
import '../../application/ble_service.dart';
import '../../data/local/sos_local_queue.dart';
import '../../data/local/contacts_repository.dart';
import 'emergency_status_screen.dart';

class VoiceRecordScreen extends StatefulWidget {
  const VoiceRecordScreen({super.key});

  @override
  State<VoiceRecordScreen> createState() => _VoiceRecordScreenState();
}

class _VoiceRecordScreenState extends State<VoiceRecordScreen> {
  final VoiceService _voiceService = VoiceService();
  bool _isRecording = false;
  bool _hasRecorded = false;
  String? _recordedFilePath;
  int _recordDuration = 0;
  Timer? _timer;
  final int _maxDuration = 30;

  @override
  void dispose() {
    _timer?.cancel();
    _voiceService.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });
      if (_recordDuration >= _maxDuration) {
        _stopRecording();
      }
    });
  }

  Future<void> _startRecording() async {
    await _voiceService.startRecording();
    setState(() {
      _isRecording = true;
      _hasRecorded = false;
      _recordDuration = 0;
    });
    _startTimer();
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _voiceService.stopRecording();
    setState(() {
      _isRecording = false;
      _hasRecorded = true;
      _recordedFilePath = path;
    });
  }
  
  Future<void> _playRecording() async {
    if (_recordedFilePath != null) {
      await _voiceService.playRecording(_recordedFilePath!);
    }
  }

  Future<void> _sendVoiceSos() async {
    // Optionally transcribe if speech-to-text was implemented.
    final orchestrator = SosOrchestrator(SmsService(), SosLocalQueue(), ContactsRepository(), BleService());
    final payload = await orchestrator.sendCompleteSos(voiceMessagePath: _recordedFilePath);
    
    if (mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => EmergencyStatusScreen(payload: payload))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎙️ Emergency Voice Message')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tell responders what happened and where you need help.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            Text(
              '00:${_recordDuration.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 40),
            if (!_hasRecorded)
              ElevatedButton.icon(
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                label: Text(_isRecording ? 'STOP' : 'START RECORDING'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording ? Colors.black : Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: _isRecording ? _stopRecording : _startRecording,
              )
            else
              Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('▶ PLAY'),
                    onPressed: _playRecording,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('🔄 RECORD AGAIN'),
                    onPressed: () {
                      if (_recordedFilePath != null) {
                        _voiceService.deleteRecording(_recordedFilePath!);
                      }
                      _startRecording();
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('📤 SEND'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _sendVoiceSos,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
