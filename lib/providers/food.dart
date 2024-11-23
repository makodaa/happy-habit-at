import "package:flutter/foundation.dart";

// food_id TEXT PRIMARY KEY,
// quantity_owned INTEGER NOT NULL
class Food extends ChangeNotifier {
  Food({
    required this.id,
    required int quantityOwned,
  }) : _quantityOwned = quantityOwned;

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map["food_id"] as String,
      quantityOwned: map["quantity_owned"] as int,
    );
  }

  final String id;

  int _quantityOwned;
  int get quantityOwned => _quantityOwned;
  set quantityOwned(int value) {
    _quantityOwned = value;
    notifyListeners();
  }
}
