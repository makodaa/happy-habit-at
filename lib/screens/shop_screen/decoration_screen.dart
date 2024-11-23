import "package:flutter/material.dart" hide Decoration;
import "package:happy_habit_at/constants/decoration_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/habitat_decoration.dart";
import "package:happy_habit_at/utils/extensions/map_pairs.dart";
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DecorationIcons(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  for (var (String id, DecorationIcon decoration) in decorationIcons.pairs)
                    _decorationTile(id, decoration),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _decorationTile(String decorationId, DecorationIcon decoration) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const ColorScheme.light().primary,
        child: const Icon(Icons.chair),
      ),
      title: Text(decoration.name),
      subtitle: Text(decoration.description),
      onTap: () async {
        await _showModal(decorationId, decoration);
      },
    );
  }

  Future<void> _showModal(String decorationId, DecorationIcon decoration) async {
    AnimatedScrollController innerScrollController =
        AnimatedScrollController(animationFactory: const ChromiumImpulse());

    await showModalBottomSheet<void>(
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
                    child: CurrencyDisplay(),
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
                    builder: (BuildContext context, _) {
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
                      FilledButton(
                        onPressed: () {
                          appState.sellDecoration(decorationId);
                        },
                        child: Text("Sell for ${decoration.resalePrice}"),
                      ),
                      FilledButton(
                        onPressed: () {
                          appState.buyDecoration(decorationId);
                        },
                        child: Text("Buy for ${decoration.salePrice}"),
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
