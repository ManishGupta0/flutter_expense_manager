import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    Key? key,
    this.initialColor,
    this.onValueChanged,
    this.onSubmit,
  }) : super(key: key);

  final Color? initialColor;
  final Function(Color)? onValueChanged;
  final Function(Color)? onSubmit;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color pickerColor = const Color(0xff443a49);

  @override
  void initState() {
    super.initState();
    pickerColor = widget.initialColor ?? pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: (Color color) {
            widget.onValueChanged?.call(color);
            setState(() => pickerColor = color);
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Pick'),
          onPressed: () {
            widget.onSubmit?.call(pickerColor);
            Navigator.of(context).pop(pickerColor);
          },
        ),
      ],
    );
  }
}
