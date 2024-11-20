import "package:flutter/material.dart";

// CREATE TABLE IF NOT EXISTS room (
//   room_id INTEGER PRIMARY KEY AUTOINCREMENT,
//   room_name TEXT NOT NULL,
//   room_size INTEGER NOT NULL,
//   room_tile_id TEXT NOT NULL,
//   pet_id INTEGER NOT NULL,
//   pet_hunger INTEGER NOT NULL,
//   pet_happiness INTEGER NOT NULL,
//   pet_energy INTEGER NOT NULL,
//   pet_x INTEGER NOT NULL,
//   pet_y INTEGER NOT NULL,
//   pet_orientation INTEGER NOT NULL
// )
class Room extends ChangeNotifier {
  Room({
    required int id,
    required String name,
    required int size,
    required String tileId,
    required String petId,
    required int petHunger,
    required int petHappiness,
    required int petEnergy,
    required (int, int) petPosition,
    required bool petOrientation,
  })  : _id = id,
        _name = name,
        _size = size,
        _tileId = tileId,
        _petId = petId,
        _petHunger = petHunger,
        _petHappiness = petHappiness,
        _petEnergy = petEnergy,
        _petPosition = petPosition,
        _petIsFlipped = petOrientation;

  Room.fromMap(Map<String, Object?> map)
      : _id = map["room_id"]! as int,
        _name = map["room_name"]! as String,
        _size = map["room_size"]! as int,
        _tileId = map["room_tile_id"]! as String,
        _petId = map["pet_id"]! as String,
        _petHunger = map["pet_hunger"]! as int,
        _petHappiness = map["pet_happiness"]! as int,
        _petEnergy = map["pet_energy"]! as int,
        _petPosition = (map["pet_x"]! as int, map["pet_y"]! as int),
        _petIsFlipped = <bool>[false, true][map["pet_is_flipped"]! as int];

  final int _id;
  int get id => _id;

  String _name;
  String get name => _name;
  set name(String value) {
    if (name != value) {
      _name = value;
      notifyListeners();
    }
  }

  int _size;
  int get size => _size;
  set size(int value) {
    if (size != value) {
      _size = value;
      notifyListeners();
    }
  }

  String _tileId;
  String get tileId => _tileId;
  set tileId(String value) {
    if (tileId != value) {
      _tileId = value;
      notifyListeners();
    }
  }

  String _petId;
  String get petId => _petId;
  set petId(String value) {
    if (petId != value) {
      _petId = value;
      notifyListeners();
    }
  }

  int _petHunger;
  int get petHunger => _petHunger;
  set petHunger(int value) {
    if (petHunger != value) {
      _petHunger = value;
      notifyListeners();
    }
  }

  int _petHappiness;
  int get petHappiness => _petHappiness;
  set petHappiness(int value) {
    if (petHappiness != value) {
      _petHappiness = value;
      notifyListeners();
    }
  }

  int _petEnergy;
  int get petEnergy => _petEnergy;
  set petEnergy(int value) {
    if (petEnergy != value) {
      _petEnergy = value;
      notifyListeners();
    }
  }

  (int, int) _petPosition;
  (int, int) get petPosition => _petPosition;
  set petPosition((int, int) value) {
    if (petPosition != value) {
      _petPosition = value;
      notifyListeners();
    }
  }

  bool _petIsFlipped;
  bool get petIsFlipped => _petIsFlipped;
  set petIsFlipped(bool value) {
    if (petIsFlipped != value) {
      _petIsFlipped = value;
      notifyListeners();
    }
  }
}
