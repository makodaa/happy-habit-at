import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/widgets/branch_animator.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final ImmutableList<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.grass, size: 14.0),
            label: "Habitat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task, size: 14.0),
            label: "Habits",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag, size: 14.0),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz, size: 14.0),
            label: "More",
          ),
        ],
        onTap: navigationShell.goBranch,
      ),
    );
  }
}
