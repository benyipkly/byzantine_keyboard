import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/audio/synth.dart';
import '../../../../core/midi/midi_controller.dart';
import '../domain/piano_audio_controller.dart';

/// Byzantine Genera definitions using authentic tetrachord patterns.
/// Each genus defines intervals in moria (1 octave = 72 moria, 1 semitone = 6 moria).
///
/// A Byzantine scale typically consists of:
/// - Lower tetrachord (3 intervals summing to ~30 moria for a perfect 4th)
/// - Disjunct tone (12 moria)
/// - Upper tetrachord (3 intervals summing to ~30 moria)
/// Total: 72 moria per octave
class ByzantineGenus {
  final String name;
  final String description;

  /// Intervals in moria for an 8-note scale (7 intervals from root to octave)
  final List<int> intervals;

  const ByzantineGenus({
    required this.name,
    required this.description,
    required this.intervals,
  });

  /// Calculate cumulative moria positions for each scale degree
  List<int> get cumulativeMoria {
    List<int> result = [0]; // Root is always 0
    int sum = 0;
    for (int interval in intervals) {
      sum += interval;
      result.add(sum);
    }
    return result;
  }
}

/// Standard Byzantine genera based on traditional church music theory
class ByzantineGenera {
  /// Hard Diatonic (Διατονικόν Σκληρόν)
  /// Tetrachords: 12-9-9 | 12 | 12-9-9
  static const diatonic = ByzantineGenus(
    name: 'Diatonic',
    description: 'Hard Diatonic (12-9-9)',
    intervals: [12, 9, 9, 12, 12, 9, 9], // Sum = 72
  );

  /// Soft Chromatic (Χρωματικόν Μαλακόν)
  /// Tetrachords: 8-14-8 | 12 | 8-14-8
  static const softChromatic = ByzantineGenus(
    name: 'Soft Chromatic',
    description: 'Malakon (8-14-8)',
    intervals: [8, 14, 8, 12, 8, 14, 8], // Sum = 72
  );

  /// Hard Chromatic (Χρωματικόν Σκληρόν)
  /// Tetrachords: 6-20-4 | 12 | 6-20-4
  static const hardChromatic = ByzantineGenus(
    name: 'Hard Chromatic',
    description: 'Skleron (6-20-4)',
    intervals: [6, 20, 4, 12, 6, 20, 4], // Sum = 72
  );

  /// Enharmonic (Εναρμόνιον)
  /// Tetrachords: 12-12-6 | 12 | 12-12-6
  static const enharmonic = ByzantineGenus(
    name: 'Enharmonic',
    description: 'Quarter-tones (12-12-6)',
    intervals: [12, 12, 6, 12, 12, 12, 6], // Sum = 72
  );

  static const List<ByzantineGenus> all = [
    diatonic,
    softChromatic,
    hardChromatic,
    enharmonic,
  ];
}

/// Byzantine Echos (Mode/Tone) definitions with genus recommendations
/// Based on traditional Byzantine chant music theory
enum MelodyType { apolytikion, sticheron, irmolos }

class ByzantineEchos {
  final int number;
  final String name;
  final String greekName;
  final String finalis; // Ending note
  final Map<MelodyType, ByzantineGenus> genusRecommendations;
  final String description;

  const ByzantineEchos({
    required this.number,
    required this.name,
    required this.greekName,
    required this.finalis,
    required this.genusRecommendations,
    required this.description,
  });
}

/// The 8 Byzantine Echoi with their traditional genus associations
class ByzantineEchoi {
  static const echos1 = ByzantineEchos(
    number: 1,
    name: 'First Mode',
    greekName: 'Ἦχος αʹ (Protos)',
    finalis: 'D',
    genusRecommendations: {
      MelodyType.apolytikion: ByzantineGenera.diatonic,
      MelodyType.sticheron: ByzantineGenera.diatonic,
      MelodyType.irmolos: ByzantineGenera.diatonic,
    },
    description: 'Majestic, triumphant character',
  );

  static const echos2 = ByzantineEchos(
    number: 2,
    name: 'Second Mode',
    greekName: 'Ἦχος βʹ (Deuteros)',
    finalis: 'E',
    genusRecommendations: {
      MelodyType.apolytikion: ByzantineGenera.softChromatic,
      MelodyType.sticheron: ByzantineGenera.softChromatic,
      MelodyType.irmolos: ByzantineGenera.softChromatic,
    },
    description: 'Sorrowful, penitential character',
  );

  static const echos3 = ByzantineEchos(
    number: 3,
    name: 'Third Mode',
    greekName: 'Ἦχος γʹ (Tritos)',
    finalis: 'F',
    genusRecommendations: {
      MelodyType.apolytikion: ByzantineGenera.enharmonic,
      MelodyType.sticheron: ByzantineGenera.enharmonic,
      MelodyType.irmolos: ByzantineGenera.enharmonic,
    },
    description: 'Smooth, flowing character',
  );

