import "package:flutter/material.dart";

enum DecorationCategory {
  beds(label: "Beds", icon: Icons.bed),
  chairs(label: "Chairs", icon: Icons.chair),
  lights(label: "Lights", icon: Icons.light),
  tables(label: "Tables", icon: Icons.table_restaurant),
  smallDecoration(label: "Small Decoration", icon: Icons.toys),
  largeDecoration(label: "Large Decoration", icon: Icons.nature);

  const DecorationCategory({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}
