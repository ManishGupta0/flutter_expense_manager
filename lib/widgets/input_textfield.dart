import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  const InputTextField(
      {Key? key, required this.labelText, required this.onSubmit})
      : super(key: key);

  final String labelText;
  final Function(String value) onSubmit;

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  final _inputController = TextEditingController();
  var focus = FocusNode();

  @override
  void initState() {
    super.initState();

    _inputController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _inputController,
            autofocus: true,
            focusNode: focus,
            decoration: InputDecoration(
              labelText: widget.labelText,
              suffixIcon: _inputController.text.trim().isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      splashRadius: 16,
                      onPressed: () {
                        _inputController.clear();
                      },
                    )
                  : const SizedBox(),
            ),
            onFieldSubmitted: (value) {
              widget.onSubmit(_inputController.text.trim());
              _inputController.clear();
              focus.requestFocus();
            },
          ),
        ),
        if (_inputController.text.trim().isNotEmpty)
          IconButton(
            splashRadius: 16,
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onSubmit(_inputController.text.trim());
              _inputController.clear();
            },
          ),
      ],
    );
  }
}
