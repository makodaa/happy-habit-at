import "package:flutter/material.dart";
import "package:happy_habit_at/constants/furniture_categories.dart";
import "package:happy_habit_at/constants/habit_icons.dart";

Future<void> showIconDialog({
  required BuildContext context,
  required Color color,
  required void Function(BuildContext context, int index) onSelect,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Choose an Icon"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[_iconList(context, onSelect, color)],
          ),
        ),
      );
    },
  );
}

Widget _iconList(
  BuildContext context,
  void Function(BuildContext context, int index) onSelect,
  Color color,
) {
  return Wrap(
    alignment: WrapAlignment.spaceEvenly,
    children: <Widget>[
      for (int i = 0; i < furnitureCategories.length; ++i) //
        _iconButton(i, context, onSelect, color),
    ],
  );
}

Widget _iconButton(
  int i,
  BuildContext context,
  void Function(BuildContext context, int index) onSelect,
  Color color,
) {
  return InkWell(
    onTap: () => onSelect(context, i),
    child: Ink(
      decoration: BoxDecoration(),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(
          habitIcons[i],
          color: color,
        ),
      ),
    ),
  );
}
