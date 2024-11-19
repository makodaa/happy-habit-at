import "dart:async";

import "package:flutter/material.dart";
import "package:happy_habit_at/widgets/prototype_size.dart";
import "package:scrollable_positioned_list/scrollable_positioned_list.dart";

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({
    required this.initialDate,
    this.selectedDate,
    this.onTap,
    super.key,
  });

  final void Function(DateTime)? onTap;
  final DateTime? selectedDate;
  final DateTime initialDate;

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  static const List<String> _months = <String>[
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  static const List<String> _days = <String>[
    "",
    "Mo",
    "Tu",
    "We",
    "Th",
    "Fr",
    "Sa",
    "Su",
  ];

  late final ItemScrollController itemScrollController = ItemScrollController();
  late final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  late final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  late final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  @override
  void didUpdateWidget(covariant HorizontalCalendar oldWidget) {
    if (oldWidget.selectedDate != widget.selectedDate) {
      int? index = widget.selectedDate?.difference(DateTime(widget.initialDate.year)).inDays;

      if (index case int index) {
        unawaited(
          itemScrollController.scrollTo(
            index: (index - 2).clamp(0, 364 + (_isLeapYear(widget.initialDate.year) ? 1 : 0)),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          ),
        );
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    int daysSinceJan1 = widget.initialDate.difference(DateTime(widget.initialDate.year)).inDays;

    return PrototypeHeight(
      prototype: _buildTile(0),
      scrollView: ScrollablePositionedList.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 365 + (_isLeapYear(widget.initialDate.year) ? 1 : 0),
        itemScrollController: itemScrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        initialScrollIndex: daysSinceJan1 - 2,
        itemBuilder: (BuildContext context, int index) => _buildTile(index),
      ),
    );
  }

  bool _isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  Widget _buildTile(int index) {
    DateTime date = DateTime(widget.initialDate.year).add(Duration(days: index));

    return GestureDetector(
      onTap: () {
        if (widget.onTap case void Function(DateTime) onTap) {
          onTap(date);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                Text(_months[date.month], style: TextStyle(fontSize: 12.0)),
                Text(_days[date.weekday]),
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000.00),
                  child: Container(
                    height: 48.0,
                    color: widget.selectedDate == date ? Colors.green[200] : Colors.transparent,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Center(
                        child: Text("${date.day}"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
