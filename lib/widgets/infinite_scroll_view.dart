import "package:flutter/widgets.dart";
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
  late final UniqueKey _center = UniqueKey();
  late final AnimatedScrollController scrollController =
      AnimatedScrollController(animationFactory: ChromiumImpulse());

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
  }
}
