import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";
import "package:happy_habit_at/widgets/branch_animator.dart";

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

    // TODO(water-mizuu): Modify
    tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        widget.navigationShell.goBranch(tabController.index);
      });
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
          scrolledUnderElevation: 0.0,
          title: const Center(child: Text("Shop")),
        ),

        /// BODY
        Expanded(
          child: Column(
            children: <Widget>[
              TabBar(
                controller: tabController,
                tabs: const <Widget>[
                  Tab(text: "Decoration"),
                  // Tab(text: "Food"),
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
