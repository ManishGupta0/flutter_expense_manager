import 'package:flutter_expense_manager/globals/globals.dart';

class FilterItem<T> {
  FilterItem({required this.value, this.include = true});
  bool include;
  T value;
}

class FilterModel {
  FilterItem<TransactionType> transactionType =
      FilterItem(value: TransactionType.all);
  FilterItem<DateTime>? fromDate;
  FilterItem<DateTime>? toDate;
  FilterItem<String>? category;
  FilterItem<String>? subCategory;
  FilterItem<String>? fromAccount;
  FilterItem<String>? toAccount;
  FilterItem<String>? paymentMethod;
  FilterItem<String>? payer;
  FilterItem<double>? fromAmount;
  FilterItem<double>? toAmount;
  FilterItem<String>? remarks;

  bool _isApplied = false;

  bool get isFilterApplied => _isApplied;

  FilterModel({
    FilterItem<TransactionType>? transactionType,
    this.fromDate,
    this.toDate,
    this.category,
    this.subCategory,
    this.fromAccount,
    this.toAccount,
    this.paymentMethod,
    this.payer,
    this.fromAmount,
    this.toAmount,
    this.remarks,
  }) {
    if (transactionType == null) {
      this.transactionType = FilterItem(value: TransactionType.all);
    } else {
      this.transactionType = transactionType;
    }
    _isApplied = fromDate != null ||
        toDate != null ||
        category != null ||
        subCategory != null ||
        fromAccount != null ||
        toAccount != null ||
        paymentMethod != null ||
        payer != null ||
        fromAmount != null ||
        toAmount != null ||
        remarks != null;
  }
}
