import "package:flutter/material.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";

class ExpansionScreen extends StatefulWidget {
  const ExpansionScreen({super.key});

  @override
  State<ExpansionScreen> createState() => _ExpansionScreenState();
}

class _ExpansionScreenState extends State<ExpansionScreen> {
  late final AnimatedScrollController scrollController;
  late final AppState appState;
  bool hasInitialized = false;

  @override
  void initState() {
    super.initState();

    scrollController = AnimatedScrollController(animationFactory: const ChromiumImpulse());
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
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                const Icon(Icons.circle),
              ],
            ),
            _fieldSeparator,
            const Text("Expand Habitat"),
            _fieldSeparator,
            Center(
              child: Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      const Icon(Icons.zoom_out_map),
                      const Text(
                        "Expand Habitat",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      _fieldSeparator,
                      const Text("Increase habitat size from mxm to nxn"),
                      _fieldSeparator,
                      FilledButton(
                        onPressed: () {},
                        child: const Padding(
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

  static const SizedBox _fieldSeparator = SizedBox(height: 16.0);
  static const SizedBox _rowSeparator = SizedBox(width: 4.0);
}
