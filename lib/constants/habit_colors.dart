import "package:flutter/material.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";

typedef ColorPair = ({Color background, Color foreground});

final ImmutableList<ColorPair> habitColors = ImmutableList<ColorPair>(<ColorPair>[
  (background: Colors.red.shade200, foreground: Colors.red.shade400),
  (background: Colors.orange.shade200, foreground: Colors.orange.shade400),
  (background: Colors.yellow.shade200, foreground: Colors.yellow.shade400),
  (background: Colors.green.shade200, foreground: Colors.green.shade400),
  (background: Colors.blue.shade200, foreground: Colors.blue.shade400),
  (background: Colors.indigo.shade200, foreground: Colors.indigo.shade400),
  (background: Colors.purple.shade200, foreground: Colors.purple.shade400),
]);
