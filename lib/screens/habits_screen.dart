import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /// APPBAR
            AppBar(
              title: const Text("Today"),
              elevation: 1.0,
              shadowColor: Colors.black,
            ),

            /// BODY
            const Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Past Due",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text(
                      "Overdue Task Title",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      "Overdue Task Subtitle",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 12.0,
          right: 12.0,
          child: FloatingActionButton(
            onPressed: () => context.goNamed("createHabit"),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
