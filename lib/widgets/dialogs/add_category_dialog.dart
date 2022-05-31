import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';
import 'package:flutter_expense_manager/widgets/dialogs/common_dialog.dart';
import 'package:flutter_expense_manager/widgets/dialogs/icon_selector_dialog.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({
    Key? key,
    this.assentColor = true,
  }) : super(key: key);

  final bool assentColor;

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _nameFieldController = TextEditingController();
  Color _categoryColor = Colors.white;
  Icon _categoryIcon = const Icon(Icons.category_outlined);

  @override
  void initState() {
    super.initState();

    _categoryColor = getRandomColor(widget.assentColor);

    _nameFieldController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    super.dispose();
  }

  bool canSubmit() {
    return _nameFieldController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Category"),
          const Divider(),
          TextField(
            controller: _nameFieldController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Category Name",
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
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text("Color"),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          _categoryColor = await showColorPicker(
                                context,
                                initialColor: _categoryColor,
                              ) ??
                              _categoryColor;
                          setState(() {});
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: _categoryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  splashRadius: 16,
                  onPressed: () {
                    setState(() {
                      _categoryColor = getRandomColor(widget.assentColor);
                    });
                  },
                ),
              ],
            ),
          ),
          verticalSpace(16),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text("Icon"),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _categoryColor,
                      ),
                      child: IconButton(
                        splashRadius: 25,
                        icon: _categoryIcon,
                        onPressed: () async {
                          var icon = await showDialog<IconData>(
                            context: context,
                            builder: (context) {
                              return commonDialog(
                                child: const IconSelectorDialog(),
                              );
                            },
                          );
                          if (icon != null) {
                            setState(() {
                              _categoryIcon = Icon(icon);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  splashRadius: 16,
                  onPressed: () {},
                ),
              ],
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
                          TransactionCategory(
                            name: _nameFieldController.text.trim(),
                            color: _categoryColor.value,
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
