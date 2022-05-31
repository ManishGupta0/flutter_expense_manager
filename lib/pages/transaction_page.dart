import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_expense_manager/providers/app_provider.dart';
import 'package:flutter_expense_manager/utils/date_utils.dart';
import 'package:flutter_expense_manager/utils/io_utils.dart';
import 'package:flutter_expense_manager/widgets/custom_autocomplete.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({
    Key? key,
    this.transaction,
    this.edit = false,
  }) : super(key: key);
  final bool edit;
  final Transaction? transaction;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late final ExpenseProvider modelProvider;
  late final SettingsProvider settingsProvider;

  final List<Widget> _transactionButtons =
      EnumToString.toList(TransactionType.values, camelCase: true)
          .map((e) => Text(e.toTitle()))
          .toList()
        ..removeAt(0);

  final List<bool> _toggleButtonsSelections =
      List.generate(TransactionType.values.length - 1, (index) => false);

  // Edit or Add
  late String _transactionMode;
  bool showErrors = false;
  // Selected transaction Type
  TransactionType _selectedTransactionType = TransactionType.income;

  late DateTime _dateTime;

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  var _categoryController = TextEditingController();
  var _subCategoryController = TextEditingController();
  var _fromAccountController = TextEditingController();
  var _toAccountController = TextEditingController();
  var _paymentMethodController = TextEditingController();
  var _payerController = TextEditingController();
  final _fromAmountController = TextEditingController();
  final _remarksController = TextEditingController();

  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();

    modelProvider = Provider.of<ExpenseProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    var appProvider = Provider.of<AppProvider>(context, listen: false);

    _transactionMode = widget.edit ? "Edit" : "Add";

    // if (widget.edit) {
    //   if (widget.transaction!.transactionType != TransactionType.transfer) {
    //     _transactionButtons.removeLast();
    //     _toggleButtonsSelections.removeLast();
    //   } else {
    //     _transactionButtons.removeRange(0, 2);
    //     _toggleButtonsSelections.removeRange(0, 2);
    //   }
    // }
    if (widget.transaction == null) {
      _dateTime = DateTime.now();
    }

    if (widget.transaction != null) {
      _selectedTransactionType = widget.transaction!.transactionType;

      _dateTime = widget.transaction!.date;
      _categoryController.text = widget.transaction!.category ?? "";
      _subCategoryController.text = widget.transaction!.subCategory ?? "";
      _fromAccountController.text = widget.transaction!.account;
      _toAccountController.text = "";
      _paymentMethodController.text = widget.transaction!.paymentMethod ?? "";
      _payerController.text = widget.transaction!.payerPayee ?? "";
      _fromAmountController.text = widget.transaction!.amount.toString();
      _remarksController.text = widget.transaction!.remarks ?? "";

      if (widget.transaction!.refFiles != null) {
        _imagePaths = widget.transaction!.refFiles!.map((e) => e.path).toList();
      }
    }

    _toggleButtonsSelections[_selectedTransactionType.index - 1] = true;
    updateDateTime();

    _dateController.addListener(() => setState(() {}));
    _timeController.addListener(() => setState(() {}));
    _categoryController.addListener(() => setState(() {}));
    _subCategoryController.addListener(() => setState(() {}));
    _fromAccountController.addListener(() => setState(() {}));
    _toAccountController.addListener(() => setState(() {}));
    _paymentMethodController.addListener(() => setState(() {}));
    _payerController.addListener(() => setState(() {}));
    _fromAmountController.addListener(() => setState(() {}));
    _remarksController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _timeController.dispose();
    try {
      _categoryController.dispose();
      _subCategoryController.dispose();
      _fromAccountController.dispose();
      _toAccountController.dispose();
      _paymentMethodController.dispose();
      _payerController.dispose();
    } catch (e) {}
    _fromAmountController.dispose();
    _remarksController.dispose();
  }

  void resetForm() {
    setState(() {
      showErrors = false;
      _dateTime = DateTime.now();

      updateDateTime();
      try {
        _categoryController.clear();

        _subCategoryController.clear();
        _fromAccountController.clear();
        _toAccountController.clear();
        _paymentMethodController.clear();
        _payerController.clear();
      } catch (e) {}
      _fromAmountController.clear();
      _remarksController.clear();

      _imagePaths.clear();
    });
  }

  void _pickFiles() async {
    var paths = await IOUtils.imagePicker();
    _imagePaths.addAll(
      paths.where(
        (element) => !_imagePaths.contains(element),
      ),
    );
    setState(() {});
  }

  double getWidth(double width, double spacing) {
    int cols = 0;
    if (width < 500) {
      cols = 2;
    } else if (width < 800) {
      cols = 3;
    } else if (width < 1200) {
      cols = 4;
    } else if (width < 1700) {
      cols = 6;
    } else {
      cols = 7;
    }

    return (width - ((cols - 1) * spacing)) / cols;
  }

  void updateDateTime() {
    _dateController.text = MyDateUtils.getFormattedDate(_dateTime,
        dateFormat: settingsProvider.settings.dateFormat);

    _timeController.text = MyDateUtils.getFormattedDate(_dateTime,
        timeFormat: settingsProvider.settings.timeFormat);
  }

  bool isFormValid() {
    return _fromAccountController.text.trim().isNotEmpty &&
        _fromAmountController.text.trim().isNotEmpty;
  }

  void makeTransaction() async {
    if (!isFormValid()) {
      setState(() {
        showErrors = true;
      });
      return;
    }

    List<RefFile> files =
        _imagePaths.map((e) => RefFile(path: e, fileType: "image")).toList();

    if (_transactionMode == "Add") {
      await modelProvider.addTransaction(
        Transaction(
          transactionType: _selectedTransactionType,
          date: _dateTime,
          account: _fromAccountController.text.trim(),
          toAccount: _toAccountController.text.trim(),
          amount: double.parse(_fromAmountController.text.trim()),
          category: _categoryController.text.trim(),
          subCategory: _subCategoryController.text.trim(),
          paymentMethod: _paymentMethodController.text.trim(),
          payerPayee: _payerController.text.trim(),
          remarks: _remarksController.text.trim(),
          refFiles: files,
        ),
      );
    }

    if (_transactionMode == "Edit") {
      await modelProvider.updateTransaction(
        widget.transaction!,
        Transaction(
          transactionType: _selectedTransactionType,
          date: _dateTime,
          account: _fromAccountController.text.trim(),
          toAccount: _toAccountController.text.trim(),
          amount: double.parse(_fromAmountController.text.trim()),
          category: _categoryController.text.trim(),
          subCategory: _subCategoryController.text.trim(),
          paymentMethod: _paymentMethodController.text.trim(),
          payerPayee: _payerController.text.trim(),
          remarks: _remarksController.text.trim(),
          refFiles: files,
        ),
      );

      Navigator.pop(context);
      showSnackBar(const Text("Transaction Saved"));
      return;
    }

    resetForm();
    showSnackBar(const Text("Transaction Added"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_transactionMode Transaction"),
        actions: [
          if (widget.edit)
            IconButton(
              icon: const Icon(Icons.delete),
              splashRadius: 16,
              onPressed: () {
                modelProvider.deleteTransaction(widget.transaction!);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                // Transfer Type
                ToggleButtons(
                  fillColor: getTransactionTypeColor(_selectedTransactionType),
                  selectedColor: Colors.white,
                  isSelected: _toggleButtonsSelections,
                  constraints: BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width - 24) /
                        _toggleButtonsSelections.length,
                    minHeight: 32,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (int index) {
                    setState(() {
                      _selectedTransactionType =
                          TransactionType.values.elementAt(index + 1);
                      for (int buttonIndex = 0;
                          buttonIndex < _toggleButtonsSelections.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          _toggleButtonsSelections[buttonIndex] = true;
                        } else {
                          _toggleButtonsSelections[buttonIndex] = false;
                        }
                      }

                      _categoryController.text = "";
                      _subCategoryController.text = "";
                      showErrors = false;
                    });
                  },
                  children: _transactionButtons,
                ),
                verticalSpace(32.0),

                // Date Time
                Row(
                  children: [
                    // Date
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        readOnly: true,
                        keyboardType: TextInputType.datetime,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: _dateTime,
                            firstDate: DateTime(DateTime.now().year - 100),
                            lastDate: DateTime(DateTime.now().year + 100),
                          ).then((value) {
                            if (value != null) {
                              _dateTime = DateTime(
                                value.year,
                                value.month,
                                value.day,
                                _dateTime.hour,
                                _dateTime.minute,
                                _dateTime.second,
                                _dateTime.millisecond,
                              );
                            }
                            updateDateTime();
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Date",
                          icon: Icon(Icons.event),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Time
                    Expanded(
                      child: TextField(
                        controller: _timeController,
                        readOnly: true,
                        keyboardType: TextInputType.datetime,
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_dateTime),
                          ).then((value) {
                            if (value != null) {
                              _dateTime = DateTime(
                                _dateTime.year,
                                _dateTime.month,
                                _dateTime.day,
                                value.hour,
                                value.minute,
                                _dateTime.second,
                                _dateTime.millisecond,
                              );

                              updateDateTime();
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Time",
                          icon: Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(),

                // Category: Sub Category
                Row(
                  children: [
                    // Category
                    Expanded(
                      child: CustomAutocomplete<TransactionCategory>(
                        initialText: _categoryController.text,
                        displayStringForOption: (option) => option.name,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return modelProvider.categories.where(
                            (option) {
                              return option.associatedType ==
                                      _selectedTransactionType &&
                                  option.name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase(),
                                      );
                            },
                          ).toList();
                        },
                        getController: (controller) =>
                            _categoryController = controller,
                        labelText:
                            "${EnumToString.convertToString(_selectedTransactionType).toTitle()} Category",
                        icon: const Icon(Icons.category_outlined),
                        optionTile: (option) => ListTile(
                          leading: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(option.color),
                            ),
                            child: const Icon(Icons.category_outlined),
                          ),
                          title: Text(option.name),
                        ),
                        onValueChange: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    // Sub Category
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _categoryController.text.isEmpty,
                        child: CustomAutocomplete<SubCategory>(
                          initialText: _subCategoryController.text,
                          displayStringForOption: (option) => option.name,
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            return modelProvider.subCategories.where(
                              (option) {
                                return (option.associatedType ==
                                        _selectedTransactionType &&
                                    option.name.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase(),
                                        ));
                              },
                            ).toList();
                          },
                          getController: (controller) =>
                              _subCategoryController = controller,
                          labelText: "Sub Category",
                          icon: const Icon(Icons.category_outlined),
                          onValueChange: (value) {},
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(),

                // Accounts
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAutocomplete<Account>(
                            initialText: _fromAccountController.text,
                            displayStringForOption: (option) => option.name,
                            optionsBuilder: (textEditingValue) => modelProvider
                                .accounts
                                .where(
                                  (option) => option.name
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase()),
                                )
                                .toList(),
                            getController: (controller) =>
                                _fromAccountController = controller,
                            labelText: _selectedTransactionType ==
                                    TransactionType.transfer
                                ? "From Account"
                                : "Account",
                            icon: const Icon(Icons.account_balance_outlined),
                            onValueChange: (value) {},
                          ),
                          if (showErrors &&
                              _fromAccountController.text.trim().isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(left: 32.0),
                              child: Text(
                                "Cannot be empty",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // To Account
                    if (_selectedTransactionType ==
                        TransactionType.transfer) ...[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAutocomplete<Account>(
                              initialText: _toAccountController.text,
                              displayStringForOption: (option) => option.name,
                              optionsBuilder: (textEditingValue) =>
                                  modelProvider.accounts
                                      .where(
                                        (option) => option.name
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase()),
                                      )
                                      .toList(),
                              getController: (controller) =>
                                  _toAccountController = controller,
                              labelText: "To Account",
                              icon: const Icon(Icons.account_balance_outlined),
                              onValueChange: (value) {},
                            ),
                            if (showErrors &&
                                _toAccountController.text.trim().isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(left: 32.0),
                                child: Text(
                                  "Cannot be empty",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                      verticalSpace(),
                    ],
                  ],
                ),
                if (showErrors &&
                    _fromAccountController.text.trim().isNotEmpty &&
                    _fromAccountController.text.trim() ==
                        _toAccountController.text.trim())
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      "Cannot be same as To Account",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                verticalSpace(),

                // Payment Method
                CustomAutocomplete<PaymentMethod>(
                  initialText: _paymentMethodController.text,
                  displayStringForOption: (option) => option.name,
                  optionsBuilder: (textEditingValue) =>
                      modelProvider.paymentMethods
                          .where(
                            (option) => option.name
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()),
                          )
                          .toList(),
                  getController: (controller) =>
                      _paymentMethodController = controller,
                  labelText: "Payment Method",
                  icon: const Icon(Icons.moving_rounded),
                  onValueChange: (value) {},
                ),
                verticalSpace(),

                // Payer/Payee
                if (_selectedTransactionType != TransactionType.transfer) ...[
                  CustomAutocomplete<PayerPayee>(
                    initialText: _payerController.text,
                    displayStringForOption: (option) => option.name,
                    optionsBuilder: (textEditingValue) => modelProvider.payeers
                        .where(
                          (option) => option.name
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()),
                        )
                        .toList(),
                    getController: (controller) =>
                        _payerController = controller,
                    labelText:
                        _selectedTransactionType == TransactionType.income
                            ? "Payer"
                            : "Payee",
                    icon: const Icon(Icons.person),
                    onValueChange: (value) {},
                  ),
                  verticalSpace(),
                ],

                // Amount
                TextField(
                  controller: _fromAmountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                  ],
                  decoration: InputDecoration(
                    labelText: "Amount",
                    hintText: "0.0, 100.0, 1000.0 . . .",
                    icon: const Icon(Icons.attach_money_outlined),
                    suffixIcon: _fromAmountController.text.trim().isEmpty
                        ? const SizedBox()
                        : IconButton(
                            icon: const Icon(Icons.close),
                            splashRadius: 16,
                            onPressed: () {
                              _fromAmountController.clear();
                            },
                          ),
                  ),
                ),
                if (showErrors && _fromAmountController.text.trim().isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text("Cannot be empty",
                        style: TextStyle(color: Colors.red)),
                  ),
                verticalSpace(),

                // Remarks
                TextFormField(
                  controller: _remarksController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: "Remarks",
                    icon: const Icon(Icons.text_fields),
                    // isDense: true,
                    suffixIcon: _remarksController.text.trim().isEmpty
                        ? const SizedBox()
                        : IconButton(
                            icon: const Icon(Icons.close),
                            splashRadius: 16,
                            onPressed: () {
                              _remarksController.clear();
                            },
                          ),
                  ),
                ),
                verticalSpace(16),

                // Image Chooser or Camera
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: ElevatedButton(
                        onPressed: null,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ),
                    horizontalSpace(),
                    Expanded(
                      child: TextButton(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.image_outlined),
                        ),
                        onPressed: () {
                          _pickFiles();
                        },
                      ),
                    ),
                  ],
                ),

                // Images
                if (_imagePaths.isNotEmpty) ...[
                  const Divider(),
                  verticalSpace(),

                  // Images
                  if (_imagePaths.isNotEmpty) imageLayout(),
                ],
                verticalSpace(),
              ],
            ),
          ),

          // Add/Reset Buttons
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    onPressed: () {
                      resetForm();
                    },
                  ),
                ),
                horizontalSpace(),
                const Text("|"),
                horizontalSpace(),
                Expanded(
                  child: TextButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          widget.edit ? const Text("Save") : const Text("Add"),
                    ),
                    onPressed: () {
                      makeTransaction();

                      // Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LayoutBuilder imageLayout() {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ..._imagePaths.map(
              (e) {
                return SizedBox(
                  width: getWidth(constraints.maxWidth, 10),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: GestureDetector(
                          // child: Text(e),
                          child: Image.file(
                            File(e),
                            filterQuality: FilterQuality.medium,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  insetPadding: const EdgeInsets.all(0),
                                  child: InteractiveViewer(
                                    child: Image.file(
                                      File(e),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        child: GestureDetector(
                          child: const CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              _imagePaths.remove(e);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
