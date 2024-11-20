import "package:flutter/material.dart";
import "package:scroll_animator/scroll_animator.dart";

class FurnitureIcons extends StatelessWidget {
  const FurnitureIcons({super.key});

  static const SizedBox separator = SizedBox(width: 8.0);
  static const List<(IconData icon, String label)> icons = <(IconData, String)>[
    (Icons.bed, "Beds"),
    (Icons.chair, "Chairs"),
    (Icons.light, "Lights"),
    (Icons.table_restaurant, "Tables"),
    (Icons.toys, "Small Decoration"),
    (Icons.nature, "Large Decorations"),
  ];

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
              for (var (int i, (IconData icon, String label)) in icons.indexed) ...<Widget>[
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
