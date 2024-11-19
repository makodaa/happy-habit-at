import "package:flutter/widgets.dart";
import "package:scroll_animator/scroll_animator.dart";

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({super.key});

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late final UniqueKey _center = UniqueKey();
  late final AnimatedScrollController scrollController =
      AnimatedScrollController(animationFactory: ChromiumImpulse());

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      anchor: 0.5,
      center: _center,
      slivers: <Widget>[
        SliverList.builder(
          itemBuilder: (BuildContext context, int index) {
            return Text((index + 1).toString());
          },
        ),
        SliverToBoxAdapter(key: _center, child: Text("0")),
        SliverList.builder(
          itemBuilder: (BuildContext context, int index) {
            return Text((index + 1).toString());
          },
        ),
      ],
    );
  }
}
