import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/screens/home_screen/branch_animator.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";

class ShopScreen extends StatefulWidget {
  const ShopScreen({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final ImmutableList<Widget> children;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// APPBAR
        AppBar(
          title: const Text("Shop"),
          elevation: 2.0,
          shadowColor: Colors.black,
        ),

        /// BODY
        Expanded(
          child: Column(
            children: <Widget>[
              TabBar(
                controller: tabController,
                onTap: widget.navigationShell.goBranch,
                tabs: const <Widget>[
                  Tab(text: "Furniture"),
                  Tab(text: "Food"),
                  Tab(text: "Expansion"),
                  Tab(text: "Pet"),
                ],
              ),

              /// Here is the shell thing.
              Expanded(
                child: BranchAnimator(
                  currentIndex: widget.navigationShell.currentIndex,
                  children: widget.children,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
