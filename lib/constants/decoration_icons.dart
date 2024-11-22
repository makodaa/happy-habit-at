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

import "package:happy_habit_at/constants/decoration_category.dart";
import "package:happy_habit_at/structs/display_offset.dart";

typedef DecorationIcon = ({
  String name,
  String description,
  String imagePath,
  int salePrice,
  int resalePrice,
  int happinessBuff,
  int energyBuff,
  bool isFacingLeft,

  // Technical values
  (double width, double height) imageDimensions ,
  DecorationCategory category,
  DisplayOffset displayOffset,
});

const Map<String, DecorationIcon> decorationIcons = <String, DecorationIcon>{
  "blue_table": (
    name: "Blue Leather Table",
    description: "A Blue Leather Table.",
    imagePath: "assets/images/furniture/blue_table.png",
    salePrice: 150,
    resalePrice: 250,
    happinessBuff: 100,
    energyBuff: 50,
    isFacingLeft: false,
    imageDimensions : (42.0, 42.0),
    category: DecorationCategory.smallDecoration,
    displayOffset: DisplayOffset(
      defaultOffset: (6, -5),
      flippedOffset: (3, -5),
      baseOffset: (0, 0),
    ),
  ),
  "burgundy_drawer": (
    name: "Burgundy Oak Drawer",
    description: "A glossy burgundy oak drawer.",
    imagePath: "assets/images/furniture/burgundy_drawer.png",
    salePrice: 100,
    resalePrice: 200,
    happinessBuff: 100,
    energyBuff: 60,
    isFacingLeft: false,
    imageDimensions : (42.0, 48.0),
    category: DecorationCategory.smallDecoration,
    displayOffset: DisplayOffset(
      defaultOffset: (3, -11),
      flippedOffset: (3, -11),
      baseOffset: (0, 0),
    ),
  ),
//   "round_glass_table": (
//     name: "Round Glass Table",
//     description: "A glossy burgundy oak drawer.",
//     imagePath: "assets/images/furniture/round_glass_table.png",
//     salePrice: 250,
//     resalePrice: 400,
//     happinessBuff: 150,
//     energyBuff: 60,
//     isFacingLeft: false,
//   ),
//   "black_steel_chair": (
//     name: "Black Steel Chair",
//     description: "A black steel chair.",
//     imagePath: "assets/images/furniture/black_steel_chair.png",
//     salePrice: 75,
//     resalePrice: 150,
//     happinessBuff: 80,
//     energyBuff: 40,
//     isFacingLeft: false,
//   ),
//   "mocha_couch": (
//     name: "Mocha Couch",
//     description: "a soft, fancy, mocha couch.",
//     imagePath: "assets/images/furniture/mocha_couch.png",
//     salePrice: 250,
//     resalePrice: 450,
//     happinessBuff: 150,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "mocha_office_chair": (
//     name: "Mocha Ergonomic Chair",
//     description: "A ergonomic mocha chair.",
//     imagePath: "assets/images/furniture/mocha_office_chair.png",
//     salePrice: 250,
//     resalePrice: 450,
//     happinessBuff: 150,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "mocha_kitchen_chair": (
//     name: "Mocha Kitchen Chair",
//     description: "A kitchen mocha chair.",
//     imagePath: "assets/images/furniture/mocha_kitchen_chair.png",
//     salePrice: 250,
//     resalePrice: 450,
//     happinessBuff: 150,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "kitchen_stove": (
//     name: "Kitchen Stove",
//     description: "A steelware kitchen stove.",
//     imagePath: "assets/images/furniture/kitchen_stove.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "melamine_bookshelf": (
//     name: "Bookshelf",
//     description: "A melamine bookshelf.",
//     imagePath: "assets/images/furniture/melamine_bookshelf.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: true,
//   ),
//   "kitchen_drawer": (
//     name: "Kitchen Drawer",
//     description: "A kitchen drawer.",
//     imagePath: "assets/images/furniture/kitchen_drawer.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   // nature decorations
//   //yellow autumn tree classifications
  "bigytree1": (
    name: "Tall Autumn Tree",
    description: "A stripped tall autumn tree.",
    imagePath: "assets/images/trees/bigytree1.png",
    salePrice: 100,
    resalePrice: 200,
    happinessBuff: 100,
    energyBuff: 100,
    isFacingLeft: false,
    imageDimensions : (64.0, 92.0),
    category: DecorationCategory.smallDecoration,
    displayOffset: DisplayOffset(
      defaultOffset: (-8, -36),
      flippedOffset: (-8, -36),
      baseOffset: (-1, -1),
    ),
  ),
//   "bigytree2": (
//     name: "Big Autumn Tree",
//     description: "A Full autumn tree.",
//     imagePath: "assets/images/trees/bigytree2.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bigytree3": (
//     name: "Round Short Autumn Tree",
//     description: "A short rounded autumn tree.",
//     imagePath: "assets/images/trees/bigytree3.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bigytree4": (
//     name: "Tall Coned Autumn Tree",
//     description: "A Tall coned autumn tree.",
//     imagePath: "assets/images/trees/bigytree4.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bigytree5": (
//     name: "Tall Coned Autumn Tree",
//     description: "A tall rounded autumn tree.",
//     imagePath: "assets/images/trees/bigytree5.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bigytree6": (
//     name: "Tall Rounded Yellow Tree",
//     description: "A tall rounded yellow tree.",
//     imagePath: "assets/images/trees/bigytree6.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bigytree7": (
//     name: "Big Rounded Yellow Tree",
//     description: "A big crounded yellow tree.",
//     imagePath: "assets/images/trees/bigytree7.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bigytree8": (
//     name: "Single Rounded Yellow Tree",
//     description: "A single rounded yellow tree.",
//     imagePath: "assets/images/trees/bigytree8.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   //bushes
//   "bush1": (
//     name: "Upper Arrowed Bush",
//     description: "A upper arrowed green bush.",
//     imagePath: "assets/images/bush/bush1.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bush2": (
//     name: "Left Arrowed Bush",
//     description: "A left arrowed green bush.",
//     imagePath: "assets/images/bush/bush2.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bush3": (
//     name: "Right Arrowed Bush",
//     description: "A right arrowed green bush.",
//     imagePath: "assets/images/bush/bush3.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bush4": (
//     name: "Down Arrowed Bush",
//     description: "A down arrowed green bush.",
//     imagePath: "assets/images/bush/bush4.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bush5": (
//     name: "Left Facing Bush",
//     description: "A left faced green bush.",
//     imagePath: "assets/images/bush/bush5.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bush6": (
//     name: "Single Pillar Bush",
//     description: "A single pillared green bush.",
//     imagePath: "assets/images/bush/bush6.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "bush7": (
//     name: "Right Pillar Bush",
//     description: "A right faced green bush.",
//     imagePath: "assets/images/bush/bush7.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   //yellow bushes
//   "ybush1": (
//     name: "Upper Arrowed Yellow Bush",
//     description: "A upper arrowed yellow bush.",
//     imagePath: "assets/images/bush/ybush1.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ybush2": (
//     name: "Left Arrowed Yellow Bush",
//     description: "A left arrowed yelliw bush.",
//     imagePath: "assets/images/bush/ybush2.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ybush3": (
//     name: "Right Arrowed Yellow Bush",
//     description: "A right arrowed green bush.",
//     imagePath: "assets/images/bush/ybush3.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ybush4": (
//     name: "Down Arrowed Yellow Bush",
//     description: "A down arrowed yellow bush.",
//     imagePath: "assets/images/bush/ybush4.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ybush5": (
//     name: "Left Facing Yellow Bush",
//     description: "A left faced yellow bush.",
//     imagePath: "assets/images/bush/ybush5.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ybush6": (
//     name: "Single Pillar Yellow Bush",
//     description: "A single pillared yellow bush.",
//     imagePath: "assets/images/bush/ybush6.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ybush7": (
//     name: "Right Facing Yellow Bush",
//     description: "A right faced yellow bush.",
//     imagePath: "assets/images/bush/bush7.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   // yellow trees
//   "ytree": (
//     name: "Short Boxed Yellow Tree",
//     description: "A short boxed yellow tree.",
//     imagePath: "assets/images/trees/ytree.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ytree1": (
//     name: "Tall Rounded Yellow Tree",
//     description: "A tall skinny coned yellow tree.",
//     imagePath: "assets/images/trees/ytree1.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ytree2": (
//     name: "Tall Hickory Yellow Tree",
//     description: "A tall hickory yellow tree.",
//     imagePath: "assets/images/trees/ytree2.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ytree3": (
//     name: "Tall Fir Yellow Tree",
//     description: "A tall fir yellow tree.",
//     imagePath: "assets/images/trees/ytree3.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ytree4": (
//     name: "Short Pine Yellow Tree",
//     description: "A short pine yellow tree.",
//     imagePath: "assets/images/trees/ytree4.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ytree5": (
//     name: "Short cylinderical Yellow Tree",
//     description: "A short cylindrical yellow tree.",
//     imagePath: "assets/images/trees/ytree5.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ytree6": (
//     name: "Short Columnar Yellow Tree",
//     description: "A short columnar yellow tree.",
//     imagePath: "assets/images/trees/ytree6.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ytree7": (
//     name: "Short Elm Yellow Tree",
//     description: "A short elm yellow tree.",
//     imagePath: "assets/images/trees/ytree7.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ytree8": (
//     name: "Short Pine Boxed Yellow Tree",
//     description: "A short pine boxed yellow tree.",
//     imagePath: "assets/images/trees/ytree8.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ytree9": (
//     name: "Tall Spruce Yellow Tree",
//     description: "A tall spruced yellow tree.",
//     imagePath: "assets/images/trees/ytree9.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   //ntree
//   "ntree1": (
//     name: "Short Boxed Lime Tree",
//     description: "A short boxed lime tree.",
//     imagePath: "assets/images/trees/ntree1.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ntree2": (
//     name: "Short Spruce Lime Tree",
//     description: "A short spruced lime tree.",
//     imagePath: "assets/images/trees/ntree2.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ntree3": (
//     name: "Short Pine Lime Tree",
//     description: "A short pine lime tree.",
//     imagePath: "assets/images/trees/ntree3.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ntree4": (
//     name: "Medium Boxed Lime Tree",
//     description: "A medium boxed lime tree.",
//     imagePath: "assets/images/trees/ntree4.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ntree5": (
//     name: "Medium Pine Lime Tree",
//     description: "A mediume pined lime tree.",
//     imagePath: "assets/images/trees/ntree2.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ntree6": (
//     name: "Tall Boxed Lime Tree",
//     description: "A tall boxed lime tree.",
//     imagePath: "assets/images/trees/ntree6.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ntree7": (
//     name: "Tall Rounded Lime Tree",
//     description: "A  tall rounded lime tree.",
//     imagePath: "assets/images/trees/ntree7.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "ntree8": (
//     name: "Short Pyramidal Lime Tree",
//     description: "A short pyramidal lime tree.",
//     imagePath: "assets/images/trees/ntree8.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   //greentrees
//   "talltree": (
//     name: "Tall Green Tree",
//     description: "A tall coned green tree.",
//     imagePath: "assets/images/trees/talltree.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "tree1": (
//     name: "Short Boxed Green Tree",
//     description: "A short boxed green tree.",
//     imagePath: "assets/images/trees/tree1.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
  "tree2": (
    name: "Tall Rounded Spruce Tree",
    description: "A tall spruce tree.",
    imagePath: "assets/images/trees/tree2.png",
    salePrice: 100,
    resalePrice: 200,
    happinessBuff: 100,
    energyBuff: 100,
    isFacingLeft: false,
    imageDimensions : (64.0, 96.0),
    category: DecorationCategory.smallDecoration,
    displayOffset: DisplayOffset(
      defaultOffset: (-8, -12),
      flippedOffset: (0, 0),
      baseOffset: (-2, -2),
    ),
  ),
//   "tree3": (
//     name: "Short Pine Tree",
//     description: "A short pine tree.",
//     imagePath: "assets/images/trees/tree3.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "tree4": (
//     name: "Palm Tree",
//     description: "A Palm tree.",
//     imagePath: "assets/images/trees/tree4.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "tree5": (
//     name: "Tall Palm Tree",
//     description: "A medium-boxed tree.",
//     imagePath: "assets/images/trees/tree5.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "tree6": (
//     name: "Short Box Coned Yellow Tree",
//     description: "A short box coned tree.",
//     imagePath: "assets/images/trees/ytree6.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "tree7": (
//     name: "Short Pine Yellow Tree",
//     description: "A short pine tree.",
//     imagePath: "assets/images/trees/ytree7.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "tree8": (
//     name: "Tall Rounded Tree",
//     description: "A Tall rounded yellow tree.",
//     imagePath: "assets/images/trees/ytree8.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "tree9": (
//     name: "Big Rounded Tree",
//     description: "A big rounded tree.",
//     imagePath: "assets/images/trees/ytree9.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "tree10": (
//     name: "Short Rounded Tree",
//     description: "A short rounded tree.",
//     imagePath: "assets/images/trees/tree10.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   // "tree11": (
//   //   name: "Tall Yellow Green Tree",
//   //   description: "A tall yellow green tree.",
//   //   imagePath: "assets/images/trees/ytree11.png",
//   //   salePrice: 100,
//   //   resalePrice: 200,
//   //   happinessBuff: 100,
//   //   energyBuff: 100,
//   //   isFacingLeft: false,
//   // ),
//   // "tree12": (
//   //   name: "Tall Hemlock Tree",
//   //   description: "A tall hemlock tree.",
//   //   imagePath: "assets/images/trees/ytree12.png",
//   //   salePrice: 100,
//   //   resalePrice: 200,
//   //   happinessBuff: 100,
//   //   energyBuff: 100,
//   //   isFacingLeft: false,
//   // ),
// //extras
//   "butterfly": (
//     name: "Butterflies",
//     description: "A beautiful set of butterflies.",
//     imagePath: "assets/images/extras/butterfly.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "chair": (
//     name: "Camping Chair",
//     description: "A camping chair.",
//     imagePath: "assets/images/extras/chair.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "cooking": (
//     name: "Cooking Pot",
//     description: "A cooking pot.",
//     imagePath: "assets/images/extras/cooking.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "idkmb": (
//     name: "Map",
//     description: "An explorer map.",
//     imagePath: "assets/images/extras/idkmb.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),

//   "sign": (
//     name: "Sign",
//     description: "A sign.",
//     imagePath: "assets/images/extras/sign.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),
//   "tent": (
//     name: "Tent",
//     description: "A cozy tent to stay.",
//     imagePath: "assets/images/extras/tent.png",
//     salePrice: 100,
//     resalePrice: 200,
//     happinessBuff: 100,
//     energyBuff: 100,
//     isFacingLeft: false,
//   ),

  /// [key: id]: FurnitureIcon.
};
