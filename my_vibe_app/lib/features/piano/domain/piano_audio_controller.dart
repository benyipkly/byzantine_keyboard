import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/audio/synth.dart';

class PianoAudioController {
  final int polyphonyCount;
  final bool isWeb;

  // Audio Pool
  late final List<AudioPlayer> _audioPool;

  // State Tracking
  int _currentPlayerIndex = 0;
  final Map<int, AudioPlayer> _activeNotes = {};

  // Concurrency Control
  final Map<int, int> _noteGenerations = {};
  int _globalGenerationCounter = 0;

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

  PianoAudioController({
    required this.polyphonyCount,
    required this.isWeb,
    List<AudioPlayer>? injectedPool, // For testing
  }) {
    // Configure global AudioContext for high-performance concurrent playback
    _configureAudioContext();

    if (injectedPool != null) {
      _audioPool = injectedPool;
    } else {
      _audioPool = List.generate(polyphonyCount, (_) => AudioPlayer());
    }
  }

  Future<void> _configureAudioContext() async {
    final AudioContext audioContext = AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gainTransientMayDuck,
      ),
      iOS: const AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: [AVAudioSessionOptions.mixWithOthers],
      ),
    );
    await AudioPlayer.global.setAudioContext(audioContext);
  }

  void dispose() {
    for (var player in _audioPool) {
      player.dispose();
    }
  }

  Future<void> stopAll() async {
    _noteGenerations.clear();

    final List<Future> stopFutures = [];
    for (var player in _audioPool) {
      stopFutures.add(player.stop());
    }
    _activeNotes.clear();

    try {
      await Future.wait(stopFutures);
    } catch (e) {
      debugPrint('Error stopping all notes: $e');
    }
  }

  void setMoriaOffset(int index, int moria) {
    _moriaOffsets[index] = moria;
    // If note is currently playing, update its pitch in real-time by re-synthesizing
    if (_activeNotes.containsKey(index)) {
      _updateActiveNote(index);
    }
  }

  int getMoriaOffset(int index) => _moriaOffsets[index] ?? 0;

  // Cache for audio sources to prevent re-synthesis overhead
  final Map<String, Source> _sourceCache = {};

  Future<void> startNote(int index, InstrumentType instrumentType) async {
    if (index < 0 || index >= _frequencies.length) return;

    // Concurrency: New Generation ID
    _globalGenerationCounter++;
    final int myGenerationId = _globalGenerationCounter;
    _noteGenerations[index] = myGenerationId;

    // Ignore re-trigger for sustained Organ
    if (_activeNotes.containsKey(index) &&
        instrumentType == InstrumentType.organ) {
      return;
    }

    // Smart Round-Robin Allocation
    AudioPlayer? selectedPlayer;
    int selectedIndex = -1;

    for (int i = 0; i < polyphonyCount; i++) {
      final int candidateIndex = (_currentPlayerIndex + i) % polyphonyCount;
      final AudioPlayer candidate = _audioPool[candidateIndex];

      if (!_activeNotes.containsValue(candidate)) {
        selectedPlayer = candidate;
        selectedIndex = candidateIndex;
        break;
      }
    }

    // Fallback: Steal
    if (selectedPlayer == null) {
      selectedPlayer = _audioPool[_currentPlayerIndex];
      selectedIndex = _currentPlayerIndex;
    }

    _currentPlayerIndex = (selectedIndex + 1) % polyphonyCount;

    // Handle Voice Stealing
    _activeNotes.removeWhere((k, v) => v == selectedPlayer);
    _activeNotes[index] = selectedPlayer!;

    // === Get or Generate Source ===
    final int moria = _moriaOffsets[index] ?? 0;
    // Cache key based on index, type and tuning
    final String cacheKey = '${index}_${instrumentType.name}_$moria';

    Source? source = _sourceCache[cacheKey];

    if (source == null) {
      final double baseFreq = _frequencies[index];
      final double effectiveFreq = baseFreq * pow(2.0, moria / 72.0);

      final wavBytes = await compute(
        generateToneIsolated,
        SynthParams(effectiveFreq, 0.5, instrumentType),
      );

      // Use BytesSource for Native, and cached Base64 UrlSource for Web
      // BytesSource throws UnimplementedError on some web versions of audioplayers
      if (isWeb) {
        final base64Data = base64Encode(wavBytes);
        final dataUrl = 'data:audio/wav;base64,$base64Data';
        source = UrlSource(dataUrl);
      } else {
        source = BytesSource(wavBytes);
      }
      _sourceCache[cacheKey] = source;
    }

    try {
      // Optimize latency: Don't await stop() on web
      if (isWeb) {
        selectedPlayer.stop();
      } else {
        await selectedPlayer.stop();
      }

      if (_noteGenerations[index] != myGenerationId) return;

      if (instrumentType == InstrumentType.organ) {
        await selectedPlayer.setReleaseMode(ReleaseMode.loop);
      } else {
        await selectedPlayer.setReleaseMode(ReleaseMode.release);
      }

      await selectedPlayer.setSource(source);

      if (_noteGenerations[index] != myGenerationId) return;
      if (_activeNotes[index] != selectedPlayer) {
        return;
      }

      await selectedPlayer.resume();
    } catch (e) {
      if (e.toString().contains('interrupted by a call to pause') ||
          e.toString().contains('AbortError')) {
        return;
      }
      debugPrint('Error playing note: $e');
    }
  }

  // Hot-swap active note pitch (clears cache for this note)
  Future<void> _updateActiveNote(int index) async {
    // Invalidate cache since pitch changed
    final moria = _moriaOffsets[index] ?? 0;
    // We don't know the exact previous key without tracking,
    // but we can just let the cache grow slightly or clear it.
    // For now, simpler to just re-generate and not cache sliding notes.

    final player = _activeNotes[index];
    if (player == null) return;

    final baseFreq = _frequencies[index];
    final effectiveFreq = baseFreq * pow(2.0, moria / 72.0);

    final wavBytes = await compute(
      generateToneIsolated,
      SynthParams(effectiveFreq, 0.5, InstrumentType.organ),
    );

    try {
      await player.setSource(BytesSource(wavBytes));
      await player.resume();
    } catch (e) {
      debugPrint('Error updating note pitch: $e');
    }
  }

  Future<void> stopNote(int index, InstrumentType instrumentType) async {
    _noteGenerations.remove(index);

    if (instrumentType == InstrumentType.organ) {
      final player = _activeNotes[index];
      if (player != null) {
        try {
          await player.stop();
        } catch (e) {
          /* ignore */
        }
        _activeNotes.remove(index);
      }
    } else {
      _activeNotes.remove(index);
    }
  }
}