  static const echos4 = ByzantineEchos(
    number: 4,
    name: 'Fourth Mode',
    greekName: 'Ἦχος δʹ (Tetartos)',
    finalis: 'G',
    genusRecommendations: {
      MelodyType.apolytikion: ByzantineGenera.softChromatic,
      MelodyType.sticheron: ByzantineGenera.softChromatic,
      MelodyType.irmolos: ByzantineGenera.diatonic,
    },
    description: 'Festive, joyful character',
  );

  static const echosPlagal1 = ByzantineEchos(
    number: 5,
    name: 'Plagal First',
    greekName: 'Ἦχος πλ. αʹ',
    finalis: 'A',
    genusRecommendations: {
      MelodyType.apolytikion: ByzantineGenera.diatonic,
      MelodyType.sticheron: ByzantineGenera.diatonic,
      MelodyType.irmolos: ByzantineGenera.diatonic,
    },
    description: 'Calm, meditative character',
  );

  static const echosPlagal2 = ByzantineEchos(
    number: 6,
    name: 'Plagal Second',
    greekName: 'Ἦχος πλ. βʹ',
    finalis: 'B',
    genusRecommendations: {
      MelodyType.apolytikion: ByzantineGenera.softChromatic,
      MelodyType.sticheron: ByzantineGenera.hardChromatic,
      MelodyType.irmolos: ByzantineGenera.softChromatic,
    },
    description: 'Deeply penitential, sorrowful',
  );

  static const echosVarys = ByzantineEchos(
    number: 7,
    name: 'Varys (Grave)',
    greekName: 'Ἦχος βαρύς',
    finalis: 'C',
    genusRecommendations: {
      MelodyType.apolytikion: ByzantineGenera.enharmonic,
      MelodyType.sticheron: ByzantineGenera.enharmonic,
      MelodyType.irmolos: ByzantineGenera.enharmonic,
    },
    description: 'Noble, dignified character',
  );

  static const echosPlagal4 = ByzantineEchos(
    number: 8,
    name: 'Plagal Fourth',
    greekName: 'Ἦχος πλ. δʹ',
    finalis: 'D',
    genusRecommendations: {
      MelodyType.apolytikion: ByzantineGenera.diatonic,
      MelodyType.sticheron: ByzantineGenera.diatonic,
      MelodyType.irmolos: ByzantineGenera.diatonic,
    },
    description: 'Solemn, devotional character',
  );

  static const List<ByzantineEchos> all = [
    echos1,
    echos2,
    echos3,
    echos4,
    echosPlagal1,
    echosPlagal2,
    echosVarys,
    echosPlagal4,
  ];
}

/// Represents a tuned note with all calculation details
class TunedNote {
  final int scaleDegree;
  final int targetMoria; // Cumulative moria from root in Byzantine system
  final int closestKeyIndex; // Index of closest 12-TET key (relative to root)
  final int keyMoria12TET; // Moria position of that key in 12-TET (key * 6)
  final int sliderAdjustment; // Offset needed: targetMoria - keyMoria12TET

  const TunedNote({
    required this.scaleDegree,
    required this.targetMoria,
    required this.closestKeyIndex,
    required this.keyMoria12TET,
    required this.sliderAdjustment,
  });
}

/// Calculates the tuning map for a given genus and root note
class ByzantineTuner {
  /// Calculate tuned notes for a Byzantine scale
  ///
  /// [rootKeyIndex] - The index of the root key (0 = C4, 1 = C#4, etc.)
  /// [genus] - The Byzantine genus to apply
  /// [totalKeys] - Total number of keys on the keyboard
  static Map<int, TunedNote> calculateTuning({
    required int rootKeyIndex,
    required ByzantineGenus genus,
    required int totalKeys,
  }) {
    final Map<int, TunedNote> tuning = {};
    final List<int> cumulativeMoria = genus.cumulativeMoria;

    // For each octave covered by our keyboard
    for (int octaveOffset = -2; octaveOffset <= 2; octaveOffset++) {
      // For each scale degree (0-7 for an 8-note scale)
      for (int degree = 0; degree < cumulativeMoria.length; degree++) {
        // Target moria from the root (across octaves)
        int targetMoria = cumulativeMoria[degree] + (octaveOffset * 72);

        // Find the closest 12-TET key
        // In 12-TET, each semitone = 6 moria
        // Closest key = round(targetMoria / 6)
        int closestKeyOffset = (targetMoria / 6).round();
        int absoluteKeyIndex = rootKeyIndex + closestKeyOffset;

        // Skip if outside our keyboard range
        if (absoluteKeyIndex < 0 || absoluteKeyIndex >= totalKeys) continue;

        // Skip if we already have a tuning for this key (prefer lower octave/degree)
        if (tuning.containsKey(absoluteKeyIndex)) continue;

        // Calculate the 12-TET moria position of this key
        int keyMoria12TET = closestKeyOffset * 6;

        // Slider adjustment = difference between target and 12-TET position
        int sliderAdjustment = targetMoria - keyMoria12TET;

        // Clamp to our slider range (-12 to +12)
        sliderAdjustment = sliderAdjustment.clamp(-12, 12);

        tuning[absoluteKeyIndex] = TunedNote(
          scaleDegree: degree,
          targetMoria: targetMoria,
          closestKeyIndex: closestKeyOffset,
          keyMoria12TET: keyMoria12TET,
          sliderAdjustment: sliderAdjustment,
        );
      }
    }

    return tuning;
  }
}

