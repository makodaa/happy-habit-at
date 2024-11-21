extension type const Completion._((int id, int habitId, DateTime dateTime) _) implements Object {
  const Completion({
    required int id,
    required int habitId,
    required DateTime dateTime,
  }) : this._((id, habitId, dateTime));

  factory Completion.fromMap(Map<String, dynamic> map) => Completion(
        id: map["activity_id"] as int,
        habitId: map["habit_id"] as int,
        dateTime: DateTime.fromMillisecondsSinceEpoch(map["date_time"] as int),
      );

  int get id => _.$1;
  int get habitId => _.$2;
  DateTime get dateTime => _.$3;
}
