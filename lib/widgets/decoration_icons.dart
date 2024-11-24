import "package:flutter/material.dart";
import "package:happy_habit_at/constants/decoration_category.dart";
import "package:happy_habit_at/utils/extensions/self.dart";
import "package:scroll_animator/scroll_animator.dart";

class DecorationIcons extends StatefulWidget {
  const DecorationIcons({
    required this.selectedCategory,
    required this.onCategoryChange,
    super.key,
  });

  static const SizedBox separator = SizedBox(width: 8.0);

  final DecorationCategory? selectedCategory;
  final void Function(DecorationCategory? category) onCategoryChange;

  @override
  State<DecorationIcons> createState() => _DecorationIconsState();
}

class _DecorationIconsState extends State<DecorationIcons> {
  late final AnimatedScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = AnimatedScrollController(animationFactory: const ChromiumImpulse());
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DecorationIcons.separator,
              for (var (
                    int i,
                    DecorationCategory(
                      :IconData icon,
                      :String label,
                      self: DecorationCategory category,
                    )
                  ) in DecorationCategory.values.indexed) ...<Widget>[
                if (i > 0) DecorationIcons.separator,
                Builder(
                  builder: (BuildContext context) {
                    Color color = widget.selectedCategory == category ? Colors.green : Colors.black;

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => widget.onCategoryChange(category),
                        child: Chip(
                          side: BorderSide(color: color),
                          avatar: CircleAvatar(
                            backgroundColor: color,
                            child: Icon(icon, size: 12.0),
                          ),
                          label: Text(
                            label,
                            style: TextStyle(color: color),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
              DecorationIcons.separator,
            ],
          ),
        ),
      ),
    );
  }
}
