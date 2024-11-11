import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  late final TextEditingController habitNameController;

  void _createNewHabit() {}

  @override
  void initState() {
    super.initState();

    habitNameController = TextEditingController();
  }

  @override
  void dispose() {
    habitNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// APPBAR
        AppBar(
          centerTitle: true,
          title: const Text("New Habit"),
          elevation: 1.0,
          shadowColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),

        //BODY
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Icon and Name", textAlign: TextAlign.left),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        print("Hi");
                      },
                    ),
                    // TODO(water-mizuu):
                    Expanded(
                      child: TextField(
                        controller: habitNameController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(hintText: "e.g. Meditate, Read a Book"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