class PianoKeyboard extends StatefulWidget {
  final InstrumentType instrumentType;
  final ValueChanged<InstrumentType> onInstrumentChanged;

  const PianoKeyboard({
    super.key,
    this.instrumentType = InstrumentType.piano,
    required this.onInstrumentChanged,
  });

  @override
  State<PianoKeyboard> createState() => _PianoKeyboardState();
}

class _PianoKeyboardState extends State<PianoKeyboard> {
  // Web audio supports high polyphony, mobile is more restricted
  static final int _polyphonyCount = kIsWeb ? 32 : 12;

  late final PianoAudioController _audioController;
  final Set<int> _pressedIndices = {};

  // Local moria offsets for UI (synced with controller) - 37 keys (C3 to C6)
  final List<int> _moriaOffsets = List.filled(37, 0);

  // Current tuning info for display
  Map<int, TunedNote> _currentTuning = {};

  // Selected root note index (0 = C4)
  int _rootNoteIndex = 0;

  // Selected genus
  ByzantineGenus _selectedGenus = ByzantineGenera.diatonic;

  // Scroll control for keyboard navigation
  double _scrollOffset = 0;

  // Window States
  // Panel State
  bool _isPanelExpanded = true;
  // 0 = Tuning, 1 = Reference
  int _activeTab = 0;

  // User interaction flag for Web Audio Context
  bool _hasUserInteracted = false;

  // MIDI Controller
  final MidiController _midiController = MidiController();
  StreamSubscription? _midiEventSubscription;
  StreamSubscription? _midiConnectionSubscription;
  bool _midiConnected = false;

  final Map<LogicalKeyboardKey, int> _keyMap = {
    LogicalKeyboardKey.keyA: 0,
    LogicalKeyboardKey.keyW: 1,
    LogicalKeyboardKey.keyS: 2,
    LogicalKeyboardKey.keyE: 3,
    LogicalKeyboardKey.keyD: 4,
    LogicalKeyboardKey.keyF: 5,
    LogicalKeyboardKey.keyT: 6,
    LogicalKeyboardKey.keyG: 7,
    LogicalKeyboardKey.keyY: 8,
    LogicalKeyboardKey.keyH: 9,
    LogicalKeyboardKey.keyU: 10,
    LogicalKeyboardKey.keyJ: 11,
    LogicalKeyboardKey.keyK: 12,
    LogicalKeyboardKey.keyO: 13,
    LogicalKeyboardKey.keyL: 14,
    LogicalKeyboardKey.keyP: 15,
    LogicalKeyboardKey.semicolon: 16,
    LogicalKeyboardKey.quote: 17,
  };

