import "package:flutter/material.dart";
import "package:happy_habit_at/widgets/furniture_icons.dart";

class FurnitureScreen extends StatelessWidget {
  const FurnitureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FurnitureIcons(),
        Expanded(
          child: Text("Furniture Screen"),
        ),
      ],
    );
  }
}
