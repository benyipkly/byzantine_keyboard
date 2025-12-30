/// Interface for MIDI controller to enable platform-specific implementations
library;

/// MIDI event types
enum MidiEventType { noteOn, noteOff }

/// Parsed MIDI event
class MidiEvent {
  final MidiEventType type;
  final int noteNumber;
  final int velocity;

  MidiEvent({
    required this.type,
    required this.noteNumber,
    required this.velocity,
  });
}

/// Abstract interface for MIDI controller
abstract class MidiControllerInterface {
  Stream<bool> get connectionStream;
  Stream<MidiEvent> get midiEventStream;
  bool get isConnected;
  Future<void> initialize();
  void dispose();
}
