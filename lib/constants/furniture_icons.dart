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

import "package:happy_habit_at/providers/furniture.dart";

typedef FurnitureIcon = ({
  String name,
  String description,
  String imagePath,
  int salePrice,
  int resalePrice,
  int happinessBuff,
  int energyBuff,
});

const Map<String, FurnitureIcon> furnitureIcons = <String, FurnitureIcon>{
  "blue_table": (
    name: "Blue Leather Table",
    description: "A Blue Leather Table.",
    imagePath: "assets/furniture/blue_table.png",
    salePrice: 150,
    resalePrice: 250,
    happinessBuff: 100,
    energyBuff: 50,
  ),
  "burgundy_drawer": (
    name: "Burgundy Oak Drawer",
    description: "A glossy burgundy oak drawer.",
    imagePath: "assets/furniture/burgundy_drawer.png",
    salePrice: 100,
    resalePrice: 200,
    happinessBuff: 100,
    energyBuff: 60,
  ),
  "round_glass_table": (
    name: "Round Glass Table",
    description: "A glossy burgundy oak drawer.",
    imagePath: "assets/furniture/round_glass_table.png",
    salePrice: 250,
    resalePrice: 400,
    happinessBuff: 150,
    energyBuff: 60,
  ),
  "black_steel_chair": (
    name: "Black Steel Chair",
    description: "A black steel chair.",
    imagePath: "assets/furniture/black_steel_chair.png",
    salePrice: 75,
    resalePrice: 150,
    happinessBuff: 80,
    energyBuff: 40,
  ),
  "mocha_couch": (
    name: "Mocha Couch",
    description: "a soft, fancy, mocha couch.",
    imagePath: "assets/furniture/mocha_couch.png",
    salePrice: 250,
    resalePrice: 450,
    happinessBuff: 150,
    energyBuff: 100,
  ),
  "mocha_office_chair": (
    name: "Mocha Ergonomic Chair",
    description: "A ergonomic mocha chair.",
    imagePath: "assets/furniture/mocha__office_chair.png",
    salePrice: 250,
    resalePrice: 450,
    happinessBuff: 150,
    energyBuff: 100,
  ),
  "mocha_kitchen_chair": (
    name: "Mocha Kitchen Chair",
    description: "A kitchen mocha chair.",
    imagePath: "assets/furniture/mocha_chair.png",
    salePrice: 250,
    resalePrice: 450,
    happinessBuff: 150,
    energyBuff: 100,
  ),
  "kitchen_stove": (
    name: "Kitchen Stove",
    description: "A steelware kitchen stove.",
    imagePath: "assets/furniture/kitchen_stove.png",
    salePrice: 100,
    resalePrice: 200,
    happinessBuff: 100,
    energyBuff: 100,
  ),
  "melamine_bookshelf": (
    name: "Bookshelf",
    description: "A melamine bookshelf.",
    imagePath: "assets/furniture/melamine_bookshelf.png",
    salePrice: 100,
    resalePrice: 200,
    happinessBuff: 100,
    energyBuff: 100,
  ),
  "kitchen_drawer": (
    name: "Kitchen Drawer",
    description: "A kitchen drawer.",
    imagePath: "assets/furniture/kitchen_drawer.png",
    salePrice: 100,
    resalePrice: 200,
    happinessBuff: 100,
    energyBuff: 100,
  ),

  /// [key: id]: FurnitureIcon.
};
