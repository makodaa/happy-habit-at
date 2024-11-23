import "package:flutter/material.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class CurrencyDisplay extends StatelessWidget {
  const CurrencyDisplay({required this.currency, this.color, super.key});

  static final NumberFormat formatter = NumberFormat("#,##0", "en_US");

  final int currency;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          formatter.format(currency),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8.0),
        Icon(Icons.circle, color: color),
      ],
    );
  }
}

class UserCurrencyDisplay extends StatelessWidget {
  const UserCurrencyDisplay({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: context.read<AppState>().currency,
      builder: (BuildContext context, int currency, _) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          CurrencyDisplay(currency: currency, color: color),
        ],
      ),
    );
  }
}
