import "package:flutter/material.dart";

// CREATE TABLE IF NOT EXISTS room (
//   room_id INTEGER PRIMARY KEY AUTOINCREMENT,
//   room_name TEXT NOT NULL,
//   room_size INTEGER NOT NULL,
//   pet_id INTEGER NOT NULL,
//   pet_hunger INTEGER NOT NULL,
//   pet_happiness INTEGER NOT NULL,
//   pet_energy INTEGER NOT NULL,
//   pet_x INTEGER NOT NULL,
//   pet_y INTEGER NOT NULL,
//   pet_orientation INTEGER NOT NULL
// );
class Room extends ChangeNotifier {
  Room({
    required this.id,
    required this.name,
    required this.size,
    required this.petId,
    required this.petHunger,
    required this.petHappiness,
    required this.petEnergy,
    required this.petPosition,
    required this.petOrientation,
  });

  Room.fromMap(Map<String, Object?> map)
      : id = map["room_id"]! as int,
        name = map["room_name"]! as String,
        size = map["room_size"]! as int,
        petId = map["pet_id"]! as String,
        petHunger = map["pet_hunger"]! as int,
        petHappiness = map["pet_happiness"]! as int,
        petEnergy = map["pet_energy"]! as int,
        petPosition = (map["pet_x"]! as int, map["pet_y"]! as int),
        petOrientation = map["pet_orientation"]! as int;

  final int id;
  String name;
  int size;

  String petId;
  int petHunger;
  int petHappiness;
  int petEnergy;
  (int, int) petPosition;
  int petOrientation;
}
