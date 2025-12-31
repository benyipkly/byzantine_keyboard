import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'features/piano/presentation/piano_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Run in a zone to catch async errors (silences Wasm type cast errors from SoLoud callbacks)
  runZonedGuarded(() => runApp(const MyVibeApp()), (error, stackTrace) {
    // Silently ignore type cast errors from Wasm runtime
    if (error.toString().contains('is not a subtype of type')) {
      return; // Ignore these non-fatal Wasm errors
    }
    // Log other errors
    debugPrint('Uncaught error: $error');
  });
}

class MyVibeApp extends StatelessWidget {
  const MyVibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Byzantine Keyboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A11CB)),
        fontFamily:
            'Roboto', // Default, but good to be explicit or use GoogleFonts later
      ),
      home: const PianoScreen(),
    );
  }
}
