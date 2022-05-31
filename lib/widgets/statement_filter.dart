import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/models/filter_model.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/date_utils.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';
import 'package:flutter_expense_manager/widgets/custom_autocomplete.dart';

class StatementFilter extends StatefulWidget {
  const StatementFilter({
    Key? key,
    this.filters,
    this.onSubmit,
  }) : super(key: key);

  final void Function(FilterModel)? onSubmit;
  final FilterModel? filters;

  @override
  State<StatementFilter> createState() => _StatementFilterState();
}

class _StatementFilterState extends State<StatementFilter> {
  late final ExpenseProvider modelProvider;
  late final SettingsProvider settingsProvider;

  final List<Widget> _transactionButtons =
      EnumToString.toList(TransactionType.values, camelCase: true)
          .map((e) => Text(e.toTitle()))
          .toList();

  final List<bool> _toggleButtonsSelections =
      List.generate(TransactionType.values.length, (index) => false);

  final List<bool> _filterToggles = List.generate(8, (index) => true);

  // Selected transaction Type
  TransactionType _selectedTransactionType = TransactionType.income;

  late DateTime _fromDateTime;
  late DateTime _toDateTime;

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  var _categoryController = TextEditingController();
  var _subCategoryController = TextEditingController();
  var _fromAccountController = TextEditingController();
  var _toAccountController = TextEditingController();
  var _paymentMethodController = TextEditingController();
  var _payerController = TextEditingController();
  final _fromAmountController = TextEditingController();
  final _toAmountController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    modelProvider = Provider.of<ExpenseProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    _selectedTransactionType = TransactionType.all;

    _fromDateTime = DateTime(DateTime.now().year, 1);
    _toDateTime = DateTime.now();

    if (widget.filters != null) {
      _selectedTransactionType = widget.filters!.transactionType.value;
      _filterToggles[0] = widget.filters!.transactionType.include;

      if (widget.filters!.fromDate != null) {
        _fromDateTime = widget.filters!.fromDate!.value;
        _filterToggles[1] = widget.filters!.fromDate!.include;
      }

      if (widget.filters!.toDate != null) {
        _toDateTime = widget.filters!.toDate!.value;
        _filterToggles[1] = widget.filters!.toDate!.include;
      }

      if (widget.filters!.category != null) {
        _categoryController.text = widget.filters!.category!.value;
        _filterToggles[2] = widget.filters!.category!.include;
      }

      if (widget.filters!.subCategory != null) {
        _subCategoryController.text = widget.filters!.subCategory!.value;
        _filterToggles[2] = widget.filters!.subCategory!.include;
      }

      if (widget.filters!.fromAccount != null) {
        _fromAccountController.text = widget.filters!.fromAccount!.value;
        _filterToggles[3] = widget.filters!.fromAccount!.include;
      }

      if (widget.filters!.toAccount != null) {
        _toAccountController.text = widget.filters!.toAccount!.value;
        _filterToggles[3] = widget.filters!.toAccount!.include;
      }

      if (widget.filters!.paymentMethod != null) {
        _paymentMethodController.text = widget.filters!.paymentMethod!.value;
        _filterToggles[4] = widget.filters!.paymentMethod!.include;
      }

      if (widget.filters!.payer != null) {
        _payerController.text = widget.filters!.payer!.value;
        _filterToggles[5] = widget.filters!.payer!.include;
      }

      if (widget.filters!.fromAmount != null) {
        _fromAmountController.text =
            widget.filters!.fromAmount!.value.toString();
        _filterToggles[6] = widget.filters!.fromAmount!.include;
      }

      if (widget.filters!.toAmount != null) {
        _toAmountController.text = widget.filters!.toAmount!.value.toString();
        _filterToggles[6] = widget.filters!.toAmount!.include;
      }

      if (widget.filters!.remarks != null) {
        _remarksController.text = widget.filters!.remarks!.value;
        _filterToggles[7] = widget.filters!.transactionType.include;
      }
    }
    _toggleButtonsSelections[_selectedTransactionType.index] = true;
    updateDateTime();

    _fromDateController.addListener(() => setState(() {}));
    _toDateController.addListener(() => setState(() {}));
    _categoryController.addListener(() => setState(() {}));
    _subCategoryController.addListener(() => setState(() {}));
    _fromAccountController.addListener(() => setState(() {}));
    _toAccountController.addListener(() => setState(() {}));
    _paymentMethodController.addListener(() => setState(() {}));
    _payerController.addListener(() => setState(() {}));
    _fromAmountController.addListener(() => setState(() {}));
    _toAmountController.addListener(() => setState(() {}));
    _remarksController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    try {
      _categoryController.dispose();
      _subCategoryController.dispose();
      _fromAccountController.dispose();
      _toAccountController.dispose();
      _paymentMethodController.dispose();
      _payerController.dispose();
    } catch (e) {}
    _fromAmountController.dispose();
    _toAmountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void resetForm() {
    setState(() {
      _selectedTransactionType = TransactionType.all;
      _toggleButtonsSelections[_selectedTransactionType.index] = true;

      _fromDateTime = DateTime(DateTime.now().year, DateTime.now().month);
      _toDateTime = DateTime.now();

      updateDateTime();
      _categoryController.clear();
      _subCategoryController.clear();
      _fromAccountController.clear();
      _toAccountController.clear();
      _paymentMethodController.clear();
      _payerController.clear();
      _fromAmountController.clear();
      _toAmountController.clear();
      _remarksController.clear();
    });
  }

