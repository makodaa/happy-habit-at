import "package:flutter/material.dart" hide Decoration;
import "package:happy_habit_at/constants/decoration_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/utils/extensions/map_pairs.dart";
import "package:happy_habit_at/widgets/decoration_icons.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";

class DecorationScreen extends StatefulWidget {
  DecorationScreen({super.key});

  @override
  State<DecorationScreen> createState() => _DecorationScreenState();
}

class _DecorationScreenState extends State<DecorationScreen> {
  late final AnimatedScrollController scrollController =
      AnimatedScrollController(animationFactory: ChromiumImpulse());

  late final AppState appState = context.read<AppState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DecorationIcons(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
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
        backgroundColor: ColorScheme.light().primary,
        child: Icon(Icons.chair),
      ),
      title: Text(decoration.name),
      subtitle: Text(decoration.description),
      onTap: () async {
        await _showModal(decorationId, decoration);
      },
    );
  }

  Future<void> _showModal(String decorationId, DecorationIcon decoration) async {
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
                        ValueListenableBuilder<int>(
                          valueListenable: appState.currency,
                          builder: (BuildContext context, int currency, Widget? child) {
                            return Text(
                              "Currency: $currency",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
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
                    decoration.name,
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
                  child: Text(decoration.description),
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
                  child: Text(appState.quantityOf(decorationId).toString()),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FilledButton(
                        onPressed: () {},
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
  }
}
