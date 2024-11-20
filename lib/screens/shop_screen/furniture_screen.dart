import "package:flutter/material.dart";
import "package:happy_habit_at/providers/furniture.dart";
import "package:happy_habit_at/widgets/furniture_chips.dart";
import "package:scroll_animator/scroll_animator.dart";

class FurnitureScreen extends StatefulWidget {
  FurnitureScreen({super.key});

  @override
  State<FurnitureScreen> createState() => _FurnitureScreenState();
}

class _FurnitureScreenState extends State<FurnitureScreen> {
  late final AnimatedScrollController scrollController =
      AnimatedScrollController(animationFactory: ChromiumImpulse());
  List<Furniture> furnitures = <Furniture>[
    Furniture(
      furnitureName: "Ball",
      furnitureDescription: "Lorem Ipsum",
      furnitureCategory: 1,
      salePrice: 10,
    ),
    Furniture(
      furnitureName: "Bed",
      furnitureDescription: "Lorem Ipsum",
      furnitureCategory: 1,
      salePrice: 10,
    ),
    Furniture(
      furnitureName: "Drawer",
      furnitureDescription: "Lorem Ipsum",
      furnitureCategory: 1,
      salePrice: 10,
    ),
    Furniture(
      furnitureName: "Rock",
      furnitureDescription: "Lorem Ipsum",
      furnitureCategory: 1,
      salePrice: 10,
    ),
    Furniture(
      furnitureName: "Tree",
      furnitureDescription: "Lorem Ipsum",
      furnitureCategory: 1,
      salePrice: 10,
    ),
    Furniture(
      furnitureName: "Test",
      furnitureDescription: "Lorem Ipsum",
      furnitureCategory: 1,
      salePrice: 10,
    ),
    Furniture(
      furnitureName: "Test",
      furnitureDescription: "Lorem Ipsum",
      furnitureCategory: 1,
      salePrice: 10,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FurnitureIcons(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  for (Furniture furniture in furnitures) _furnitureTile(furniture)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _furnitureTile(Furniture furniture) {
    return ListenableBuilder(
      listenable: furniture,
      builder: (BuildContext context, Widget? child) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: ColorScheme.light().primary,
            child: Icon(Icons.chair),
          ),
          title: Text(furniture.furnitureName),
          subtitle: Text(furniture.furnitureDescription),
          onTap: () async {
            await _showModal(furniture);
          },
        );
      },
    );
  }

  Future<void> _showModal(Furniture furniture) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 450,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Broke ahh"),
                        SizedBox(
                          width: 4.0,
                        ),
                        Icon(Icons.circle),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                ColoredBox(
                  color: Colors.black38,
                  child: SizedBox(
                    height: 150,
                    child: Center(
                      child: Icon(Icons.chair),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    furniture.furnitureName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(furniture.furnitureDescription),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "In Inventory:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(furniture.quantityOwned.toString()),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FilledButton(onPressed: () {}, child: Text("Buy for ${furniture.salePrice}")),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
