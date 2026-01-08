import 'dart:async';
import 'dart:math';

import '../../../../core/audio/synth.dart';
import 'soloud_controller.dart';

class PianoAudioController {
  final int polyphonyCount;
  final bool isWeb;

  final SoloudController _soloudController = SoloudController();

  // Microtonal State (Byzantine ET72)
  // Maps noteIndex -> moria offset (integer)
  final Map<int, int> _moriaOffsets = {};

  // Frequencies for notes (C3 start - 3 octaves: C3 to C6)
  static final List<double> _frequencies = [
    // Octave 3 (C3 - B3)
    130.81,
    138.59,
    146.83,
    155.56,
    164.81,
    174.61,
    185.00,
    196.00,
    207.65,
    220.00,
    233.08,
    246.94,
    // Octave 4 (C4 - B4)
    261.63,
    277.18,
    293.66,
    311.13,
    329.63,
    349.23,
    369.99,
    392.00,
    415.30,
    440.00,
    466.16,
    493.88,
    // Octave 5 (C5 - B5)
    523.25,
    554.37,
    587.33,
    622.25,
    659.25,
    698.46,
    739.99,
    783.99,
    830.61,
    880.00,
    932.33,
    987.77,
    // C6
    1046.50,
  ];

  PianoAudioController({required this.polyphonyCount, required this.isWeb}) {
    _soloudController.initialize();
  }

  void dispose() {
    _soloudController.dispose();
  }

  Future<void> stopAll() async {
    _soloudController.stopAll();
  }

  void setMoriaOffset(int index, int moria) {
    _moriaOffsets[index] = moria;
    // Real-time pitch update not yet implemented in SoloudController for sustained notes,
    // but could be added if needed. For now, it will apply on next startNote.
  }

  int getMoriaOffset(int index) => _moriaOffsets[index] ?? 0;

  Future<void> startNote(int index, InstrumentType instrumentType) async {
    if (index < 0 || index >= _frequencies.length) return;

    final int moria = _moriaOffsets[index] ?? 0;

    final double baseFreq = _frequencies[index];
    final double effectiveFreq = baseFreq * pow(2.0, moria / 72.0);

    await _soloudController.startNote(index, effectiveFreq, instrumentType);
  }

  Future<void> stopNote(int index, InstrumentType instrumentType) async {
    await _soloudController.stopNote(index);
  }
}
