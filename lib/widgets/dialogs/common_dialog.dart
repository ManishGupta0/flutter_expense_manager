import 'package:flutter/material.dart';

Widget commonDialog({Widget? child}) {
  return Dialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: child,
  );
}
