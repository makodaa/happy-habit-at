import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Happy Habit-At"),
      ),
      body: BranchAnimator(
        currentIndex: navigationShell.currentIndex,
        children: children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // TODO(water-mizuu): Change colors to use ColorTheme.
        unselectedItemColor: const Color(0xFF8A8A8E),
        selectedItemColor: const Color(0xFF0FA958),
        currentIndex: navigationShell.currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.animation_sharp, size: 14.0),
            label: "Habitat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task, size: 14.0),
            label: "Habits",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task, size: 14.0),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task, size: 14.0),
            label: "Stats",
          ),
        ],
        onTap: (int index) {
          print("");

          return navigationShell.goBranch(index);
        },
      ),
    );
  }
}

class BranchAnimator extends StatelessWidget {
  const BranchAnimator({required this.currentIndex, required this.children, super.key});

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (var (int i, Widget child) in children.indexed)
          AnimatedSlide(
            offset: i < currentIndex
                ? const Offset(-1, 0)
                : i > currentIndex
                    ? const Offset(1, 0)
                    : Offset.zero,
            curve: Curves.easeInOutQuart,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: i != currentIndex,
              child: TickerMode(
                enabled: i == currentIndex,
                child: child,
              ),
            ),
          ),
      ],
    );
  }
}
