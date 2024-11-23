import "package:flutter/material.dart";
import "package:happy_habit_at/constants/food_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/utils/extensions/map_pairs.dart";
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

  @override
  void initState() {
    super.initState();

    scrollController = AnimatedScrollController(animationFactory: const ChromiumImpulse());
    appState = context.read<AppState>();
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView(
            controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              children: <Widget>[
                for (var (String key, FoodIcon food) in foodIcons.pairs) //
                  _foodTile(key, food),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _foodTile(String id, FoodIcon food) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await _showModal(id, food);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    food.imagePath,
                    width: 48.0,
                    height: 48.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(food.name),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showModal(String id, FoodIcon food) async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  food.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(food.description),
                const SizedBox(height: 16.0),
                const Text(
                  "In Inventory:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text("${appState.quantityOfFood(id)!}"),
                const SizedBox(height: 16.0),
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
