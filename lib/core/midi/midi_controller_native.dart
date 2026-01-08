/// Native (Android/iOS) MIDI implementation using flutter_midi_command
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import 'midi_controller_interface.dart';
export 'midi_controller_interface.dart';

/// Native implementation of MidiController using flutter_midi_command
class MidiControllerImpl implements MidiControllerInterface {
  static final MidiControllerImpl _instance = MidiControllerImpl._internal();
  factory MidiControllerImpl() => _instance;
  MidiControllerImpl._internal();

  final MidiCommand _midiCommand = MidiCommand();

  final _connectionController = StreamController<bool>.broadcast();
  final _midiEventController = StreamController<MidiEvent>.broadcast();

  MidiDevice? _connectedDevice;
  StreamSubscription? _midiDataSubscription;
  StreamSubscription? _setupSubscription;

  @override
  Stream<bool> get connectionStream => _connectionController.stream;

  @override
  Stream<MidiEvent> get midiEventStream => _midiEventController.stream;

  @override
  bool get isConnected => _connectedDevice != null;

  @override
  Future<void> initialize() async {
    _setupSubscription = _midiCommand.onMidiSetupChanged?.listen((_) {
      _scanAndConnect();
    });
    await _scanAndConnect();
  }

  Future<void> _scanAndConnect() async {
    try {
      final devices = await _midiCommand.devices;

      MidiDevice? inputDevice;
      for (final device in devices ?? []) {
        if (device.inputPorts.isNotEmpty) {
          inputDevice = device;
          break;
        }
      }

      if (inputDevice != null && _connectedDevice?.id != inputDevice.id) {
        await _connectToDevice(inputDevice);
      } else if (inputDevice == null && _connectedDevice != null) {
        await _disconnect();
      }
    } catch (e) {
      debugPrint('MIDI scan error: $e');
    }
  }

  Future<void> _connectToDevice(MidiDevice device) async {
    try {
      await _midiCommand.connectToDevice(device);
      _connectedDevice = device;
      _connectionController.add(true);

      _midiDataSubscription?.cancel();
      _midiDataSubscription = _midiCommand.onMidiDataReceived?.listen(
        _handleMidiData,
      );

      debugPrint('MIDI connected: ${device.name}');
    } catch (e) {
      debugPrint('MIDI connect error: $e');
    }
  }

  Future<void> _disconnect() async {
    if (_connectedDevice != null) {
      try {
        _midiCommand.disconnectDevice(_connectedDevice!);
      } catch (e) {
        // Ignore
      }
      _connectedDevice = null;
      _midiDataSubscription?.cancel();
      _connectionController.add(false);
    }
  }

  void _handleMidiData(MidiPacket packet) {
    final data = packet.data;
    if (data.isEmpty) return;

    final status = data[0];
    final command = status & 0xF0;

    if (command == 0x90 && data.length >= 3) {
      final note = data[1];
      final velocity = data[2];

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
          MidiEvent(type: MidiEventType.noteOff, noteNumber: note, velocity: 0),
        );
      }
    } else if (command == 0x80 && data.length >= 3) {
      final note = data[1];
      _midiEventController.add(
        MidiEvent(type: MidiEventType.noteOff, noteNumber: note, velocity: 0),
      );
    }
  }

  @override
  void dispose() {
    _setupSubscription?.cancel();
    _midiDataSubscription?.cancel();
    _connectionController.close();
    _midiEventController.close();
  }
}

/// Factory function for conditional imports
MidiControllerInterface createMidiController() => MidiControllerImpl();
