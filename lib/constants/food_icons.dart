// food_id TEXT PRIMARY KEY ,
// food_name TEXT NOT NULL,
// food_description TEXT NOT NULL,
// sale_price INTEGER NOT NULL,
// quantity_owned INTEGER NOT NULL, *DB
// happiness_buff REAL NOT NULL,
// hunger_buff REAL NOT NULL,
// energy_buff REAL NOT NULL
typedef FoodIcon = ({
  String name,
  String description,
  int salePrice,
  double happinessBuff,
  double hungerBuff,
  double energybuff,
});

const Map<String, FoodIcon> foods = <String, FoodIcon>{
  // TODO(everyone): Fill in the food information.
};
