import "package:flutter/foundation.dart";

// CREATE TABLE IF NOT EXISTS placement (
//   placement_id INTEGER PRIMARY KEY AUTOINCREMENT,
//   room_id INTEGER NOT NULL REFERENCES room(room_id),
//   decoration_id TEXT NOT NULL REFERENCES decoration(decoration_id),
//   x_coordinate INTEGER NOT NULL,
//   y_coordinate INTEGER NOT NULL,
//   is_flipped INTEGER NOT NULL
// );
class Placement extends ChangeNotifier {
  Placement({
    required int placementId,
    required int roomId,
    required String decorationId,
    required (int, int) tileCoordinate,
    required bool isFlipped,
  })  : _placementId = placementId,
        _roomId = roomId,
        _decorationId = decorationId,
        _tileCoordinate = tileCoordinate,
        _isFlipped = isFlipped;

  factory Placement.fromMap(Map<String, dynamic> json) => Placement(
        placementId: json["placement_id"] as int,
        roomId: json["room_id"] as int,
        decorationId: json["decoration_id"] as String,
        tileCoordinate: (json["x_coordinate"] as int, json["y_coordinate"] as int),
        isFlipped: json["is_flipped"] == 1,
      );

  final int _placementId;
  int get placementId => _placementId;

  final int _roomId;
  int get roomId => _roomId;

  String _decorationId;
  String get decorationId => _decorationId;
  set decorationId(String value) {
    if (value != _decorationId) {
      _decorationId = value;
      notifyListeners();
    }
  }

  (int, int) _tileCoordinate;
  (int, int) get tileCoordinate => _tileCoordinate;
  set tileCoordinate((int, int) value) {
    if (value != _tileCoordinate) {
      _tileCoordinate = value;
      notifyListeners();
    }
  }

  bool _isFlipped;
  bool get isFlipped => _isFlipped;
  set isFlipped(bool value) {
    if (value != _isFlipped) {
      _isFlipped = value;
      notifyListeners();
    }
  }

  Map<String, Object?> toMap() => <String, Object?>{
        "placement_id": _placementId,
        "room_id": _roomId,
        "decoration_id": _decorationId,
        "x_coordinate": _tileCoordinate.$1,
        "y_coordinate": _tileCoordinate.$2,
        "is_flipped": _isFlipped ? 1 : 0,
      };
}
