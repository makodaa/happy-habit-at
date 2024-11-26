import "package:flutter/material.dart" hide Decoration;
import "package:happy_habit_at/constants/decoration_category.dart";
import "package:happy_habit_at/constants/decoration_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/habitat_decoration.dart";
import "package:happy_habit_at/utils/extension_types/ids.dart";
import "package:happy_habit_at/utils/extensions/map_pairs.dart";
import "package:happy_habit_at/utils/extensions/sorted_by.dart";
import "package:happy_habit_at/widgets/currency_display.dart";
import "package:happy_habit_at/widgets/decoration_icons.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";

class DecorationScreen extends StatefulWidget {
  const DecorationScreen({super.key});

  @override
  State<DecorationScreen> createState() => _DecorationScreenState();
}

class _DecorationScreenState extends State<DecorationScreen> {
  late final AnimatedScrollController scrollController =
      AnimatedScrollController(animationFactory: const ChromiumImpulse());
  late final AppState appState = context.read<AppState>();
  late DecorationCategory? selectedCategory = null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DecorationIcons(
          selectedCategory: selectedCategory,
          onCategoryChange: (DecorationCategory? category) => setState(() {
            if (selectedCategory == category) {
              selectedCategory = null;
            } else {
              selectedCategory = category;
            }
          }),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView(
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              children: <(String, Widget)>[
                for (var (DecorationId id, DecorationIcon decoration) in decorationIcons.pairs)
                  if (selectedCategory == null || decoration.category == selectedCategory)
                    (decoration.name, _decorationTile(id, decoration)),
              ]
                  .sortedBy(((String, Widget) a, (String, Widget) b) => a.$1.compareTo(b.$1))
                  .map(((String, Widget) p) => p.$2)
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _decorationTile(DecorationId decorationId, DecorationIcon decoration) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await _showModal(decorationId, decoration);
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
                  child: Center(
                    child: Image.asset(
                      decoration.imagePath,
                      width: decoration.imageDimensions.$1,
                      height: decoration.imageDimensions.$2,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(decoration.name),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showModal(DecorationId decorationId, DecorationIcon decoration) async {
    AnimatedScrollController innerScrollController =
        AnimatedScrollController(animationFactory: const ChromiumImpulse());

    await showModalBottomSheet<void>(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        HabitatDecoration decorationInfo = appState.decorationOf(decorationId);

        return SingleChildScrollView(
          controller: innerScrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: UserCurrencyDisplay(),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const ColoredBox(
                  color: Colors.black38,
                  child: SizedBox(
                    height: 150,
                    child: Center(
                      child: Icon(Icons.chair),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    decoration.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(decoration.description),
                ),
                const SizedBox(height: 16.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "In Inventory:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListenableBuilder(
                    listenable: decorationInfo,
                    builder: (BuildContext context, _) {
                      return Text(decorationInfo.quantityOwned.toString());
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "In Place:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListenableBuilder(
                    listenable: decorationInfo,
                    builder: (_, __) {
                      int placements = appState.placementsOfDecoration(decorationId);

                      return Text(placements.toString());
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ListenableBuilder(
                        listenable: decorationInfo,
                        builder: (_, __) => FilledButton(
                          onPressed: decorationInfo.quantityOwned > 0
                              ? () {
                                  appState.sellDecoration(decorationId);
                                }
                              : null,
                          child: Text("Sell for ${decoration.resalePrice}"),
                        ),
                      ),
                      const SizedBox(width: 18.0),
                      ValueListenableBuilder<int>(
                        valueListenable: appState.currency,
                        builder: (_, int value, __) => FilledButton(
                          onPressed: value >= decoration.salePrice
                              ? () {
                                  appState.buyDecoration(decorationId);
                                }
                              : null,
                          child: Text("Buy for ${decoration.salePrice}"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    innerScrollController.dispose();
  }
}
