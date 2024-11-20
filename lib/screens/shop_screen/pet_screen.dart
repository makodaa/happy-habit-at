import "package:flutter/material.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  static const SizedBox _fieldSeparator = SizedBox(height: 16.0);
  static const SizedBox _rowSeparator = SizedBox(width: 4.0);

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ValueListenableBuilder<int>(
                  valueListenable: appState.currency,
                  builder: (BuildContext context, int value, Widget? child) {
                    NumberFormat formatter = NumberFormat("#,##0", "en_US");
                
                    return Text(formatter.format(value));
                  },
                ),
                _rowSeparator,
                Icon(Icons.circle),
              ],
            ),
            _fieldSeparator,
            Text("Expand Habitat"),
            _fieldSeparator,
            Center(
              child: Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.green.shade800,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.catching_pokemon,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "Pet Gachapon",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      _fieldSeparator,
                      Text("Increase habitat size from mxm to nxn"),
                      _fieldSeparator,
                      FilledButton(
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                          child: Text("Insert price"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
