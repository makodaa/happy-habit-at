import "package:flutter/material.dart";
import "package:happy_habit_at/widgets/currency_display.dart";

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const UserCurrencyDisplay(),
            _fieldSeparator,
            const Text("New Pet"),
            _fieldSeparator,
            Center(
              child: Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.green.shade800,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.catching_pokemon,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Buy a new pet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _fieldSeparator,
                      const Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.0,
                            child: Text("If you can read this, you are a pogger"),
                          ),
                          Positioned.fill(
                            child: Center(child: Text("Roll for a random pet!")),
                          ),
                        ],
                      ),
                      _fieldSeparator,
                      FilledButton(
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 2.0,
                          ),
                          child: Text("Insert price"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const SizedBox _fieldSeparator = SizedBox(height: 16.0);
}