  @override
  void initState() {
    super.initState();
    _audioController = PianoAudioController(
      polyphonyCount: _polyphonyCount,
      isWeb: kIsWeb,
    );

    // Initialize MIDI controller
    _initMidi();

    // Initialize tuning if starting in Organ mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.instrumentType == InstrumentType.organ) {
        _applyGenus(_selectedGenus);
      }
    });
  }

  void _initMidi() {
    _midiController.initialize();

    // Listen for connection changes
    _midiConnectionSubscription = _midiController.connectionStream.listen((
      connected,
    ) {
      setState(() {
        _midiConnected = connected;
      });
    });

    // Listen for MIDI events
    _midiEventSubscription = _midiController.midiEventStream.listen(
      _handleMidiEvent,
    );
  }

  void _handleMidiEvent(MidiEvent event) {
    // Convert MIDI note number to our keyboard index
    // Our keyboard starts at C3 (MIDI note 48) and goes to C6 (MIDI note 84)
    // Index 0 = C3 = MIDI 48
    // Index 36 = C6 = MIDI 84
    final int keyIndex = event.noteNumber - 48;

    if (keyIndex < 0 || keyIndex >= 37) return; // Out of range

    if (event.type == MidiEventType.noteOn) {
      _handleNoteOn(keyIndex);
    } else {
      _handleNoteOff(keyIndex);
    }
  }

  void _handleNoteOn(int index) {
    try {
      if (!_pressedIndices.contains(index)) {
        setState(() {
          _pressedIndices.add(index);
        });
        _audioController.startNote(index, widget.instrumentType);
      }
    } catch (e) {
      debugPrint('❌ _handleNoteOn error: $e');
    }
  }

  void _handleNoteOff(int index) {
    try {
      setState(() {
        _pressedIndices.remove(index);
      });
      _audioController.stopNote(index, widget.instrumentType);
    } catch (e) {
      debugPrint('❌ _handleNoteOff error: $e');
    }
  }

  final List<String> _noteNames = [
    // Octave 3
    'C3', 'C#3', 'D3', 'D#3', 'E3', 'F3', 'F#3', 'G3', 'G#3', 'A3', 'A#3', 'B3',
    // Octave 4
    'C4', 'C#4', 'D4', 'D#4', 'E4', 'F4', 'F#4', 'G4', 'G#4', 'A4', 'A#4', 'B4',
    // Octave 5
    'C5', 'C#5', 'D5', 'D#5', 'E5', 'F5', 'F#5', 'G5', 'G#5', 'A5', 'A#5', 'B5',
    // C6
    'C6',
  ];

  void _resetAllSliders() {
    setState(() {
      _currentTuning = {};
      for (int i = 0; i < _moriaOffsets.length; i++) {
        _moriaOffsets[i] = 0;
        _audioController.setMoriaOffset(i, 0);
      }
    });
  }

  void _applyGenus(ByzantineGenus genus) {
    setState(() {
      _selectedGenus = genus;
      _currentTuning = ByzantineTuner.calculateTuning(
        rootKeyIndex: _rootNoteIndex,
        genus: genus,
        totalKeys: 37,
      );

      // Apply tuning to all keys
      for (int i = 0; i < _moriaOffsets.length; i++) {
        if (_currentTuning.containsKey(i)) {
          _moriaOffsets[i] = _currentTuning[i]!.sliderAdjustment;
        } else {
          _moriaOffsets[i] = 0; // Non-scale notes stay at 12-TET
        }
        _audioController.setMoriaOffset(i, _moriaOffsets[i]);
      }
    });
  }

  void _setRootNote(int index) {
    setState(() {
      _rootNoteIndex = index;
    });
    // Re-apply current genus with new root
    _applyGenus(_selectedGenus);
  }

  void _setMoriaOffset(int index, int value) {
    setState(() {
      _moriaOffsets[index] = value.clamp(-12, 12);
      _audioController.setMoriaOffset(index, _moriaOffsets[index]);
    });
  }

  @override
  void didUpdateWidget(PianoKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.instrumentType != oldWidget.instrumentType) {
      _audioController.stopAll();
      setState(() {
        _pressedIndices.clear();
      });

      // When switching to Piano, reset all tuning to standard 12-TET
      if (widget.instrumentType == InstrumentType.piano) {
        _currentTuning = {};
        for (int i = 0; i < _moriaOffsets.length; i++) {
          _moriaOffsets[i] = 0;
          _audioController.setMoriaOffset(i, 0);
        }
      }
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    final index = _keyMap[event.logicalKey];
    if (index == null) return;

    if (event is KeyDownEvent) {
      if (!_pressedIndices.contains(index)) {
        setState(() => _pressedIndices.add(index));
        _audioController.startNote(index, widget.instrumentType);
      }
    } else if (event is KeyUpEvent) {
      setState(() => _pressedIndices.remove(index));
      _audioController.stopNote(index, widget.instrumentType);
    }
  }

  @override
  void dispose() {
    _midiEventSubscription?.cancel();
    _midiConnectionSubscription?.cancel();
    _audioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isOrgan = widget.instrumentType == InstrumentType.organ;

    return Stack(
      children: [
        // Main content
        Column(
          children: [
            // 1. Top Bar (Always Visible Control Header)
            Container(
              height: 50,
              color: Colors.black45,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _buildInstrumentToggle(),
                  const SizedBox(width: 8),
                  // MIDI Connection Indicator
                  Tooltip(
                    message: _midiConnected
                        ? 'MIDI Device Connected'
                        : 'No MIDI Device',
                    child: Icon(
                      Icons.usb,
                      color: _midiConnected ? Colors.greenAccent : Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  // Fullscreen Toggle
                  IconButton(
                    onPressed: _toggleFullScreen,
                    icon: const Icon(Icons.fullscreen, color: Colors.white70),
                    tooltip: 'Toggle Fullscreen',
                  ),
                  if (isOrgan) ...[
                    const SizedBox(width: 8),
                    // Vertical Space Hint
                    if (_isPanelExpanded &&
                        MediaQuery.of(context).size.height < 450)
                      const Tooltip(
                        message:
                            'Screen height is low. Collapse controls for better view.',
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isPanelExpanded = !_isPanelExpanded;
                        });
                      },
                      icon: Icon(
                        _isPanelExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.white,
                      ),
                      label: Text(
                        _isPanelExpanded ? 'Hide Controls' : 'Show Controls',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // 2. Collapsible Control Panel (Organ Mode Only)
            if (isOrgan && _isPanelExpanded)
              Container(
                height: 220, // Fixed height for the panel
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  border: Border(
                    bottom: BorderSide(color: Colors.white12, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    // Tab Selection
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _activeTab = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _activeTab == 0
                                    ? Colors.white10
                                    : Colors.transparent,
                                border: Border(
                                  bottom: BorderSide(
                                    color: _activeTab == 0
                                        ? Colors.orangeAccent
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Tuning & Controls',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _activeTab = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _activeTab == 1
                                    ? Colors.white10
                                    : Colors.transparent,
                                border: Border(
                                  bottom: BorderSide(
                                    color: _activeTab == 1
                                        ? Colors.orangeAccent
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Echoi Reference',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Content Area
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: _activeTab == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildControlsRowContent(),
                                  const SizedBox(height: 12),
                                  if (_currentTuning.isNotEmpty)
                                    _buildTuningInfoContent(),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Byzantine Echoi Reference — Genus by Melody Type',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  _buildEchosReferenceContent(),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),

            // 3. Keyboard Layer
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isOrgan ? const Color(0xFF3E2723) : Colors.black,
                  gradient: isOrgan
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF5D4037),
                            Color(0xFF3E2723),
                            Color(0xFF281E1E),
                          ],
                        )
                      : null,
                ),
                child: _buildKeyboard(isOrgan),
              ),
            ),
          ],
        ),
        // Tap to Start Overlay
        if (!_hasUserInteracted)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _hasUserInteracted = true;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.85),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 80,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Tap to Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enables audio playback',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _toggleFullScreen() {
    if (kIsWeb) {
      // On Web, we can't easily force true fullscreen without user gesture + dart:html/js_interop
      // But we can suggest the browser to hide UI or use PWA display modes.
      // For now, we'll rely on SystemChrome which might help on mobile browsers.
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  Widget _buildInstrumentToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SegmentedButton<InstrumentType>(
        segments: const <ButtonSegment<InstrumentType>>[
          ButtonSegment<InstrumentType>(
            value: InstrumentType.piano,
            label: Text('Piano'),
            icon: Icon(Icons.music_note, size: 16),
          ),
          ButtonSegment<InstrumentType>(
            value: InstrumentType.organ,
            label: Text('Organ'),
            icon: Icon(Icons.grid_view, size: 16),
          ),
        ],
        selected: <InstrumentType>{widget.instrumentType},
        onSelectionChanged: (Set<InstrumentType> newSelection) {
          widget.onInstrumentChanged(newSelection.first);
        },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: MaterialStateProperty.resolveWith<Color>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF6A11CB);
            }
            return Colors.transparent;
          }),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
    );
  }

  Widget _buildEchosReferenceContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ByzantineEchoi.all
            .map((echos) => _buildEchosCard(echos))
            .toList(),
      ),
    );
  }

  Widget _buildEchosCard(ByzantineEchos echos) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.brown[600]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mode ${echos.number}',
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          Text(
            echos.greekName,
            style: const TextStyle(color: Colors.white70, fontSize: 8),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Finalis: ${echos.finalis}',
            style: const TextStyle(color: Colors.white54, fontSize: 8),
          ),
          const Divider(height: 8, color: Colors.brown),
          _buildGenusRow(
            'Apol.',
            echos.genusRecommendations[MelodyType.apolytikion]!,
          ),
          _buildGenusRow(
            'Stich.',
            echos.genusRecommendations[MelodyType.sticheron]!,
          ),
          _buildGenusRow(
            'Irmo.',
            echos.genusRecommendations[MelodyType.irmolos]!,
          ),
        ],
      ),
    );
  }

  Widget _buildGenusRow(String label, ByzantineGenus genus) {
    Color genusColor;
    switch (genus.name) {
      case 'Diatonic':
        genusColor = Colors.green;
        break;
      case 'Soft Chromatic':
        genusColor = Colors.orange;
        break;
      case 'Hard Chromatic':
        genusColor = Colors.red;
        break;
      case 'Enharmonic':
        genusColor = Colors.purple;
        break;
      default:
        genusColor = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 8),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: genusColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              genus.name
                  .split(' ')
                  .first, // "Diatonic", "Soft", "Hard", "Enharmonic"
              style: TextStyle(
                color: genusColor,
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsRowContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reset Button
          IconButton(
            onPressed: _resetAllSliders,
            icon: const Icon(Icons.refresh, size: 18),
            color: Colors.white70,
            tooltip: 'Reset Tuning',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),

          // Root Note Selector
          const Text(
            'Root:',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<int>(
              value: _rootNoteIndex,
              dropdownColor: Colors.grey[800],
              style: const TextStyle(color: Colors.white, fontSize: 11),
              isDense: true,
              underline: const SizedBox(),
              items: List.generate(
                12,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(_noteNames[i].replaceAll('4', '')),
                ),
              ),
              onChanged: (val) => val != null ? _setRootNote(val) : null,
            ),
          ),
          const SizedBox(width: 16),

          // Genera Presets
          const Text(
            'Genus:',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(width: 6),
          ...ByzantineGenera.all.map(
            (genus) => _GenusButton(
              label: genus.name,
              isSelected: _selectedGenus.name == genus.name,
              onPressed: () => _applyGenus(genus),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTuningInfoContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_selectedGenus.name} Scale on ${_noteNames[_rootNoteIndex].replaceAll('4', '')} — ${_selectedGenus.description}',
          style: const TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildLegend(),
              const SizedBox(width: 16),
              ..._buildScaleDegreeCards(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Target: Byzantine moria',
            style: TextStyle(color: Colors.white54, fontSize: 9),
          ),
          Text(
            '12-TET: Standard tuning',
            style: TextStyle(color: Colors.white54, fontSize: 9),
          ),
          Text(
            'Adj: Slider offset',
            style: TextStyle(color: Colors.white54, fontSize: 9),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScaleDegreeCards() {
    // Get scale degrees in order
    List<MapEntry<int, TunedNote>> entries = _currentTuning.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Filter to first octave from root
    entries = entries
        .where((e) => e.key >= _rootNoteIndex && e.key <= _rootNoteIndex + 12)
        .toList();

    return entries.map((entry) {
      final note = entry.value;
      final keyName = _noteNames[entry.key];
      return Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: note.sliderAdjustment == 0
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
          border: Border.all(
            color: entry.key == _rootNoteIndex
                ? Colors.orangeAccent
                : Colors.grey,
            width: entry.key == _rootNoteIndex ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Text(
              keyName,
              style: TextStyle(
                color: entry.key == _rootNoteIndex
                    ? Colors.orangeAccent
                    : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
            Text(
              'Deg: ${note.scaleDegree}',
              style: const TextStyle(color: Colors.white70, fontSize: 9),
            ),
            const Divider(height: 4, color: Colors.grey),
            Text(
              'Target: ${note.targetMoria}m',
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 9),
            ),
            Text(
              '12-TET: ${note.keyMoria12TET}m',
              style: const TextStyle(color: Colors.white54, fontSize: 9),
            ),
            Text(
              'Adj: ${note.sliderAdjustment > 0 ? '+' : ''}${note.sliderAdjustment}',
              style: TextStyle(
                color: note.sliderAdjustment == 0
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildKeyboard(bool isOrgan) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 350;
        final double availableWidth = constraints.maxWidth;

        // Account for the padding (10 on top + 10 on bottom = 20)
        final double contentHeight = availableHeight - 20;

        final double sliderHeight = isOrgan ? 140 : 0;
        final double keyboardHeight = contentHeight - sliderHeight;

        // Standard size calculation
        final double baseWhiteKeyHeight = keyboardHeight * 0.95;
        final double baseWhiteKeyWidth = baseWhiteKeyHeight * 0.24;

        // 22 white keys total in 3 octaves (C3-C6)
        final double totalRequiredWidthAtBaseSize = baseWhiteKeyWidth * 22;

        double finalWhiteKeyWidth;
        double maxScrollExtent;
        bool enableScroll;

        if (totalRequiredWidthAtBaseSize <= availableWidth) {
          // FIT: Expand keys to fill width
          finalWhiteKeyWidth = availableWidth / 22;
          maxScrollExtent = 0;
          enableScroll = false;
          _scrollOffset = 0;
        } else {
          // SCROLL: Use base size and scroll
          finalWhiteKeyWidth = baseWhiteKeyWidth;
          maxScrollExtent = totalRequiredWidthAtBaseSize - availableWidth;
          enableScroll = true;
        }

        final double finalWhiteKeyHeight = baseWhiteKeyHeight;
        final double finalBlackKeyHeight = finalWhiteKeyHeight * 0.6;
        final double finalBlackKeyWidth = finalWhiteKeyWidth * 0.65;

        // Ensure scroll offset is valid
        if (_scrollOffset > maxScrollExtent) {
          _scrollOffset = maxScrollExtent;
        }

        List<Widget> whiteKeyStack = [];
        List<Widget> blackKeyStack = [];

        bool isBlack(int indexInOctave) =>
            [1, 3, 6, 8, 10].contains(indexInOctave);

        for (int i = 0; i < 37; i++) {
          int indexInOctave = i % 12;
          bool black = isBlack(indexInOctave);

          // Only apply scale highlighting in Organ mode
          bool isScaleNote = isOrgan && _currentTuning.containsKey(i);
          bool isRoot = isOrgan && i == _rootNoteIndex;

          Widget? sliderWithInput;
          if (isOrgan) {
            sliderWithInput = SizedBox(
              height: sliderHeight,
              width: black ? finalBlackKeyWidth : finalWhiteKeyWidth,
              child: _MicrotonalSliderWithInput(
                value: _moriaOffsets[i],
                onChanged: (val) => _setMoriaOffset(i, val),
                isBlackKey: black,
                isScaleNote: isScaleNote,
                isRoot: isRoot,
                tuningInfo: _currentTuning[i],
              ),
            );
          }

          if (!black) {
            whiteKeyStack.add(
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isOrgan) sliderWithInput!,
                  SizedBox(
                    width: finalWhiteKeyWidth,
                    height: finalWhiteKeyHeight,
                    child: _StyledPianoKey(
                      isBlack: false,
                      isScaleNote: isScaleNote,
                      isRoot: isRoot,
                      onTrigger: () {
                        _audioController.startNote(i, widget.instrumentType);
                        setState(() => _pressedIndices.add(i));
                      },
                      onRelease: () {
                        _audioController.stopNote(i, widget.instrumentType);
                        setState(() => _pressedIndices.remove(i));
                      },
                      label: _noteNames[i],
                      isPressed: _pressedIndices.contains(i),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Calculate black key position relative to white keys
            int whiteKeysBefore = 0;
            for (int j = 0; j < i; j++) {
              if (!isBlack(j % 12)) whiteKeysBefore++;
            }
            final double leftPos =
                whiteKeysBefore * finalWhiteKeyWidth - (finalBlackKeyWidth / 2);

            blackKeyStack.add(
              Positioned(
                left: leftPos,
                top: 0,
                child: Column(
                  children: [
                    if (isOrgan) sliderWithInput!,
                    SizedBox(
                      width: finalBlackKeyWidth,
                      height: finalBlackKeyHeight,
                      child: _StyledPianoKey(
                        isBlack: true,
                        isScaleNote: isScaleNote,
                        isRoot: isRoot,
                        onTrigger: () {
                          _audioController.startNote(i, widget.instrumentType);
                          setState(() => _pressedIndices.add(i));
                        },
                        onRelease: () {
                          _audioController.stopNote(i, widget.instrumentType);
                          setState(() => _pressedIndices.remove(i));
                        },
                        label: '',
                        isPressed: _pressedIndices.contains(i),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        return Focus(
          autofocus: true,
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              _audioController.stopAll();
              setState(() => _pressedIndices.clear());
            }
          },
          onKeyEvent: (node, event) {
            _handleKeyEvent(event);
            return KeyEventResult.handled;
          },
          child: Column(
            children: [
              // Keyboard with optional horizontal drag scrolling
              Expanded(
                child: GestureDetector(
                  onHorizontalDragUpdate: enableScroll
                      ? (details) {
                          setState(() {
                            _scrollOffset = (_scrollOffset - details.delta.dx)
                                .clamp(0.0, maxScrollExtent);
                          });
                        }
                      : null,
                  behavior: HitTestBehavior.translucent,
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      maxWidth: double.infinity,
                      child: Transform.translate(
                        offset: Offset(-_scrollOffset, 0),
                        child: Container(
                          height: availableHeight,
                          width: enableScroll
                              ? totalRequiredWidthAtBaseSize
                              : availableWidth,
                          padding: const EdgeInsets.all(10),
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: whiteKeyStack,
                              ),
                              ...blackKeyStack,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Scroll Position Indicator (Conditionally shown)
              if (enableScroll)
                SafeArea(
                  top: false,
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white54,
                          size: 16,
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              activeTrackColor: Colors.white38,
                              inactiveTrackColor: Colors.white12,
                              thumbColor: Colors.white70,
                            ),
                            child: Slider(
                              value: _scrollOffset,
                              min: 0,
                              max: maxScrollExtent,
                              onChanged: (val) =>
                                  setState(() => _scrollOffset = val),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white54,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              if (!enableScroll) const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _GenusButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _GenusButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.orangeAccent,
          backgroundColor: isSelected
              ? Colors.orangeAccent
              : Colors.transparent,
          side: BorderSide(
            color: Colors.orangeAccent,
            width: isSelected ? 2 : 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        child: Text(label, style: const TextStyle(fontSize: 11)),
      ),
    );
  }
}

/// Piano key with scale highlighting
class _StyledPianoKey extends StatefulWidget {
  final bool isBlack;
  final bool isScaleNote;
  final bool isRoot;
  final VoidCallback onTrigger;
  final VoidCallback onRelease;
  final String label;
  final bool isPressed;

  const _StyledPianoKey({
    required this.isBlack,
    required this.isScaleNote,
    required this.isRoot,
    required this.onTrigger,
    required this.onRelease,
    this.label = '',
    this.isPressed = false,
  });

  @override
  State<_StyledPianoKey> createState() => _StyledPianoKeyState();
}

class _StyledPianoKeyState extends State<_StyledPianoKey> {
  final Set<int> _activePointers = {};

  void _handlePointerDown(PointerDownEvent event) {
    if (_activePointers.isEmpty) {
      widget.onTrigger();
    }
    _activePointers.add(event.pointer);
    setState(() {});
  }

  void _handlePointerUp(PointerUpEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.isEmpty) {
      widget.onRelease();
    }
    setState(() {});
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.isEmpty) {
      widget.onRelease();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool active = _activePointers.isNotEmpty || widget.isPressed;

    // Determine key color based on state
    Color keyColor;
    if (widget.isBlack) {
      if (active) {
        keyColor = Colors.grey[700]!;
      } else if (widget.isRoot) {
        keyColor = Colors.deepOrange[900]!;
      } else if (widget.isScaleNote) {
        keyColor = Colors.orange[900]!;
      } else {
        keyColor = Colors.black;
      }
    } else {
      if (active) {
        keyColor = Colors.grey[300]!;
      } else if (widget.isRoot) {
        keyColor = Colors.orange[300]!;
      } else if (widget.isScaleNote) {
        keyColor = Colors.orange[100]!;
      } else {
        keyColor = Colors.white;
      }
    }

    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widget.isBlack ? 2 : 1),
        decoration: BoxDecoration(
          color: keyColor,
          border: Border.all(
            color: widget.isRoot ? Colors.deepOrange : Colors.black,
            width: widget.isRoot ? 2 : 1,
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.isBlack ? Colors.white : Colors.black,
            fontSize: 10,
            fontWeight: widget.isRoot ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _MicrotonalSliderWithInput extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final bool isBlackKey;
  final bool isScaleNote;
  final bool isRoot;
  final TunedNote? tuningInfo;

  const _MicrotonalSliderWithInput({
    required this.value,
    required this.onChanged,
    required this.isBlackKey,
    this.isScaleNote = false,
    this.isRoot = false,
    this.tuningInfo,
  });

  @override
  State<_MicrotonalSliderWithInput> createState() =>
      _MicrotonalSliderWithInputState();
}

class _MicrotonalSliderWithInputState
    extends State<_MicrotonalSliderWithInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(_MicrotonalSliderWithInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String text) {
    final parsed = int.tryParse(text);
    if (parsed != null) {
      widget.onChanged(parsed.clamp(-12, 12));
    } else {
      _controller.text = widget.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = widget.isRoot
        ? Colors.deepOrange
        : (widget.isScaleNote
              ? Colors.orange
              : (widget.isBlackKey ? Colors.grey : Colors.blue));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text Input
        SizedBox(
          width: 32,
          height: 22,
          child: TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: accentColor),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(color: accentColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(color: accentColor.withOpacity(0.5)),
              ),
              filled: true,
              fillColor: Colors.grey[900],
            ),
            onSubmitted: _onSubmitted,
          ),
        ),
        const SizedBox(height: 2),
        // Slider
        Expanded(
          child: RotatedBox(
            quarterTurns: -1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(size: const Size(90, 18), painter: _RulerPainter()),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 8,
                    ),
                    activeTrackColor: accentColor,
                    inactiveTrackColor: Colors.grey.withOpacity(0.5),
                    thumbColor: widget.isRoot
                        ? Colors.deepOrange
                        : Colors.white,
                  ),
                  child: Slider(
                    value: widget.value.toDouble(),
                    min: -12,
                    max: 12,
                    divisions: 24,
                    onChanged: (v) => widget.onChanged(v.toInt()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RulerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;

    const int divisions = 24;
    final double step = size.width / divisions;

    for (int i = 0; i <= divisions; i++) {
      final double x = i * step;
      final bool isCenter = i == 12;
      final bool isMajor = (i - 12) % 3 == 0;

      final double height = isCenter ? 12.0 : (isMajor ? 8.0 : 4.0);
      final double yStart = (size.height - height) / 2;

      if (isCenter) {
        paint.color = Colors.redAccent;
      } else if (isMajor) {
        paint.color = Colors.white.withOpacity(0.8);
      } else {
        paint.color = Colors.white.withOpacity(0.3);
      }

      canvas.drawLine(Offset(x, yStart), Offset(x, yStart + height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
