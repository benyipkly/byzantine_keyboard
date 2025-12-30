import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/piano/presentation/piano_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyVibeApp());
}

class MyVibeApp extends StatelessWidget {
  const MyVibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Vibe App',
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
