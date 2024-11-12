import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";

enum DaysOfTheWeek {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday
}

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

typedef ColorPair = ({Color background, Color foreground});

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  static final ImmutableList<ColorPair> colors =
      ImmutableList<ColorPair>(<ColorPair>[
    (background: Colors.red.shade200, foreground: Colors.red.shade400),
    (background: Colors.orange.shade200, foreground: Colors.orange.shade400),
    (background: Colors.yellow.shade200, foreground: Colors.yellow.shade400),
    (background: Colors.green.shade200, foreground: Colors.green.shade400),
    (background: Colors.blue.shade200, foreground: Colors.blue.shade400),
    (background: Colors.indigo.shade200, foreground: Colors.indigo.shade400),
    (background: Colors.purple.shade200, foreground: Colors.purple.shade400),
  ]);

  late final TextEditingController habitNameController;
  late final TextEditingController habitDescriptionController;
  late final TextEditingController habitGoalController;

  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  int? colorIndex;

  List<bool> isDaySelected = List<bool>.filled(7, false);
  List<(DaysOfTheWeek, String)> daysOfTheWeekOptions =
      <(DaysOfTheWeek, String)>[
    (DaysOfTheWeek.sunday, "Su"),
    (DaysOfTheWeek.monday, "Mo"),
    (DaysOfTheWeek.tuesday, "Tu"),
    (DaysOfTheWeek.wednesday, "We"),
    (DaysOfTheWeek.thursday, "Th"),
    (DaysOfTheWeek.friday, "Fr"),
    (DaysOfTheWeek.saturday, "Sa"),
  ];

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
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: colorIndex != null
                              ? colors[colorIndex!].foreground
                              : Colors.black54,
                        ),
                        onPressed: () {
                          print("Hi");
                        },
                      ),
                    ),
                    Container(
                      height: 48.0,
                      width: 4.0,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                    ),
                    // TODO(water-mizuu):
                    Expanded(
                      child: TextField(
                        controller: habitNameController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: "e.g. Meditate, Read a Book",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Description",
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: habitDescriptionController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: "e.g. Clear and organize thoughts",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Goal",
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: habitGoalController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: "e.g. Spend at least 15 minutes",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Repeats on",
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4.0),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ToggleButtons(
                    isSelected: isDaySelected,
                    onPressed: (int index) {
                      setState(() {
                        isDaySelected[index] = !isDaySelected[index];
                      });
                    },
                    children: daysOfTheWeekOptions
                        .map(((DaysOfTheWeek, String) day) => Text(day.$2))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                const Text(
                  "Time",
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 4,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: selectedTime?.format(context) ??
                        TimeOfDay(
                                hour: (TimeOfDay.now().hour + 1) % 24,
                                minute: 0)
                            .format(context),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime ??
                          TimeOfDay(
                              hour: (TimeOfDay.now().hour + 1) % 24, minute: 0),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            materialTapTargetSize: tapTargetSize,
                          ),
                          child: Directionality(
                            textDirection: textDirection,
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                alwaysUse24HourFormat: use24HourTime,
                              ),
                              child: child!,
                            ),
                          ),
                        );
                      },
                    );
                    setState(() {
                      selectedTime = time;
                    });
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                const Text(
                  "Color",
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 4.0),
                // TODO: Make reusable? and make onPressed correspond to database value
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: <Widget>[
                      for (var (
                            int index,
                            (:Color background, :Color foreground)
                          ) in colors.indexed)
                        SizedBox(
                          height: 48,
                          width: 48,
                          child: FilledButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(background),
                            ),
                            onPressed: () {
                              setState(() {
                                colorIndex = index;
                              });
                            },
                            child: SizedBox(
                              height: 48.0,
                              width: 48.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
