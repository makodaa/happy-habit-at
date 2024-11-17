import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/enums/days_of_the_week.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";
import "package:provider/provider.dart";

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

typedef ColorPair = ({Color background, Color foreground});

/// TODO(@anyone): Implement the icon picker.
///   Requirements:
///     1. Define a set of usable icons.
///     2. Implement a way to select an icon. (modal?)

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  static final ImmutableList<ColorPair> colors = ImmutableList<ColorPair>(<ColorPair>[
    (background: Colors.red.shade200, foreground: Colors.red.shade400),
    (background: Colors.orange.shade200, foreground: Colors.orange.shade400),
    (background: Colors.yellow.shade200, foreground: Colors.yellow.shade400),
    (background: Colors.green.shade200, foreground: Colors.green.shade400),
    (background: Colors.blue.shade200, foreground: Colors.blue.shade400),
    (background: Colors.indigo.shade200, foreground: Colors.indigo.shade400),
    (background: Colors.purple.shade200, foreground: Colors.purple.shade400),
  ]);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  Future<void> _submitForm() async {
    AppState appState = context.read<AppState>();

    if (_formKey.currentState case FormState state when state.validate()) {
      await appState.createHabit(
        habitName: habitNameController.text,
        habitDescription: habitDescriptionController.text.emptyAsNull,
        habitGoal: habitGoalController.text.emptyAsNull,
        habitIcon: 0,
        daysOfTheWeek: isDaySelected.indexed
            .map(((int, bool) p) => DaysOfTheWeek.values[p.$1]) // Get the corresponding day
            .map((DaysOfTheWeek p) => p.bitValue) // Get the bit value (2^n)
            .fold<int>(0, (int acc, int bit) => acc | bit), // Combine the bit values.
        time: selectedTime,
      );

      if (!context.mounted) {
        return;
      }

      // ignore: use_build_context_synchronously
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Material(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /// APPBAR
            AppBar(
              centerTitle: true,
              title: const Text("New Habit"),
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    _submitForm();
                  },
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
                    _iconAndName(),
                    _fieldSeparator,
                    _description(),
                    _fieldSeparator,
                    _goal(),
                    _fieldSeparator,
                    _repeatsOn(),
                    _fieldSeparator,
                    _time(context),
                    _fieldSeparator,
                    _color(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconAndName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "Icon and Name",
          textAlign: TextAlign.left,
        ),
        _labelSeparator,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide()),
              ),

              /// Arbitarily chosen. Can be changed.
              padding: EdgeInsets.only(top: 7.0),
              child: IconButton(
                icon: Icon(
                  Icons.emoji_emotions,
                  color: colorIndex != null ? colors[colorIndex!].foreground : Colors.black54,
                ),
                onPressed: () {
                  print("Hi");
                },
              ),
            ),
            Expanded(
              child: TextFormField(
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a habit name.";
                  }
                  return null;
                },
                controller: habitNameController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: "e.g. Meditate, Read a Book",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "Description (Optional)",
          textAlign: TextAlign.left,
        ),
        _labelSeparator,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: habitDescriptionController,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: "e.g. Clear and organize thoughts",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _goal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "Goal (Optional)",
          textAlign: TextAlign.left,
        ),
        _labelSeparator,
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
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _repeatsOn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
            children: <Widget>[
              for (DaysOfTheWeek day in DaysOfTheWeek.values) //
                Text(day.shortName),
            ],
          ),
        ),
      ],
    );
  }

  Widget _time(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "Time",
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 4,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: selectedTime?.format(context) ?? "Select a time",
          ),
          onTap: () async {
            _unfocus();
            TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: selectedTime ??
                  TimeOfDay(
                    hour: (TimeOfDay.now().hour + 1) % 24,
                    minute: 0,
                  ),
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

            _unfocus();
            setState(() {
              selectedTime = time;
            });
          },
        ),
      ],
    );
  }

  Widget _color() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "Color",
          textAlign: TextAlign.left,
        ),
        _labelSeparator,
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: <Widget>[
              for (int i = 0; i < colors.length; ++i)
                // A dirty way of declaring variables inside a collection.
                if (colors[i] case (:Color background, :Color foreground)) ...<Widget>[
                  if (i > 0) _colorSeparator,
                  _colorButton(i, background, foreground),
                ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _colorButton(int i, Color background, Color foreground) {
    return InkWell(
      onTap: () => setState(() {
        colorIndex = i;
      }),
      child: Ink(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Icon(
            Icons.check,
            color: i == colorIndex ? foreground : Colors.transparent,
          ),
        ),
      ),
    );
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  static const SizedBox _fieldSeparator = SizedBox(height: 16.0);
  static const SizedBox _labelSeparator = SizedBox(height: 4.0);
  static const SizedBox _colorSeparator = SizedBox(width: 4.0);
}

extension on String {
  String? get emptyAsNull => isEmpty ? null : this;
}
