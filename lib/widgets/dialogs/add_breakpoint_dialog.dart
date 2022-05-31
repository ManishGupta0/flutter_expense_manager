import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/utils/date_utils.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class AddBreakpointDialog extends StatefulWidget {
  const AddBreakpointDialog({Key? key}) : super(key: key);

  @override
  State<AddBreakpointDialog> createState() => _AddBreakpointDialogState();
}

class _AddBreakpointDialogState extends State<AddBreakpointDialog> {
  late SettingsProvider settingsProvider;
  final _nameFieldController = TextEditingController();
  final _dateFieldController = TextEditingController();

  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    _nameFieldController.addListener(() => setState(() {}));
    _dateFieldController.addListener(() => setState(() {}));

    updateDateTime();
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _dateFieldController.dispose();
    super.dispose();
  }

  void updateDateTime() {
    _dateFieldController.text = MyDateUtils.getFormattedDate(
      _dateTime,
      dateFormat: settingsProvider.settings.dateFormat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Breakpoint"),
          const Divider(),
          TextField(
            controller: _dateFieldController,
            readOnly: true,
            keyboardType: TextInputType.datetime,
            onTap: () async {
              var selectedDate = await showDatePicker(
                context: context,
                initialDate: _dateTime,
                firstDate: DateTime(DateTime.now().year - 100),
                lastDate: DateTime(DateTime.now().year + 100),
              );
              if (selectedDate != null) {
                _dateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                );

                updateDateTime();
              }
            },
            decoration: const InputDecoration(
              labelText: "Date",
              icon: Icon(Icons.event),
              border: OutlineInputBorder(),
            ),
          ),
          verticalSpace(),
          TextField(
            controller: _nameFieldController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Breakpoint Name",
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.text_fields),
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
                onPressed: _nameFieldController.text.trim().isEmpty
                    ? null
                    : () {
                        Navigator.pop(
                          context,
                          BreakPoint(
                            date: _dateTime,
                            breakPointName: _nameFieldController.text.trim(),
                          ),
                        );
                      },
                child: const Text("Add"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
