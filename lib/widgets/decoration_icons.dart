import "package:flutter/material.dart";
import "package:happy_habit_at/constants/decoration_category.dart";
import "package:scroll_animator/scroll_animator.dart";

class DecorationIcons extends StatelessWidget {
  const DecorationIcons({super.key});

  static const SizedBox separator = SizedBox(width: 8.0);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: AnimatedScrollController(animationFactory: ChromiumImpulse()),
      scrollDirection: Axis.horizontal,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: <Widget>[
              separator,
              for (var (int i, DecorationCategory(:IconData icon, :String label))
                  in DecorationCategory.values.indexed) ...<Widget>[
                if (i > 0) separator,
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: Icon(icon, size: 12.0),
                  ),
                  label: Text(label),
                ),
              ],
              separator,
            ],
          ),
        ],
      ),
    );
  }
}
