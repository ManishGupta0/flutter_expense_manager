import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({Key? key}) : super(key: key);

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _nameFieldController = TextEditingController();
  final _typeFieldController = TextEditingController();
  final _balanceFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameFieldController.addListener(() => setState(() {}));
    _typeFieldController.addListener(() => setState(() {}));
    _balanceFieldController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _typeFieldController.dispose();
    _balanceFieldController.dispose();
    super.dispose();
  }

  bool canSubmit() {
    return _nameFieldController.text.trim().isNotEmpty &&
        _typeFieldController.text.trim().isNotEmpty &&
        _balanceFieldController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Asset Account"),
          const Divider(),
          TextField(
            controller: _nameFieldController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Source Name",
              hintText: "Bank Name, Wallet Name . . .",
              border: const OutlineInputBorder(),
              suffixIcon: _nameFieldController.text.trim().isEmpty
                  ? const SizedBox()
                  : IconButton(
                      icon: const Icon(Icons.close),
                      splashRadius: 16,
                      onPressed: () {
                        _nameFieldController.clear();
                        setState(() {});
                      },
                    ),
            ),
          ),
          verticalSpace(16),
          TextField(
            controller: _typeFieldController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Source Type",
              hintText: "Wallet, Bank, Card . . .",
              border: const OutlineInputBorder(),
              suffixIcon: _typeFieldController.text.trim().isEmpty
                  ? const SizedBox()
                  : IconButton(
                      icon: const Icon(Icons.close),
                      splashRadius: 16,
                      onPressed: () {
                        _typeFieldController.clear();
                        setState(() {});
                      },
                    ),
            ),
          ),
          verticalSpace(16),
          TextField(
            controller: _balanceFieldController,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
            ],
            decoration: InputDecoration(
              labelText: "Balance",
              hintText: "0.0, 100.0, 1000.0 . . .",
              border: const OutlineInputBorder(),
              suffixIcon: _balanceFieldController.text.trim().isEmpty
                  ? const SizedBox()
                  : IconButton(
                      icon: const Icon(Icons.close),
                      splashRadius: 16,
                      onPressed: () {
                        _balanceFieldController.clear();
                        setState(() {});
                      },
                    ),
            ),
          ),
          verticalSpace(),
          ButtonBar(
            children: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: canSubmit()
                    ? () {
                        Navigator.pop(
                          context,
                          Account(
                            name: _nameFieldController.text.trim(),
                            type: _typeFieldController.text.trim(),
                            balance: double.parse(
                                _balanceFieldController.text.trim()),
                          ),
                        );
                      }
                    : null,
                child: const Text("Add"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
