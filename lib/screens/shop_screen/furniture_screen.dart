import "package:flutter/material.dart";

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

class FurnitureIcons extends StatelessWidget {
  const FurnitureIcons({super.key});

  static const SizedBox separator = SizedBox(width: 8.0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: <Widget>[
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Icon(Icons.bed, size: 12.0),
              ),
              label: const Text("Beds"),
            ),
            separator,
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Icon(Icons.bed, size: 12.0),
              ),
              label: const Text("Walls"),
            ),
            separator,
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Icon(Icons.bed, size: 12.0),
              ),
              label: const Text("Floor"),
            ),
            separator,
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Icon(Icons.bed, size: 12.0),
              ),
              label: const Text("Lights"),
            ),
            separator,
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Icon(Icons.bed, size: 12.0),
              ),
              label: const Text("Whatever"),
            ),
          ],
        ),
      ),
    );
  }
}
