import "package:flutter/material.dart";

class HabitatScreen extends StatelessWidget {
  const HabitatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// APPBAR
        AppBar(
          title: const Text("Habitat Page"),
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