  void updateDateTime() {
    _fromDateController.text = MyDateUtils.getFormattedDate(_fromDateTime,
        dateFormat: settingsProvider.settings.dateFormat);
    _toDateController.text = MyDateUtils.getFormattedDate(_toDateTime,
        dateFormat: settingsProvider.settings.dateFormat);
  }

  FilterModel getFilter() {
    return FilterModel(
      transactionType: FilterItem(
        value: _selectedTransactionType,
        include: _filterToggles[0],
      ),
      fromDate: _fromDateController.text.isEmpty
          ? null
          : FilterItem(
              value: _fromDateTime,
              include: _filterToggles[1],
            ),
      toDate: _toDateController.text.isEmpty
          ? null
          : FilterItem(
              value: _toDateTime,
              include: _filterToggles[1],
            ),
      category: _categoryController.text.isEmpty
          ? null
          : FilterItem(
              value: _categoryController.text.trim(),
              include: _filterToggles[2],
            ),
      subCategory: _subCategoryController.text.isEmpty
          ? null
          : FilterItem(
              value: _subCategoryController.text.trim(),
              include: _filterToggles[2],
            ),
      fromAccount: _fromAccountController.text.isEmpty
          ? null
          : FilterItem(
              value: _fromAccountController.text.trim(),
              include: _filterToggles[3],
            ),
      toAccount: _toAccountController.text.isEmpty
          ? null
          : FilterItem(
              value: _toAccountController.text.trim(),
              include: _filterToggles[3],
            ),
      paymentMethod: _paymentMethodController.text.isEmpty
          ? null
          : FilterItem(
              value: _paymentMethodController.text.trim(),
              include: _filterToggles[4],
            ),
      payer: _payerController.text.isEmpty
          ? null
          : FilterItem(
              value: _payerController.text.trim(),
              include: _filterToggles[5],
            ),
      fromAmount: _fromAmountController.text.isEmpty
          ? null
          : FilterItem(
              value: double.parse(_fromAmountController.text.trim()),
              include: _filterToggles[6],
            ),
      toAmount: _toAmountController.text.isEmpty
          ? null
          : FilterItem(
              value: double.parse(_toAmountController.text.trim()),
              include: _filterToggles[6],
            ),
      remarks: _remarksController.text.isEmpty
          ? null
          : FilterItem(
              value: _remarksController.text.trim(),
              include: _filterToggles[7],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text("Filter"),
        ),

        const Divider(),
        Padding(
          padding: const EdgeInsets.only(
            right: 16,
            // vertical: 8,
          ),
          child: Column(
            children: [
              // Transfer Type
              Row(
                children: [
                  Checkbox(
                    value: _filterToggles[0],
                    onChanged: (value) => setState(
                      () => _filterToggles[0] = value!,
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => ToggleButtons(
                        fillColor:
                            getTransactionTypeColor(_selectedTransactionType),
                        selectedColor: Colors.white,
                        isSelected: _toggleButtonsSelections,
                        constraints: BoxConstraints(
                          minWidth: (constraints.maxWidth - 8) /
                              _toggleButtonsSelections.length,
                          minHeight: 32,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        onPressed: (int index) {
                          setState(() {
                            _selectedTransactionType =
                                TransactionType.values.elementAt(index);
                            if (_selectedTransactionType ==
                                TransactionType.all) {
                              _filterToggles[0] = true;
                            }
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
                          });
                        },
                        children: _transactionButtons,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(32.0),

              // Date Range
              Row(
                children: [
                  Checkbox(
                    value: _filterToggles[1],
                    onChanged: (value) => setState(
                      () => _filterToggles[1] = value!,
                    ),
                  ),
                  // From Date
                  Expanded(
                    child: TextField(
                      controller: _fromDateController,
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: _fromDateTime,
                          firstDate: DateTime(DateTime.now().year - 100),
                          lastDate: _toDateTime,
                        ).then((value) {
                          if (value != null) {
                            _fromDateTime = DateTime(
                              value.year,
                              value.month,
                              value.day,
                              _fromDateTime.hour,
                              _fromDateTime.minute,
                              _fromDateTime.second,
                              _fromDateTime.millisecond,
                            );
                          }
                          updateDateTime();
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "From Date",
                        icon: Icon(Icons.event),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // To Date
                  Expanded(
                    child: TextField(
                      controller: _toDateController,
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: _toDateTime,
                          firstDate: _fromDateTime,
                          lastDate: DateTime(DateTime.now().year + 100),
                        ).then((value) {
                          if (value != null) {
                            _toDateTime = DateTime(
                              value.year,
                              value.month,
                              value.day,
                              _toDateTime.hour,
                              _toDateTime.minute,
                              _toDateTime.second,
                              _toDateTime.millisecond,
                            );
                          }
                          updateDateTime();
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "To Date",
                        icon: Icon(Icons.event),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(),

              // Category: Sub Category
              Row(
                children: [
                  Checkbox(
                    value: _filterToggles[2],
                    onChanged: (value) => setState(
                      () => _filterToggles[2] = value!,
                    ),
                  ),
                  // Category
                  Expanded(
                    child: CustomAutocomplete<TransactionCategory>(
                      initialText: _categoryController.text,
                      displayStringForOption: (option) => option.name,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (_selectedTransactionType == TransactionType.all) {
                          return modelProvider.categories;
                        }
                        return modelProvider.categories
                            .where(
                              (option) => (option.associatedType ==
                                      _selectedTransactionType &&
                                  option.name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase(),
                                      )),
                            )
                            .toList();
                      },
                      getController: (controller) =>
                          _categoryController = controller,
                      labelText:
                          "${EnumToString.convertToString(_selectedTransactionType).toTitle()} Category",
                      icon: const Icon(Icons.category),
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
                        optionsBuilder: (TextEditingValue textEditingValue) =>
                            modelProvider.subCategories
                                .where(
                                  (option) => (option.associatedType ==
                                          _selectedTransactionType &&
                                      option.name.toLowerCase().contains(
                                            textEditingValue.text.toLowerCase(),
                                          )),
                                )
                                .toList(),
                        getController: (controller) =>
                            _subCategoryController = controller,
                        labelText: "Sub Category",
                        icon: const Icon(Icons.category),
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
                  Checkbox(
                    value: _filterToggles[3],
                    onChanged: (value) => setState(
                      () => _filterToggles[3] = value!,
                    ),
                  ),
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
                                (option) => option.name.toLowerCase().contains(
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
                      ],
                    ),
                  ),
                  // To Account
                  if (_selectedTransactionType == TransactionType.transfer) ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAutocomplete<Account>(
                            initialText: _toAccountController.text,
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
                                _toAccountController = controller,
                            labelText: "To Account",
                            icon: const Icon(Icons.account_balance_outlined),
                            onValueChange: (value) {},
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(),
                  ],
                ],
              ),
              verticalSpace(),

              // Payment Method
              Row(
                children: [
                  Checkbox(
                    value: _filterToggles[4],
                    onChanged: (value) => setState(
                      () => _filterToggles[4] = value!,
                    ),
                  ),
                  Expanded(
                    child: CustomAutocomplete<PaymentMethod>(
                      initialText: _paymentMethodController.text,
                      displayStringForOption: (option) => option.name,
                      optionsBuilder: (textEditingValue) => modelProvider
                          .paymentMethods
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
                  ),
                ],
              ),
              verticalSpace(),

              // Payer/Payee
              if (_selectedTransactionType != TransactionType.transfer) ...[
                Row(
                  children: [
                    Checkbox(
                      value: _filterToggles[5],
                      onChanged: (value) => setState(
                        () => _filterToggles[5] = value!,
                      ),
                    ),
                    Expanded(
                      child: CustomAutocomplete<PayerPayee>(
                        initialText: _payerController.text,
                        displayStringForOption: (option) => option.name,
                        optionsBuilder: (textEditingValue) =>
                            modelProvider.payeers
                                .where(
                                  (option) => option.name
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase()),
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
                    ),
                  ],
                ),
                verticalSpace(),
              ],

              // Amount
              Row(
                children: [
                  Checkbox(
                    value: _filterToggles[6],
                    onChanged: (value) => setState(
                      () => _filterToggles[6] = value!,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _fromAmountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                      ],
                      decoration: InputDecoration(
                        labelText: "From Amount",
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
                  ),
                  Expanded(
                    child: TextField(
                      controller: _toAmountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                      ],
                      decoration: InputDecoration(
                        labelText: "To Amount",
                        hintText: "0.0, 100.0, 1000.0 . . .",
                        icon: const Icon(Icons.attach_money_outlined),
                        suffixIcon: _toAmountController.text.trim().isEmpty
                            ? const SizedBox()
                            : IconButton(
                                icon: const Icon(Icons.close),
                                splashRadius: 16,
                                onPressed: () {
                                  _toAmountController.clear();
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(),

              // Remarks
              Row(
                children: [
                  Checkbox(
                    value: _filterToggles[7],
                    onChanged: (value) => setState(
                      () => _filterToggles[7] = value!,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _remarksController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: "Remarks",
                        icon: const Icon(Icons.text_fields),
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
                  ),
                ],
              ),
              verticalSpace(),
            ],
          ),
        ),
        // Add/Reset Buttons
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Filter"),
                  ),
                  onPressed: () {
                    if (widget.onSubmit != null) {
                      widget.onSubmit!(getFilter());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
