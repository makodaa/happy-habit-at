import "package:flutter/foundation.dart";

class Food extends ChangeNotifier {
  Food({
    required this.foodName,
    required this.foodDescription,
    required this.salePrice,
    required this.hungerPoints,
    required this.happinessPoints,
    this.quantityOwned,
  });
  late final int foodId;
  late String foodName;
  late String foodDescription;
  late int salePrice;
  late int hungerPoints;
  late int happinessPoints;
  int? quantityOwned;
}
