import 'package:flutter/material.dart';
import '../../../../core/audio/synth.dart';
import 'piano_keyboard.dart';

class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  InstrumentType _currentInstrument = InstrumentType.organ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Dark premium background
      body: Stack(
        children: [
          PianoKeyboard(
            instrumentType: _currentInstrument,
            onInstrumentChanged: (InstrumentType type) {
              setState(() {
                _currentInstrument = type;
              });
            },
          ),
          if (_isWeb && !_audioUnlocked)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _audioUnlocked = true;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tap to Start',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Click anywhere to enable audio',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get _isWeb => identical(0, 0.0);
  bool _audioUnlocked = false;
}
