import "package:flutter/foundation.dart";

// decoration_id TEXT PRIMARY KEY,
// quantity_owned INTEGER NOT NULL,
// happiness_buff REAL NOT NULL,
// energy_buff REAL NOT NULL
/// This class [HabitatDecoration] only contains the volatile state of decoration.
class HabitatDecoration extends ChangeNotifier {
  HabitatDecoration({
    required this.id,
    required int quantityOwned,
    required double happinessBuff,
    required double energyBuff,
  })  : _quantityOwned = quantityOwned,
        _happinessBuff = happinessBuff,
        _energyBuff = energyBuff;

  factory HabitatDecoration.fromMap(Map<String, dynamic> json) => HabitatDecoration(
        id: json["decoration_id"] as String,
        quantityOwned: json["quantity_owned"] as int,
        happinessBuff: json["happiness_buff"] as double,
        energyBuff: json["energy_buff"] as double,
      );

  final String id;

  int _quantityOwned;
  int get quantityOwned => _quantityOwned;
  set quantityOwned(int value) {
    if (value != _quantityOwned) {
      _quantityOwned = value;
      notifyListeners();
    }
  }

  double _happinessBuff;
  double get happinessBuff => _happinessBuff;
  set happinessBuff(double value) {
    if (value != _happinessBuff) {
      _happinessBuff = value;
      notifyListeners();
    }
  }

  double _energyBuff;
  double get energyBuff => _energyBuff;
  set energyBuff(double value) {
    if (value != _energyBuff) {
      _energyBuff = value;
      notifyListeners();
    }
  }
}
