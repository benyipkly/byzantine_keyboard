# Byzantine Keyboard

A professional Byzantine music keyboard application featuring authentic microtonal tuning for the Eight Echoi (modes) of Byzantine chant.

## Features

### 🎹 Dual Instrument Modes
- **Piano Mode**: Classic piano sound with natural decay
- **Organ Mode**: Sustained organ tones with authentic drawbar synthesis

### 🎵 Byzantine Music Theory
- **8 Traditional Echoi**: Complete implementation of all eight Byzantine modes
- **Authentic Genera**: 
  - Diatonic (Hard Diatonic 12-9-9)
  - Soft Chromatic (Malakon 8-14-8)
  - Hard Chromatic (Skleron 6-20-4)
  - Enharmonic (Quarter-tones 12-12-6)

### 🎚️ Advanced Tuning Controls
- **Microtonal Precision**: 72-ET (72 equal divisions per octave) tuning system
- **Per-Key Adjustment**: Individual moria offset sliders for each key
- **Visual Feedback**: Scale degree highlighting and root note indication
- **Preset Scales**: One-click application of traditional Byzantine scales

### 📖 Educational Resources
- **Echoi Reference**: Complete table of all 8 modes with genus recommendations
- **Melody Type Variants**: Different genera for Apolytikia, Stichera, and Heirmologic chant
- **Tuning Legend**: Real-time display of scale degrees and moria adjustments

### 🎮 User Interface
- **Full-Screen Mode**: Immersive experience on mobile devices
- **Collapsible Panels**: Maximize keyboard space when needed
- **Tabbed Interface**: Organized controls and reference materials
- **Horizontal Scrolling**: Access all 37 keys (C3 to C6)
- **Multi-Touch Support**: Play chords and intervals

## Technical Specifications

- **Sample Rate**: 44.1 kHz
- **Bit Depth**: 16-bit PCM
- **Polyphony**: 6-10 simultaneous notes (platform dependent)
- **Tuning System**: Byzantine ET72 (72 moria per octave)
- **Audio Synthesis**: Real-time additive synthesis with harmonic control

## Installation

### From Source
1. Ensure Flutter SDK is installed
2. Clone the repository
3. Run `flutter pub get`
4. Build: `flutter build apk --release`
5. Install on device

### From Play Store
*Coming soon*

## Usage

1. **Select Mode**: Toggle between Piano and Organ using the top-left switch
2. **Choose Genus**: In Organ mode, select from Diatonic, Soft Chromatic, Hard Chromatic, or Enharmonic
3. **Set Root Note**: Choose your starting pitch (C through B)
4. **Play**: Touch keys to produce sound
5. **Adjust Tuning**: Use individual sliders for fine-tuning (Organ mode)
6. **Reference**: Check the Echoi Reference tab for traditional mode information

## Byzantine Music Theory

The app implements the traditional Byzantine music system:

- **Moria**: The smallest interval unit (1/72 of an octave)
- **Tetrachord**: Four-note patterns that define each genus
- **Echoi**: The eight traditional modes of Byzantine chant
- **Genera**: Three main interval patterns (Diatonic, Chromatic, Enharmonic)

## Credits

### Development
- Byzantine music theory implementation
- Microtonal synthesis engine
- UI/UX design

### Technologies
- Flutter framework
- Dart programming language
- AudioPlayers plugin for audio playback

## License

*Add your license here*

## Support

For issues, questions, or suggestions:
- Email: *your-email@example.com*
- GitHub: *your-github-repo*

## Version History

### 1.0.0 (Initial Release)
- Piano and Organ modes
- All 8 Byzantine Echoi
- 4 Traditional Genera
- Microtonal tuning controls
- Educational reference materials

---

**Note**: This app is designed for musicians, musicologists, and students of Byzantine chant. Familiarity with Byzantine music theory is helpful but not required.
