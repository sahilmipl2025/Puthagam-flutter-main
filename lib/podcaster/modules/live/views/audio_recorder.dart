import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import '../controllers/live_controller.dart';

class AudioRecorderWidget extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorderWidget({Key? key, required this.onStop}) : super(key: key);

  @override
  _AudioRecorderWidgetState createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  int _recordDuration = 0;
  Timer? _timer;
  final AudioRecorder _audioRecorder = AudioRecorder();
  RecordState _recordState = RecordState.stop;
  Amplitude? _amplitude;
  final LiveController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (Timer t) async {
      bool isRecording = await _audioRecorder.isRecording();
      setState(() {
        _recordState = isRecording ? RecordState.record : RecordState.stop;
      });

      _amplitude = await _audioRecorder.getAmplitude();
    });
  }
Future<void> _start() async {
  try {
    if (await _audioRecorder.hasPermission()) {
      homeController.startStreaming();

      // Define a valid file path
      final String path = '/storage/emulated/0/Download/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc), // ✅ First argument
        path: path, // ✅ Second argument
      );

      _recordDuration = 0;
      _startTimer();
    }
  } catch (e) {
    log("Error starting recording: $e");
  }
} 



  Future<void> _stop() async {
    homeController.stopStreaming();
    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);
    }
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRecordStopControl(),
            const SizedBox(height: 20),
            _buildPauseResumeControl(),
            const SizedBox(height: 20),
            _buildText(),
            if (_amplitude != null) ...[
              const SizedBox(height: 40),
              Text('Current: ${_amplitude?.current ?? 0.0}'),
              Text('Max: ${_amplitude?.max ?? 0.0}'),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState != RecordState.stop) ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (_recordState == RecordState.record) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    return number < 10 ? '0$number' : number.toString();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}
