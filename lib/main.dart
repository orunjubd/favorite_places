import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:favorite_places/screens/favorite_place_screen.dart';

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 63, 17, 177),
  surface: const Color.fromARGB(255, 56, 49, 66),
  brightness: Brightness.dark,
);

final ThemeData theme = ThemeData().copyWith(
  colorScheme: colorScheme,
  scaffoldBackgroundColor: colorScheme.surface,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
  ),
);

void main() {
  runApp(
    // 🔴 CRITICAL: Stores state data for all of Riverpod
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      theme: theme,
      home: const FavoritePlaceScreen(), // Links to our main screen widget
    );
  }
}
