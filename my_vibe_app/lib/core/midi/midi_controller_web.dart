/// Web MIDI implementation using browser's Web MIDI API
/// This file is only imported on web platform via conditional imports
library;

import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

import 'midi_controller_interface.dart';

// JS interop extensions for MIDIInputMap iteration
extension MIDIInputMapExt on web.MIDIInputMap {
  @JS('values')
  external JSObject _values();

  List<web.MIDIInput> getInputs() {
    final result = <web.MIDIInput>[];
    final iterator = _values();
    while (true) {
      final next = (iterator as _JSIterator).next();
      if (next.done) break;
      final value = next.value;
      if (value != null) {
        result.add(value as web.MIDIInput);
      }
    }
    return result;
  }
}

@JS()
@staticInterop
class _JSIterator {}

extension _JSIteratorExt on _JSIterator {
  external _JSIteratorResult next();
}

@JS()
@staticInterop
class _JSIteratorResult {}

extension _JSIteratorResultExt on _JSIteratorResult {
  external bool get done;
  external JSAny? get value;
}

/// Web implementation of MidiController using browser's Web MIDI API
class MidiControllerImpl implements MidiControllerInterface {
  static final MidiControllerImpl _instance = MidiControllerImpl._internal();
  factory MidiControllerImpl() => _instance;
  MidiControllerImpl._internal();

  final _connectionController = StreamController<bool>.broadcast();
  final _midiEventController = StreamController<MidiEvent>.broadcast();

  web.MIDIAccess? _midiAccess;
  bool _isConnected = false;

  @override
  Stream<bool> get connectionStream => _connectionController.stream;

  @override
  Stream<MidiEvent> get midiEventStream => _midiEventController.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> initialize() async {
    try {
      // Request MIDI access from browser
      final navigator = web.window.navigator;
      final midiPromise = navigator.requestMIDIAccess();
      _midiAccess = await midiPromise.toDart;

      if (_midiAccess != null) {
        _setupInputListeners();
      }
    } catch (e) {
      print('Web MIDI init error: $e');
    }
  }

  void _setupInputListeners() {
    final inputs = _midiAccess?.inputs;
    if (inputs == null) return;

    final inputList = inputs.getInputs();
    for (final input in inputList) {
      _connectInput(input);
    }

    if (inputList.isNotEmpty) {
      _isConnected = true;
      _connectionController.add(true);
    }

    // Listen for state changes (device connect/disconnect)
    _midiAccess?.onstatechange = ((web.Event event) {
      _handleStateChange();
    }).toJS;
  }

  void _handleStateChange() {
    final inputs = _midiAccess?.inputs;
    if (inputs == null) return;

    final inputList = inputs.getInputs();
    for (final input in inputList) {
      _connectInput(input);
    }

    final hasInputs = inputList.isNotEmpty;
    if (hasInputs != _isConnected) {
      _isConnected = hasInputs;
      _connectionController.add(hasInputs);
    }
  }

  void _connectInput(web.MIDIInput input) {
    input.onmidimessage = ((web.MIDIMessageEvent event) {
      _handleMidiMessage(event);
    }).toJS;
  }

  void _handleMidiMessage(web.MIDIMessageEvent event) {
    final data = event.data;
    if (data == null) return;

    // Convert JSUint8Array to Dart List
    final dartData = data.toDart;
    if (dartData.length < 3) return;

    final status = dartData[0];
    final note = dartData[1];
    final velocity = dartData[2];

    final command = status & 0xF0;

    if (command == 0x90) {
      // Note On
      if (velocity > 0) {
        _midiEventController.add(
          MidiEvent(
            type: MidiEventType.noteOn,
            noteNumber: note,
            velocity: velocity,
          ),
        );
      } else {
        // Note On with velocity 0 = Note Off
        _midiEventController.add(
          MidiEvent(type: MidiEventType.noteOff, noteNumber: note, velocity: 0),
        );
      }
    } else if (command == 0x80) {
      // Note Off
      _midiEventController.add(
        MidiEvent(type: MidiEventType.noteOff, noteNumber: note, velocity: 0),
      );
    }
  }

  @override
  void dispose() {
    _connectionController.close();
    _midiEventController.close();
  }
}

/// Factory function for conditional imports
MidiControllerInterface createMidiController() => MidiControllerImpl();
