import 'dart:async';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../../core/audio/synth.dart';

class SoloudController {
  final SoLoud _soloud = SoLoud.instance;
  AudioSource? _organSource;
  AudioSource? _pianoSource;

  // Base frequency for the generated sample (Middle C)
  static const double _baseFreq = 261.63; // C4

  // Map to track active sound handles for each note index
  // key: noteIndex, value: SoundHandle
  final Map<int, SoundHandle> _activeHandles = {};

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _soloud.init();
    } catch (e) {
      debugPrint('SoLoud init failed: $e');
      return;
    }

    _isInitialized = true;
    _soloud.setGlobalVolume(1.0);

    await _loadBaseSamples();
  }

  Future<void> _loadBaseSamples() async {
    // Generate Organ Sample
    try {
      final organBytes = Synth.generateTone(
        _baseFreq,
        2.0, // Duration (loopable part if possible, but we use strict looping in SoLoud)
        InstrumentType.organ,
      );

      // SoLoud memory loading often requires specific alignment or valid WAV header.
      // Synth.generateTone produces a full WAV file with header.

      // Note: loadMem might be buggy on some platforms or FFI versions for direct bytes.
      // Writing to file is safer and often robust.
      _organSource = await _loadBytesAsSource(organBytes);
      if (_organSource != null) {
        debugPrint(
          '✅ Organ sample loaded successfully. Handle: ${_organSource!.soundHash}',
        );
      } else {
        debugPrint('❌ Organ sample failed to load (null source).');
      }
    } catch (e) {
      debugPrint('Error loading organ sample: $e');
    }

    // Generate Piano Sample
    try {
      final pianoBytes = Synth.generateTone(
        _baseFreq,
        3.0, // Decay duration
        InstrumentType.piano,
      );
      _pianoSource = await _loadBytesAsSource(pianoBytes);
      if (_pianoSource != null) {
        debugPrint(
          '✅ Piano sample loaded successfully. Handle: ${_pianoSource!.soundHash}',
        );
      } else {
        debugPrint('❌ Piano sample failed to load (null source).');
      }
      // Piano doesn't loop
    } catch (e) {
      debugPrint('Error loading piano sample: $e');
    }
  }

  Future<AudioSource?> _loadBytesAsSource(Uint8List bytes) async {
    try {
      // Use loadMem to load directly from memory (works on Web too)
      // The bytes must be a valid audio file (e.g. WAV with header), which generateTone produces.
      final source = await _soloud.loadMem('generated_sample', bytes);
      return source;
    } catch (e) {
      debugPrint('Failed to load buffer: $e');
      return null;
    }
  }

  void dispose() {
    _soloud.deinit();
    _isInitialized = false;
  }

  Future<void> startNote(
    int noteIndex,
    double targetFreq,
    InstrumentType type,
  ) async {
    if (!_isInitialized) return;

    AudioSource? source;
    if (type == InstrumentType.organ) {
      source = _organSource;
    } else {
      source = _pianoSource;
    }

    if (source == null) return;

    // Stop existing note if any (monophonic per key)
    stopNote(noteIndex);

    try {
      final handle = await _soloud.play(
        source,
        looping: type == InstrumentType.organ,
      );
      _activeHandles[noteIndex] = handle;

      final double speed = targetFreq / _baseFreq;
      _soloud.setRelativePlaySpeed(handle, speed);

      // For piano, we might want to vary volume or just let it decay
      // Organ is constant volume
    } catch (e) {
      debugPrint('Error playing note: $e');
    }
  }

  Future<void> stopNote(int noteIndex) async {
    final handle = _activeHandles.remove(noteIndex);
    if (handle != null) {
      try {
        // Check if handle is still valid before stopping
        final isValid = _soloud.getIsValidVoiceHandle(handle);
        if (isValid) {
          // Longer fade to avoid click: reduce volume in more steps over ~65ms
          try {
            _soloud.setVolume(handle, 0.6);
            await Future.delayed(const Duration(milliseconds: 15));
            _soloud.setVolume(handle, 0.3);
            await Future.delayed(const Duration(milliseconds: 15));
            _soloud.setVolume(handle, 0.1);
            await Future.delayed(const Duration(milliseconds: 15));
            _soloud.setVolume(handle, 0.02);
            await Future.delayed(const Duration(milliseconds: 10));
            _soloud.setVolume(handle, 0.0);
            await Future.delayed(const Duration(milliseconds: 10));
          } catch (e) {
            // Ignore volume errors
          }
          _soloud.stop(handle);
        }
      } catch (e) {
        // Silently ignore stop errors - handle may already be invalid
      }
    }
  }

  void stopAll() {
    for (final handle in _activeHandles.values) {
      try {
        _soloud.stop(handle);
      } catch (e) {
        // Determine if handle is still valid
      }
    }
    _activeHandles.clear();
  }
}
