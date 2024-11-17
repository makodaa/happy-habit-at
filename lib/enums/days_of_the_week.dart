enum DaysOfTheWeek {
  sunday(0, "Su"),
  monday(1, "Mo"),
  tuesday(2, "Tu"),
  wednesday(3, "We"),
  thursday(4, "Th"),
  friday(5, "Fr"),
  saturday(6, "Sa");

  const DaysOfTheWeek(this._value, this.shortName);

  final int _value;
  final String shortName;

  static List<DaysOfTheWeek> fromBitValues(int bitValue) {
    assert(
      0 <= bitValue && bitValue <= 0x7F,
      "Bit value must be between 0 and (2^7 - 1) inclusive.",
    );

    return <DaysOfTheWeek>[
      for (DaysOfTheWeek day in DaysOfTheWeek.values)
        if (day.bitValue & bitValue != 0) day,
    ];
  }

  int get bitValue => 1 << _value;
}
