import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/globals/globals.dart';

Widget horizontalSpace([double size = 8.0]) {
  return SizedBox(width: size);
}

Widget verticalSpace([double size = 8.0]) {
  return SizedBox(height: size);
}

void popNavigator(BuildContext context) {
  Navigator.pop(context);
}

void showSnackBar(Widget child) {
  globalSnackbarKey.currentState?.showSnackBar(
    SnackBar(
      content: child,
      duration: const Duration(milliseconds: 3000),
      action: SnackBarAction(
        label: "Dismiss",
        onPressed: () {
          globalSnackbarKey.currentState?.hideCurrentSnackBar();
        },
      ),
    ),
  );
}

Color getTransactionTypeColor(TransactionType type, [bool accent = false]) {
  if (accent) {
    switch (type) {
      case TransactionType.all:
        return Colors.blueAccent;
      case TransactionType.income:
        return Colors.greenAccent;
      case TransactionType.expense:
        return Colors.redAccent;
      case TransactionType.transfer:
        return Colors.orangeAccent;
    }
  }
  switch (type) {
    case TransactionType.all:
      return Colors.blue;
    case TransactionType.income:
      return Colors.green;
    case TransactionType.expense:
      return Colors.red;
    case TransactionType.transfer:
      return Colors.orange;
  }
}

Color getBalanceColor(double balance) {
  if (balance < 0) {
    return getTransactionTypeColor(TransactionType.expense);
  } else if (balance > 0) {
    return getTransactionTypeColor(TransactionType.income);
  }

  return Colors.white;
}

List<Color> _previousPrimaryColors = [];
List<Color> _previousAccentColors = [];

Color getRandomColor([bool assent = true]) {
  if (assent) {
    var color = Colors.accents[Random().nextInt(Colors.accents.length)];
    if (!_previousAccentColors.contains(color)) {
      _previousAccentColors.add(color);
      if (_previousAccentColors.length == Colors.accents.length) {
        _previousAccentColors.removeAt(0);
      }
      return color;
    } else {
      return getRandomColor();
    }
  }

  var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  if (!_previousPrimaryColors.contains(color)) {
    _previousPrimaryColors.add(color);
    if (_previousPrimaryColors.length == Colors.primaries.length) {
      _previousPrimaryColors.removeAt(0);
    }
    return color;
  } else {
    return getRandomColor();
  }
}
