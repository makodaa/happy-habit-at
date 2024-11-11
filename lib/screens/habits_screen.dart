import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/router.dart";

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
            Expanded(
              child: Column(
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                  // Row(
                  //   children: <Widget>[
                  //     Container(
                  //       width: 16.0,
                  //       height: 16.0,
                  //       decoration: BoxDecoration(
                  //         color: Colors.green,
                  //         shape: BoxShape.circle,
                  //       ),
                  //     ),

                  //   ],
                  // ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                  const Row(),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 12.0,
          right: 12.0,
          child: FloatingActionButton.large(
            onPressed: () => context.goNamed("createHabit"),
            child: const Icon(Icons.add),
          ),
        )
      ]
      ],
    );
  }
}
