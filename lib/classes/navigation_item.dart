import 'package:flutter/material.dart';

class NavigationItem {
  const NavigationItem({
    required this.child,
    required this.icon,
    required this.label,
  });

  final String label;
  final Widget icon;
  final Widget child;
}
