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
  String imagePath,
  int salePrice,
  double happinessBuff,
  double hungerBuff,
  double energybuff,
});

const Map<String, FoodIcon> foodIcons = <String, FoodIcon>{
  "food_bundle": (
    name: "Food Bundle",
    description: "A Heavy amount of food in a bundle.",
    imagePath: "assets/images/foods/food_bundle.png",
    salePrice: 15,
    happinessBuff: 15,
    hungerBuff: 15,
    energybuff: 15,
  ),
  "food_bag": (
    name: "Food Bag",
    description: "A large bag of food.",
    imagePath: "assets/images/foods/food_bag.png",
    salePrice: 10,
    happinessBuff: 10,
    hungerBuff: 10,
    energybuff: 10,
  ),
  "small_bowl": (
    name: "Small Bowl",
    description: "A small amount of food in the bowl.",
    imagePath: "assets/images/foods/small_bowl.png",
    salePrice: 3,
    happinessBuff: 3,
    hungerBuff: 3,
    energybuff: 3,
  ),
  "full_bowl": (
    name: "Food Bundle",
    description: "A full amount of food in the bowl.",
    imagePath: "assets/images/foods/full_bowl.png",
    salePrice: 5,
    happinessBuff: 5,
    hungerBuff: 5,
    energybuff: 5,
  ),
  "pet_pack": (
    name: "Pet Pack",
    description: "A pack of food for your pet.",
    imagePath: "assets/images/foods/pet_pack.png",
    salePrice: 7,
    happinessBuff: 7,
    hungerBuff: 7,
    energybuff: 7,
  ),
};
