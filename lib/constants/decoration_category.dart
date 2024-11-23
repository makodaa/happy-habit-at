import "package:flutter/material.dart";

enum DecorationCategory {
  nature(label: "Nature", icon: Icons.eco),
  furniture(label: "Furniture", icon: Icons.chair),
  camping(label: "Camping", icon: Icons.lightbulb),;

  const DecorationCategory({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}
