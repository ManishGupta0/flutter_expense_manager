import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/globals/icons.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class IconSelectorDialog extends StatefulWidget {
  const IconSelectorDialog({Key? key}) : super(key: key);

  @override
  State<IconSelectorDialog> createState() => _IconSelectorDialogState();
}

class _IconSelectorDialogState extends State<IconSelectorDialog> {
  IconData? _selectedIcon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Select Icon"),
        const Divider(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              ...icons.keys.map(
                (type) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type),
                    verticalSpace(),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                      padding: const EdgeInsets.all(2.0),
                      children: [
                        ...icons[type]!.map(
                          (e) {
                            return Container(
                              decoration: _selectedIcon == e
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).splashColor,
                                    )
                                  : null,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedIcon = e;
                                  });
                                },
                                icon: Icon(e, size: 32),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    verticalSpace(32),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0),
        ButtonBar(
          buttonPadding: const EdgeInsets.all(18),
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
                onPressed: _selectedIcon == null
                    ? null
                    : () {
                        Navigator.pop(context, _selectedIcon);
                      },
                child: const Text("Add")),
          ],
        ),
      ],
    );
  }
}
