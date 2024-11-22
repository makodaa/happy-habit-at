import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/constants/habit_colors.dart";
import "package:happy_habit_at/constants/habit_icons.dart";
import "package:happy_habit_at/enums/days_of_the_week.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/widgets/icon_dialog.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";

class ModifyHabitScreen extends StatefulWidget {
  const ModifyHabitScreen({required this.habitId, super.key});

  final int habitId;

  @override
  State<ModifyHabitScreen> createState() => _ModifyHabitScreenState();
}

class _ModifyHabitScreenState extends State<ModifyHabitScreen> {
  // Private constants
  static const TextDirection textDirection = TextDirection.ltr;
  static const MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;

  // Inherited state from widget.
  late Habit habit;

  // Immutable state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final AnimatedScrollController scrollController;
  late final TextEditingController habitNameController;
  late final TextEditingController habitDescriptionController;
  late final TextEditingController habitGoalController;

  late TimeOfDay? selectedTime;
  late int? colorIndex;
  late int iconIndex;
  late final List<bool> isDaySelected;

  @override
  void initState() {
    super.initState();

    habit = context.read<AppState>().habitOfId(widget.habitId);

    scrollController = AnimatedScrollController(animationFactory: ChromiumImpulse());
    habitNameController = TextEditingController()..text = habit.name;
    habitDescriptionController = TextEditingController()..text = habit.description ?? "";
    habitGoalController = TextEditingController()..text = habit.goal ?? "";

    selectedTime = habit.time;
    colorIndex = habit.colorIndex;
    iconIndex = habit.icon;
    isDaySelected = <bool>[
      for (int i = 0; i < 7; ++i) //
        habit.daysOfTheWeek.contains(DaysOfTheWeek.values[i]),
    ];
  }

  /// Called whenever the widget [ModifyHabitScreen] is updated.
  @override
  void didUpdateWidget(ModifyHabitScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.habitId != oldWidget.habitId) {
      habit = context.read<AppState>().habitOfId(widget.habitId);

      habitNameController.text = habit.name;
      habitDescriptionController.text = habit.description ?? "";
      habitGoalController.text = habit.goal ?? "";

      selectedTime = habit.time;
      colorIndex = habit.colorIndex;

      for (int i = 0; i < 7; ++i) {
        isDaySelected[i] = habit.daysOfTheWeek.contains(DaysOfTheWeek.values[i]);
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    habitNameController.dispose();
    habitDescriptionController.dispose();
    habitGoalController.dispose();

    super.dispose();
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
            _appBar(context),

            //BODY
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
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
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text("Edit Habit"),
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () async {
            await context.read<AppState>().deleteHabit(habitId: habit.id);

            /// Since we are in the habit screen, we just pop the screen.
            if (context.mounted) {
              context.pop();
            }
          },
          icon: const Icon(Icons.delete),
        ),
        IconButton(
          onPressed: () async {
            await _submitForm(context);
          },
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }

  Widget _iconAndName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text("Icon and Name"),
        _labelSeparator,
        Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide()),
              ),

              /// Arbitarily chosen. Can be changed.
              padding: Platform.isAndroid ? null : EdgeInsets.only(top: 7.0),
              child: IconButton(
                icon: Icon(
                  habitIcons[iconIndex],
                  color: colorIndex != null ? habitColors[colorIndex!].foreground : Colors.black54,
                ),
                onPressed: () => unawaited(
                  showIconDialog(
                    context: context,
                    color: colorIndex != null //
                        ? habitColors[colorIndex!].foreground
                        : Colors.black54,
                    onSelect: (BuildContext context, int i) {
                      setState(() {
                        iconIndex = i;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
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
                  contentPadding: EdgeInsets.only(bottom: 2.0),
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
              child: TextFormField(
                controller: habitGoalController,
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
        TextFormField(
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
                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
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
              for (int i = 0; i < habitColors.length; ++i)
                // A dirty way of declaring variables inside a collection.
                if (habitColors[i] case (:Color background, :Color foreground)) ...<Widget>[
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

  Future<void> _submitForm(BuildContext context) async {
    AppState appState = context.read<AppState>();

    if (_formKey.currentState case FormState state when state.validate()) {
      await appState.updateHabit(
        id: habit.id,
        name: habitNameController.text,
        description: habitDescriptionController.text.emptyAsNull,
        goal: habitGoalController.text.emptyAsNull,
        icon: iconIndex,
        daysOfTheWeek: DaysOfTheWeek.bitValuesFromBooleans(isDaySelected),
        time: selectedTime,
        colorIndex: colorIndex,
      );

      if (context.mounted) {
        context.pop();
      }
    }
  }

  static const SizedBox _fieldSeparator = SizedBox(height: 16.0);
  static const SizedBox _labelSeparator = SizedBox(height: 4.0);
  static const SizedBox _colorSeparator = SizedBox(width: 4.0);
}

extension on String {
  String? get emptyAsNull => isEmpty ? null : this;
}
