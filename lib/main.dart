import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:happy_habit_at/router.dart";
import "package:window_manager/window_manager.dart";

ColorScheme appColorScheme = ColorScheme(
  primary: Colors.green[800]!,
  primaryContainer: const Color.fromRGBO(165, 214, 167, 1),
  onPrimary: Colors.white,
  secondary: Colors.teal[900]!,
  secondaryContainer: const Color(0xFF59B1A1),
  onSecondary: const Color(0xFF322942),
  error: const Color(0xFF790000),
  onError: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black,
  brightness: Brightness.light,
);

class AppTheme {
  static ThemeData getAppTheme() {
    return ThemeData(
      colorScheme: appColorScheme,
      fontFamily: GoogleFonts.lato().fontFamily,
      scaffoldBackgroundColor: appColorScheme.surface,
      highlightColor: Colors.transparent,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// This should only run if we're running on desktop.
  if (!(kIsWeb || Platform.isAndroid || Platform.isIOS)) {
    await windowManager.ensureInitialized();

    const Size recommendedSize = Size(375, 650);
    const WindowOptions options = WindowOptions(
      minimumSize: recommendedSize,
      maximumSize: recommendedSize,
      size: recommendedSize,
    );

    await windowManager.waitUntilReadyToShow(options);
  }
  runApp(const HappyHabitAtApp());
}

class HappyHabitAtApp extends StatelessWidget {
  const HappyHabitAtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Happy Habit-At",
      theme: AppTheme.getAppTheme(),
      routerConfig: router,
    );
  }
}
