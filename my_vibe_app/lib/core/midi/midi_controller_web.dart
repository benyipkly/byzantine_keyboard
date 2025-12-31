/// Web MIDI implementation using browser's Web MIDI API
/// Uses dart:js_interop_unsafe for simpler, more reliable property access
library;

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'midi_controller_interface.dart';
export 'midi_controller_interface.dart';

/// Web implementation of MidiController using browser's Web MIDI API
class MidiControllerImpl implements MidiControllerInterface {
  static final MidiControllerImpl _instance = MidiControllerImpl._internal();
  factory MidiControllerImpl() => _instance;
  MidiControllerImpl._internal();

  final _connectionController = StreamController<bool>.broadcast();
  final _midiEventController = StreamController<MidiEvent>.broadcast();

  JSObject? _midiAccess;
  bool _isConnected = false;
  final Set<String> _connectedInputIds = {};

  @override
  Stream<bool> get connectionStream => _connectionController.stream;

  @override
  Stream<MidiEvent> get midiEventStream => _midiEventController.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> initialize() async {
    try {
      print('🎹 Web MIDI: Requesting access...');

      // Get navigator.requestMIDIAccess()
      final navigator = globalContext['navigator'] as JSObject?;
      if (navigator == null) {
        print('🎹 Web MIDI: navigator is null');
        return;
      }

      // Check if requestMIDIAccess exists
      final requestMIDIAccess = navigator['requestMIDIAccess'];
      if (requestMIDIAccess == null) {
        print(
          '🎹 Web MIDI: requestMIDIAccess not available (not supported or not secure context)',
        );
        return;
      }

      // Call requestMIDIAccess()
      final promise = navigator.callMethod<JSPromise>('requestMIDIAccess'.toJS);
      _midiAccess = await promise.toDart as JSObject?;

      if (_midiAccess == null) {
        print('🎹 Web MIDI: Access denied or null');
        return;
      }

      print('🎹 Web MIDI: Access granted!');
      _setupInputListeners();
    } catch (e) {
      print('🎹 Web MIDI init error: $e');
    }
  }

  void _setupInputListeners() {
    if (_midiAccess == null) return;

    print('🎹 Web MIDI: Setting up input listeners...');

    // Get inputs map
    final inputs = _midiAccess!['inputs'] as JSObject?;
    if (inputs == null) {
      print('🎹 Web MIDI: inputs is null');
      return;
    }

    // Iterate using forEach
    _iterateInputsWithForEach(inputs);

    // Listen for state changes
    _midiAccess!['onstatechange'] = ((JSObject event) {
      print('🎹 Web MIDI: State changed');
      _onStateChange();
    }).toJS;
  }

  void _iterateInputsWithForEach(JSObject inputsMap) {
    try {
      // Create a callback that receives (value, key, map)
      final callback = ((JSObject input, JSAny key, JSAny map) {
        _connectInput(input);
      }).toJS;

      // Call forEach on the inputs map
      inputsMap.callMethod('forEach'.toJS, callback);

      if (_connectedInputIds.isNotEmpty) {
        _isConnected = true;
        _connectionController.add(true);
        print('🎹 Web MIDI: Found ${_connectedInputIds.length} inputs');
      } else {
        print('🎹 Web MIDI: No inputs found');
      }
    } catch (e) {
      print('🎹 Web MIDI: Error iterating inputs: $e');
    }
  }

  void _onStateChange() {
    final inputs = _midiAccess?['inputs'] as JSObject?;
    if (inputs != null) {
      _iterateInputsWithForEach(inputs);
    }

    final hasInputs = _connectedInputIds.isNotEmpty;
    if (hasInputs != _isConnected) {
      _isConnected = hasInputs;
      _connectionController.add(hasInputs);
    }
  }

  void _connectInput(JSObject input) {
    try {
      final inputId = (input['id'] as JSString?)?.toDart ?? '';
      if (_connectedInputIds.contains(inputId)) return;

      _connectedInputIds.add(inputId);

      final name = (input['name'] as JSString?)?.toDart ?? 'Unknown';
      print('🎹 Web MIDI: Connecting input: $inputId - $name');

      // Set onmidimessage handler
      input['onmidimessage'] = ((JSObject event) {
        _handleMidiMessage(event);
      }).toJS;
    } catch (e) {
      print('🎹 Web MIDI connect input error: $e');
    }
  }

  void _handleMidiMessage(JSObject event) {
    try {
      final data = event['data'];
      if (data == null) return;

      // data is a Uint8Array - access as JSObject and get values
      final dataObj = data as JSObject;
      final length = (dataObj['length'] as JSNumber?)?.toDartInt ?? 0;

      if (length < 3) return;

      final status =
          (dataObj.callMethod('at'.toJS, 0.toJS) as JSNumber?)?.toDartInt ?? 0;
      final note =
          (dataObj.callMethod('at'.toJS, 1.toJS) as JSNumber?)?.toDartInt ?? 0;
      final velocity =
          (dataObj.callMethod('at'.toJS, 2.toJS) as JSNumber?)?.toDartInt ?? 0;

      final command = status & 0xF0;

      if (command == 0x90) {
        if (velocity > 0) {
          _midiEventController.add(
            MidiEvent(
              type: MidiEventType.noteOn,
              noteNumber: note,
              velocity: velocity,
            ),
          );
        } else {
          _midiEventController.add(
            MidiEvent(
              type: MidiEventType.noteOff,
              noteNumber: note,
              velocity: 0,
            ),
          );
        }
      } else if (command == 0x80) {
        _midiEventController.add(
          MidiEvent(type: MidiEventType.noteOff, noteNumber: note, velocity: 0),
        );
      }
    } catch (e) {
      print('🎹 MIDI Message Error: $e');
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
