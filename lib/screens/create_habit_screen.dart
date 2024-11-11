import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  late final TextEditingController habitNameController;
  late final TextEditingController habitDescriptionController;
  late final TextEditingController habitGoalController;

  void _createNewHabit() {}

  @override
  void initState() {
    super.initState();

    habitNameController = TextEditingController();
    habitDescriptionController = TextEditingController();
    habitGoalController = TextEditingController();
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
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.check),
            ),
          ],
        ),

        //BODY
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Icon and Name",
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 4.0,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: IconButton(
                        icon: const Icon(Icons.emoji_emotions),
                        onPressed: () {
                          print("Hi");
                        },
                      ),
                    ),
                    // TODO(water-mizuu):
                    Expanded(
                      child: TextField(
                        controller: habitNameController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                            hintText: "e.g. Meditate, Read a Book"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0,),
                const Text(
                  "Description",
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 4.0,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: habitDescriptionController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                            hintText: "e.g. Clear and organize thoughts"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0,),
                const Text(
                  "Goal",
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 4.0,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: habitGoalController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                            hintText: "e.g. Spend at least 15 minutes"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0,),
                const Text(
                  "Repeats on",
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 4.0,),
                // ToggleButtons(children: children, isSelected: isSelected)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
