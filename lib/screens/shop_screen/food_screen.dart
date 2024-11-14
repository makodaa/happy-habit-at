import "package:flutter/material.dart";

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

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
