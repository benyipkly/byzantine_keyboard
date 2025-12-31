/// Stub MIDI implementation for unsupported platforms
library;

import 'dart:async';

import 'midi_controller_interface.dart';
export 'midi_controller_interface.dart';

/// Stub implementation that does nothing
class MidiControllerImpl implements MidiControllerInterface {
  static final MidiControllerImpl _instance = MidiControllerImpl._internal();
  factory MidiControllerImpl() => _instance;
  MidiControllerImpl._internal();

  final _connectionController = StreamController<bool>.broadcast();
  final _midiEventController = StreamController<MidiEvent>.broadcast();

  @override
  Stream<bool> get connectionStream => _connectionController.stream;

  @override
  Stream<MidiEvent> get midiEventStream => _midiEventController.stream;

  @override
  bool get isConnected => false;

  @override
  Future<void> initialize() async {
    // No-op on unsupported platforms
  }

  @override
  void dispose() {
    _connectionController.close();
    _midiEventController.close();
  }
}

/// Factory function for conditional imports
MidiControllerInterface createMidiController() => MidiControllerImpl();
