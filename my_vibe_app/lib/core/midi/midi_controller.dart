/// MIDI Controller with conditional imports for web/native platforms
library;

import 'midi_controller_interface.dart';
export 'midi_controller_interface.dart';

// Conditional import: use web implementation on web, native otherwise
import 'midi_controller_stub.dart'
    if (dart.library.html) 'midi_controller_web.dart'
    if (dart.library.io) 'midi_controller_native.dart'
    as impl;

/// Cross-platform MIDI controller facade
class MidiController implements MidiControllerInterface {
  static final MidiController _instance = MidiController._internal();
  factory MidiController() => _instance;
  MidiController._internal();

  late final MidiControllerInterface _impl = impl.createMidiController();

  @override
  Stream<bool> get connectionStream => _impl.connectionStream;

  @override
  Stream<MidiEvent> get midiEventStream => _impl.midiEventStream;

  @override
  bool get isConnected => _impl.isConnected;

  @override
  Future<void> initialize() => _impl.initialize();

  @override
  void dispose() => _impl.dispose();
}
