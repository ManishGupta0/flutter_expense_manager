import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/widgets/autocomplete_dropdown.dart';

class CustomAutocomplete<T extends Object> extends StatefulWidget {
  const CustomAutocomplete({
    Key? key,
    this.initialText = "",
    required this.displayStringForOption,
    required this.optionsBuilder,
    this.getController,
    this.optionTile,
    this.labelText,
    this.icon,
    this.onValueChange,
  }) : super(key: key);

  final String initialText;
  final String Function(T) displayStringForOption;
  final List<T> Function(TextEditingValue) optionsBuilder;
  final void Function(TextEditingController)? getController;
  final Widget Function(T)? optionTile;
  final String? labelText;
  final Widget? icon;

  final void Function(String)? onValueChange;

  @override
  State<CustomAutocomplete<T>> createState() => _CustomAutocompleteState<T>();
}

class _CustomAutocompleteState<T extends Object>
    extends State<CustomAutocomplete<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      initialValue: TextEditingValue(text: widget.initialText),
      displayStringForOption: widget.displayStringForOption,
      optionsBuilder: widget.optionsBuilder,
      fieldViewBuilder: (_, controller, focusnode, onFieldSubmitted) {
        _controller = controller;
        if (widget.getController != null) {
          widget.getController!(_controller);
        }
        return TextFormField(
          controller: _controller,
          focusNode: focusnode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
            if (widget.onValueChange != null) {
              widget.onValueChange!(_controller.text);
            }
          },
          onChanged: (value) {
            setState(() {});
            if (widget.onValueChange != null) {
              widget.onValueChange!(_controller.text);
            }
          },
          decoration: InputDecoration(
            labelText: widget.labelText,
            icon: widget.icon,
            suffixIcon: _controller.text.trim().isEmpty
                ? const SizedBox()
                : IconButton(
                    icon: const Icon(Icons.close),
                    splashRadius: 16,
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                      });
                      if (widget.onValueChange != null) {
                        widget.onValueChange!(_controller.text);
                      }
                    },
                  ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return AutocompleteOptions<T>(
          onSelected: onSelected,
          options: options,
          maxOptionsWidth: MediaQuery.of(context).size.width - 16,
          builder: (_, option) {
            if (widget.optionTile != null) {
              return widget.optionTile!(option);
            }
            return ListTile(
              title: Text(widget.displayStringForOption(option)),
            );
          },
        );
      },
      onSelected: (T selection) {
        setState(() {});
        if (widget.onValueChange != null) {
          widget.onValueChange!(_controller.text);
        }
      },
    );
  }
}
