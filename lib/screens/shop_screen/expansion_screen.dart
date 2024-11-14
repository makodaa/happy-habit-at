import "package:flutter/material.dart";

class ExpansionScreen extends StatelessWidget {
  const ExpansionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Expansion Screen"),
      ],
    );
  }
}
