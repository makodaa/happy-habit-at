import "package:flutter/material.dart";
import "package:happy_habit_at/widgets/infinite_scroll_view.dart";
import "package:scroll_animator/scroll_animator.dart";

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({required this.initialDate, super.key});

  final DateTime initialDate;

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  static const List<String> days = <String>[
    "",
    "Mo",
    "Tu",
    "We",
    "Th",
    "Fr",
    "Sa",
    "Su",
  ];

  late final AnimatedScrollController scrollController =
      AnimatedScrollController(animationFactory: ChromiumImpulse());

  @override
  Widget build(BuildContext context) {
    return InfiniteScrollView(
      scrollDirection: Axis.horizontal,
      builder: (BuildContext context, int index) => _buildTile(index),
    );
  }

  Widget _buildTile(int index) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: ColoredBox(
          color: index == 0 ? Colors.green : Colors.grey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                Text(
                  days[widget.initialDate.add(Duration(days: index)).weekday],
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "${widget.initialDate.add(Duration(days: index)).day}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
