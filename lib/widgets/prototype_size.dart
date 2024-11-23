// https://stackoverflow.com/questions/50155738/flutter-minimum-height-on-horizontal-list-view
import "package:flutter/material.dart";

class PrototypeHeight extends StatelessWidget {
  const PrototypeHeight({
    required this.prototype,
    required this.scrollView,
    super.key,
  });

  final Widget prototype;
  final Widget scrollView;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.0,
          child: IgnorePointer(
            child: TickerMode(
              enabled: false,
              child: prototype,
            ),
          ),
        ),
        const SizedBox(width: double.infinity),
        Positioned.fill(child: scrollView),
      ],
    );
  }
}

class PrototypeWidth extends StatelessWidget {
  const PrototypeWidth({
    required this.prototype,
    required this.scrollView,
    super.key,
  });

  final Widget prototype;
  final Widget scrollView;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.0,
          child: IgnorePointer(
            child: TickerMode(
              enabled: false,
              child: prototype,
            ),
          ),
        ),
        const SizedBox(height: double.infinity),
        Positioned.fill(child: scrollView),
      ],
    );
  }
}
