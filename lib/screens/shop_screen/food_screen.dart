import "package:flutter/material.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/food.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  late final AnimatedScrollController scrollController;
  late final AppState appState;
  bool hasInitialized = false;

  @override
  void initState() {
    super.initState();

    scrollController = AnimatedScrollController(animationFactory: ChromiumImpulse());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!hasInitialized) {
      appState = context.read<AppState>();

      hasInitialized = true;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  List<Food> foods = <Food>[
    Food(
      foodName: "Kibble Pack",
      foodDescription: "Restores some food points",
      salePrice: 1,
      hungerPoints: 3,
      happinessPoints: 1,
    ),
    Food(
      foodName: "Kibble Bowl",
      foodDescription: "Restores more food points",
      salePrice: 5,
      hungerPoints: 5,
      happinessPoints: 5,
    ),
    Food(
      foodName: "Kibble Bag",
      foodDescription: "Restores a lot of food points",
      salePrice: 10,
      hungerPoints: 10,
      happinessPoints: 5,
    ),
    Food(
      foodName: "Treat",
      foodDescription: "Increases happiness and some food points",
      salePrice: 3,
      hungerPoints: 1,
      happinessPoints: 10,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  for (Food food in foods) _foodTile(food),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _foodTile(Food food) {
    return ListenableBuilder(
      listenable: food,
      builder: (BuildContext context, Widget? child) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: ColorScheme.light().primary,
            child: Icon(Icons.chair),
          ),
          title: Text(food.foodName),
          subtitle: Text(food.foodDescription),
          onTap: () async {
            await _showModal(food);
          },
        );
      },
    );
  }

  Future<void> _showModal(Food food) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  food.foodName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(food.foodDescription),
                SizedBox(height: 16.0),
                Text(
                  "In Inventory:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text("${food.quantityOwned ?? 0}"),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FilledButton(onPressed: () {}, child: Text("Buy for ${food.salePrice}")),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
