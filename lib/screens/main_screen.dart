import "package:flutter/material.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int pageIndex;

  @override
  void initState() {
    super.initState();

    pageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Happy Habit-At"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                "Hi $pageIndex",
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // TODO(water-mizuu): Change colors to use ColorTheme.
        unselectedItemColor: const Color(0xFF8A8A8E),
        selectedItemColor: const Color(0xFF0FA958),
        currentIndex: pageIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.animation_sharp, size: 14.0),
            label: "Habitat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task, size: 14.0),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 14.0),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded, size: 14.0),
            label: "Stats",
          ),
        ],
        onTap: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
