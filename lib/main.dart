import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

ColorScheme appColorScheme = ColorScheme(
  primary: Colors.green.shade800,
  primaryContainer: const Color.fromRGBO(165, 214, 167, 1),
  onPrimary: Colors.white,
  secondary: Colors.teal.shade900,
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Happy Habit-At",
      theme: AppTheme.getAppTheme(),
      home: const MyHomePage(title: "Happy Habit-At"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "You have pushed the button this many times:",
            ),
            Text(
              "$_counter",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
    );
  }
}
