import "package:flutter/foundation.dart";
import "package:happy_habit_at/utils/extension_types/ids.dart";

// pet_id TEXT PRIMARY KEY,
// is_owned INTEGER NOT NULL,
// room_id INTEGER REFERENCES room(room_id)

class Pet extends ChangeNotifier {
  Pet({required this.id, required int isOwned, required roomId}) : _isOwned = isOwned;

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: PetId(map["pet_id"] as String),
      isOwned: map["is_owned"] as int,
      roomId: map["room_id"],
    );
  }

  final PetId id;
  int _isOwned;
  int get isOwned => _isOwned;
  set isOwned(int value) {
    isOwned = value;
    notifyListeners();
  }
}
