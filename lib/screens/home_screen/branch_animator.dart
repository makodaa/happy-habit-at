import "package:flutter/material.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";

class BranchAnimator extends StatelessWidget {
  const BranchAnimator({
    required this.currentIndex,
    required this.children,
    super.key,
  });

  final int currentIndex;
  final ImmutableList<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (var (int i, Widget child) in children.indexed)
          Transform.scale(
            scale: 1.0,
            child: AnimatedSlide(
              offset: switch (i - currentIndex) {
                < 0 => const Offset(-1, 0),
                > 0 => const Offset(1, 0),
                _ => Offset.zero,
              },
              curve: Curves.easeOutCubic,
              duration: const Duration(milliseconds: 380),
              child: IgnorePointer(
                ignoring: i != currentIndex,
                child: TickerMode(
                  enabled: i == currentIndex,
                  child: child,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
