import "dart:io";
import "dart:ui";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:happy_habit_at/global/shared_preferences.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/router.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
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
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();

    await windowManager.ensureInitialized();

    const Size recommendedSize = Size(400, 700);
    const WindowOptions options = WindowOptions(
      minimumSize: recommendedSize,
      maximumSize: recommendedSize,
      size: recommendedSize,
    );

    await windowManager.waitUntilReadyToShow(options);
  }

  AppState state = AppState();
  await Future.wait(<Future<void>>[
    state.init(),
    initSharedPrefences(),
  ]);

  runApp(
    Provider<AppState>.value(
      value: state,
      child: const HappyHabitAtApp(),
    ),
  );
}

class HappyHabitAtApp extends StatelessWidget {
  const HappyHabitAtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Happy Habit-At",
      theme: AppTheme.getAppTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: <PointerDeviceKind>{
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      actions: <Type, Action<Intent>>{
        ...WidgetsApp.defaultActions,
        ScrollIntent: AnimatedScrollAction(),
      },
    );
  }
}
