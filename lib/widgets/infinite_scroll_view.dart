import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "package:happy_habit_at/utils/extensions/monadic_nullable.dart";
import "package:happy_habit_at/widgets/prototype_size.dart";
import "package:scroll_animator/scroll_animator.dart";

class InfiniteScrollView extends StatefulWidget {
  const InfiniteScrollView({
    required this.builder,
    this.scrollDirection = Axis.vertical,
    super.key,
  });

  final Widget Function(BuildContext context, int index) builder;
  final Axis scrollDirection;

  @override
  State<InfiniteScrollView> createState() => _InfiniteScrollViewState();
}

class _InfiniteScrollViewState extends State<InfiniteScrollView> {
  late final GlobalKey _center = GlobalKey();
  late final AnimatedScrollController scrollController =
      AnimatedScrollController(animationFactory: ChromiumImpulse());

  @override
  void initState() {
    super.initState();

    // The view is not centered, so we need to scroll to this.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((_center.currentContext!.findRenderObject()! as RenderSliverToBoxAdapter)
              .paintBounds
              .size
              .nullableMap((Size v) => v.width / 2)
          case double v) {
        scrollController.jumpTo(v);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollView child = CustomScrollView(
      scrollDirection: widget.scrollDirection,
      controller: scrollController,
      anchor: 0.5,
      center: _center,
      slivers: <Widget>[
        SliverList.builder(
          itemBuilder: (BuildContext context, int index) {
            return widget.builder(context, -(index + 1));
          },
        ),
        SliverToBoxAdapter(key: _center, child: widget.builder(context, 0)),
        SliverList.builder(
          itemBuilder: (BuildContext context, int index) {
            return widget.builder(context, index + 1);
          },
        ),
      ],
    );

    return switch (widget.scrollDirection) {
      Axis.horizontal => PrototypeHeight(
          prototype: widget.builder(context, 0),
          scrollView: child,
        ),
      Axis.vertical => PrototypeWidth(
          prototype: widget.builder(context, 0),
          scrollView: child,
        ),
    };
  }
}
