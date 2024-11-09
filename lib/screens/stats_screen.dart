import "package:flutter/material.dart";

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// APPBAR
        AppBar(title: const Text("Stats Page")),

        /// BODY
        const Expanded(
          child: Column(
            children: <Widget>[
              /// Place body widgets here.
              Center(
                child: Text("Hi"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
