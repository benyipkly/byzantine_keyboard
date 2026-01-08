import 'dart:math';
import 'dart:typed_data';

enum InstrumentType { piano, organ }

class SynthParams {
  final double frequency;
  final double duration;
  final InstrumentType type;
  final int sampleRate;

  SynthParams(
    this.frequency,
    this.duration,
    this.type, {
    this.sampleRate = 44100,
  });
}

// Helper for soft limiting
double tanh(double x) {
  if (x > 20.0) return 1.0;
  if (x < -20.0) return -1.0;
  var e2x = exp(2 * x);
  return (e2x - 1) / (e2x + 1);
}

Uint8List generateToneIsolated(SynthParams params) {
  return Synth.generateTone(
    params.frequency,
    params.duration,
    params.type,
    sampleRate: params.sampleRate,
  );
}

class Synth {
  /// Generates a WAV file buffer for a given frequency and duration.
  /// Uses additive synthesis based on the specialized instrument type.
  static Uint8List generateTone(
    double frequency,
    double duration,
    InstrumentType type, {
    int sampleRate = 44100,
  }) {
    double effectiveDuration;
    int numSamples;

    if (type == InstrumentType.organ) {
      // For Organ, calculate optimal duration for seamless looping
      // Use longer buffer (5 seconds) to minimize loop transition frequency
      final double targetDuration = 5.0;

      // Calculate samples per cycle for this frequency
      final double samplesPerCycle = sampleRate / frequency;

      // Calculate how many complete cycles fit in target duration
      final int targetSamples = (targetDuration * sampleRate).round();
      final int completeCycles = (targetSamples / samplesPerCycle).round();

      // Calculate exact number of samples for integer cycles
      // Using round() to get the closest integer sample count
      numSamples = (completeCycles * samplesPerCycle).round();
      effectiveDuration = numSamples / sampleRate;
    } else {
      effectiveDuration = duration;
      numSamples = (effectiveDuration * sampleRate).round();
    }

    final int numChannels = 1;
    final int byteRate = sampleRate * numChannels * 2; // 16-bit audio
    final int dataSize = numSamples * numChannels * 2;
    final int totalSize = 36 + dataSize;

    final ByteData fileData = ByteData(totalSize + 8);

    // RIFF header
    fileData.setUint8(0, 0x52); // R
    fileData.setUint8(1, 0x49); // I
    fileData.setUint8(2, 0x46); // F
    fileData.setUint8(3, 0x46); // F
    fileData.setUint32(4, totalSize, Endian.little);
    fileData.setUint8(8, 0x57); // W
    fileData.setUint8(9, 0x41); // A
    fileData.setUint8(10, 0x56); // V
    fileData.setUint8(11, 0x45); // E

    // fmt chunk
    fileData.setUint8(12, 0x66); // f
    fileData.setUint8(13, 0x6d); // m
    fileData.setUint8(14, 0x74); // t
    fileData.setUint8(15, 0x20); // space
    fileData.setUint32(16, 16, Endian.little); // Chunk size
    fileData.setUint16(20, 1, Endian.little); // Audio format (1 = PCM)
    fileData.setUint16(22, numChannels, Endian.little);
    fileData.setUint32(24, sampleRate, Endian.little);
    fileData.setUint32(28, byteRate, Endian.little);
    fileData.setUint16(32, (numChannels * 2), Endian.little); // Block align
    fileData.setUint16(34, 16, Endian.little); // Bits per sample

    // data chunk
    fileData.setUint8(36, 0x64); // d
    fileData.setUint8(37, 0x61); // a
    fileData.setUint8(38, 0x74); // t
    fileData.setUint8(39, 0x61); // a
    fileData.setUint32(40, dataSize, Endian.little);

    // Generate samples
    for (int i = 0; i < numSamples; i++) {
      double t = i / sampleRate;
      double sample = 0.0;

      if (type == InstrumentType.piano) {
        // Piano: Additive synthesis with decay
        // Fundamental + Harmonics
        sample += 1.0 * sin(2 * pi * frequency * t);
        sample += 0.5 * sin(2 * pi * frequency * 2 * t);
        sample += 0.25 * sin(2 * pi * frequency * 3 * t);

        // Exponential decay envelope
        double decay = exp(-3.0 * t / duration);
        sample *= decay;
      } else {
        // Organ: Acoustic-based synthesis with improvements for polyphony

        // 1. SOFT ATTACK ENVELOPE (simulates pipe air buildup)
        // Real organ pipes take ~10-20ms to reach full volume
        // This prevents "click" when note starts
        const int attackSamples = 660; // ~15ms at 44.1kHz
        double attackEnvelope = 1.0;
        if (i < attackSamples) {
          // Sine curve for natural-sounding attack
          attackEnvelope = sin((i / attackSamples) * pi * 0.5);
        }

        // 2. FREQUENCY-DEPENDENT HARMONIC BALANCE
        // Low notes: reduce upper harmonics to prevent harshness
        // High notes: allow more brightness
        double harmonicScale = 1.0;
        if (frequency < 150) {
          harmonicScale = 0.5; // Very low notes: half harmonic intensity
        } else if (frequency < 250) {
          harmonicScale = 0.7; // Low notes: reduced harmonics
        }

        // 3. ADDITIVE SYNTHESIS with tapered harmonics
        // Based on open pipe organ physics
        sample = 0.0;
        sample += 1.0 * sin(2 * pi * frequency * t); // Fundamental
        sample +=
            0.4 *
            harmonicScale *
            sin(2 * pi * frequency * 2 * t); // 2nd harmonic
        sample +=
            0.25 *
            harmonicScale *
            sin(2 * pi * frequency * 3 * t); // 3rd harmonic
        sample +=
            0.15 *
            harmonicScale *
            sin(2 * pi * frequency * 4 * t); // 4th harmonic
        sample +=
            0.08 *
            harmonicScale *
            sin(2 * pi * frequency * 5 * t); // 5th harmonic
        sample +=
            0.04 *
            harmonicScale *
            sin(2 * pi * frequency * 6 * t); // 6th harmonic

        // Normalize (max = 1 + 0.4 + 0.25 + 0.15 + 0.08 + 0.04 = 1.92)
        sample /= 1.92;

        // Apply attack envelope
        sample *= attackEnvelope;
      }

      // Volume: 1.0 (Maximum loudness)
      // We rely on the soft limiter below to handle polyphony summing
      sample *= 1.0;

      // Improved Soft Limiter (Sigmoid-like)
      // Allows signals up to 0.95 linearly, then smoothly saturates
      // This is louder than the previous tanh implementation
      if (sample > 0.95) {
        sample = 0.95 + 0.05 * tanh((sample - 0.95) / 0.05);
      } else if (sample < -0.95) {
        sample = -0.95 + 0.05 * tanh((sample + 0.95) / 0.05);
      }

      // Convert to 16-bit integer with proper clamping
      int val = (sample * 32767).toInt();
      val = val.clamp(-32768, 32767);

      fileData.setInt16(44 + i * 2, val, Endian.little);
    }

    return fileData.buffer.asUint8List();
  }
}
