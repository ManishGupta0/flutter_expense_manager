import 'dart:math';

import 'package:flutter/material.dart';

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
