import "package:flutter/material.dart" hide Decoration;
import "package:happy_habit_at/providers/habitat_decoration.dart";

class ModifyHabitatState with ChangeNotifier {
  bool? _decorationIsNew;
  bool? get decorationIsNew => _decorationIsNew;
  set decorationIsNew(bool? value) {
    _decorationIsNew = value;
    notifyListeners();
  }

  HabitatDecoration? _movingDecoration;
  HabitatDecoration? get movingDecoration => _movingDecoration;
  set movingDecoration(HabitatDecoration? value) {
    _movingDecoration = value;
    notifyListeners();
  }
}
