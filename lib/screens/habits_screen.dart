import "package:flutter/material.dart";

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// APPBAR
        AppBar(
          title: const Text("Habits Page"),
          elevation: 2.0,
          shadowColor: Colors.black,
        ),

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
