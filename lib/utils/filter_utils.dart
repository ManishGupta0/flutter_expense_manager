import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/models/filter_model.dart';

bool complement(bool value, bool include) {
  if (include) return value;
  return !value;
}

List<Transaction> filterTransactions(
    {required List<Transaction> transactions, required FilterModel filters}) {
  return transactions
      .where(
        (transaction) => isFilterApplied(
          transaction: transaction,
          filters: filters,
        ),
      )
      .toList();
}

bool isFilterApplied(
    {required Transaction transaction, required FilterModel filters}) {
  bool pass = true;
  if (filters.transactionType.value != TransactionType.all) {
    pass &= complement(
        transaction.transactionType == filters.transactionType.value,
        filters.transactionType.include);
  }

  if (filters.fromDate != null && filters.toDate != null) {
    pass &= complement(
        transaction.date.isBefore(filters.toDate!.value) &&
            transaction.date.isAfter(filters.fromDate!.value),
        filters.toDate!.include);
  }

  if (filters.category != null) {
    if (transaction.category == null) return false;

    pass &= complement(transaction.category!.contains(filters.category!.value),
        filters.category!.include);
  }

  if (filters.subCategory != null) {
    if (transaction.subCategory == null) return false;

    pass &= complement(
        transaction.subCategory!.contains(filters.subCategory!.value),
        filters.subCategory!.include);
  }

  if (filters.fromAccount != null) {
    pass &= complement(transaction.account.contains(filters.fromAccount!.value),
        filters.fromAccount!.include);
  }

  if (filters.toAccount != null) {
    if (transaction.toAccount == null) return false;

    pass &= complement(
        transaction.toAccount!.contains(filters.toAccount!.value),
        filters.toAccount!.include);
  }

  if (filters.paymentMethod != null) {
    if (transaction.paymentMethod == null) return false;

    pass &= complement(
        transaction.paymentMethod!.contains(filters.paymentMethod!.value),
        filters.paymentMethod!.include);
  }

  if (filters.payer != null) {
    if (transaction.payerPayee == null) return false;

    pass &= complement(transaction.payerPayee!.contains(filters.payer!.value),
        filters.payer!.include);
  }

  if (filters.fromAmount != null) {
    pass &= complement(transaction.amount >= filters.fromAmount!.value,
        filters.fromAmount!.include);
  }

  if (filters.toAmount != null) {
    pass &= complement(transaction.amount <= filters.toAmount!.value,
        filters.toAmount!.include);
  }

  if (filters.remarks != null) {
    if (transaction.remarks == null) return false;

    pass &= complement(transaction.remarks!.contains(filters.remarks!.value),
        filters.remarks!.include);
  }

  return pass;
}
