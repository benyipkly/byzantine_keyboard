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
      body: PianoKeyboard(
        instrumentType: _currentInstrument,
        onInstrumentChanged: (InstrumentType type) {
          setState(() {
            _currentInstrument = type;
          });
        },
      ),
    );
  }
}
