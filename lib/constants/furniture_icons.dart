// CREATE TABLE IF NOT EXISTS furniture (
//   furniture_id INTEGER PRIMARY KEY AUTOINCREMENT,
//   furniture_name TEXT NOT NULL,
//   furniture_description TEXT NOT NULL,
//   sale_price INTEGER NOT NULL,
//   resale_price INTEGER NOT NULL,
//   quantity_owned INTEGER NOT NULL,
//   happiness_buff REAL NOT NULL,
//   energy_buff REAL NOT NULL
// );

typedef FurnitureIcon = ({
  String name,
  String description,
  int salePrice,
  int resalePrice,
  int happinessBuff,
  int energyBuff,
});

const Map<String, FurnitureIcon> furnitureIcons = <String, FurnitureIcon>{
  /// [key: id]: FurnitureIcon.
};
