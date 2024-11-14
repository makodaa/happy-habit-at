import "package:flutter/foundation.dart";

class Furniture extends ChangeNotifier {
  Furniture({
    required this.furnitureName,
    required this.furnitureDescription,
    required this.salePrice,
  });
  late final int furnitureId;
  late String furnitureName;
  late String furnitureDescription;
  late int salePrice;
  late int resalePrice;
  late int quantityOwned;
  late int happinessBuff;
  late int energyBuff;
  late List<List<int>> coordinates;
}
