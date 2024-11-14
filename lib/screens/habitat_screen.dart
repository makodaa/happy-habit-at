import "package:flutter/material.dart";
import "package:intl/intl.dart";

class HabitatScreen extends StatefulWidget {
  const HabitatScreen({super.key});

  @override
  State<HabitatScreen> createState() => _HabitatScreenState();
}

class _HabitatScreenState extends State<HabitatScreen> {
  late int currency = 1434;
  late String habitatName = "Keane's Habitat";
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green.shade500,
              title: const Text("Habitat Page"),
              shadowColor: Colors.black,
            ),
            Expanded(
              child: Container(
                color: Colors.green.shade500,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            NumberFormat("#,##0", "en_US").format(currency),
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.circle,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 12.0,
          right: 12.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.build),
              ),
              SizedBox(
                height: 16,
              ),
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.food_bank),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
