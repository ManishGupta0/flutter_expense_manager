import 'dart:io';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:flutter_expense_manager/utils/app_utils.dart';
import 'package:flutter_expense_manager/utils/io_utils.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/date_utils.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';
import 'package:flutter_expense_manager/utils/hive_utils.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

int getTransactionSign(TransactionType transactionType) {
  switch (transactionType) {
    case TransactionType.income:
      return 1;
    case TransactionType.expense:
      return -1;
    default:
      return -1;
  }
}

class HiveExpenseProvider extends ExpenseProvider {
  List<TransactionCategory> _categories = [];
  List<SubCategory> _subCategories = [];
  List<Account> _accounts = [];
  List<PaymentMethod> _paymentMethods = [];
  List<PayerPayee> _payeers = [];
  List<RefFile> _refFiles = [];
  List<Transaction> _transactions = [];
  List<BreakPoint> _breakpoints = [];

  List<Transaction> _transactionThisMonth = [];

  @override
  List<TransactionCategory> get categories => _categories;
  @override
  List<SubCategory> get subCategories => _subCategories;
  @override
  List<Account> get accounts => _accounts;
  @override
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  @override
  List<PayerPayee> get payeers => _payeers;
  @override
  List<RefFile> get refFiles => _refFiles;
  @override
  List<Transaction> get transactions => _transactions;
  @override
  List<Transaction> get transactionsThisMonth => _transactionThisMonth;
  @override
  List<BreakPoint> get breakpoints => _breakpoints;

  void calculateThisMonthTransactions() {
    var toDate = DateTime.now();
    var fromDate = DateTime(toDate.year, toDate.month);

    _transactionThisMonth = _transactions.where((element) {
      return element.date.isAfter(fromDate) && element.date.isBefore(toDate);
    }).toList();
  }

  Future<void> reCalculate() async {
    Map<String, double> accountBalanceMap = {};
    for (var account in _accounts) {
      accountBalanceMap[account.name] = account.balance.withPrecision();
    }

    for (var i = _transactions.length - 1; i >= 0; i--) {
      var t = _transactions.elementAt(i);
      t.balance = accountBalanceMap[t.account]!.withPrecision();

      var newBalance = accountBalanceMap[t.account]! +
          t.amount * -getTransactionSign(t.transactionType);

      accountBalanceMap[t.account] = newBalance.withPrecision();

      if (t.transactionType == TransactionType.transfer) {
        t.balance2 = accountBalanceMap[t.toAccount]!.withPrecision();

        var newBalance2 = accountBalanceMap[t.toAccount]! - t.amount;
        accountBalanceMap[t.toAccount!] = newBalance2.withPrecision();
      }
      await t.save();
    }

    for (var payer in _payeers) {
      var t =
          _transactions.where((element) => element.payerPayee == payer.name);
      var balance = t.fold<double>(0.0, (previousValue, element) {
        return (previousValue +
                element.amount * getTransactionSign(element.transactionType))
            .withPrecision();
      });

      payer.balance = balance.withPrecision();
      await payer.save();
    }
  }

  @override
  Future<String> export(String exportPath) async {
    ExpenseModel e = ExpenseModel(
      categories: _categories,
      subCategories: _subCategories,
      accounts: _accounts,
      paymentMethods: _paymentMethods,
      payeers: _payeers,
      refFiles: _refFiles,
      transactions: _transactions,
      breakpoints: _breakpoints,
    );

    var file = File(p.join(exportPath, "export.json"));
    await file.create();
    var spaces = " " * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    await file.writeAsString(encoder.convert(e.toJson()));

    return file.path;
  }

  @override
  Future<String> import(String importPath) async {
    await clean();
    var dbPath = p.join(importPath, "export.json");
    var file = File(dbPath);

    if (await file.exists()) {
      var data = await file.readAsString();
      var expense = ExpenseModel.fromJson(convert.jsonDecode(data));

      _categories = expense.categories;
      _subCategories = expense.subCategories;
      _accounts = expense.accounts;
      _paymentMethods = expense.paymentMethods;
      _payeers = expense.payeers;
      _refFiles = expense.refFiles;
      _transactions = expense.transactions;
      _breakpoints = expense.breakpoints;

      HiveUtils.categoryBox.putAll(
        {for (var c in _categories) getCategoryKey(c): c},
      );

      HiveUtils.subCategoryBox.putAll(
        {for (var c in _subCategories) getCategoryKey(c): c},
      );

      HiveUtils.accountBox.putAll(
        {for (var c in _accounts) c.name: c},
      );

      HiveUtils.paymentMethodBox.putAll(
        {for (var c in _paymentMethods) c.name: c},
      );

      HiveUtils.payerBox.putAll(
        {for (var c in _payeers) c.name: c},
      );

      // HiveUtils.refFileBox.putAll(
      //   {for (var c in _refFiles) c.name: c},
      // );

      HiveUtils.transactionBox.putAll(
        {for (var c in _transactions) c.date.toString(): c},
      );

      HiveUtils.breakPointBox.putAll(
        {for (var c in _breakpoints) c.date.toString(): c},
      );

      // await reCalculate();

      calculateThisMonthTransactions();
      notifyListeners();

      return dbPath;
    }
    return "";
  }

  @override
  void load() {
    _categories = HiveUtils.categoryBox.values.toList();
    _subCategories = HiveUtils.subCategoryBox.values.toList();
    _accounts = HiveUtils.accountBox.values.toList();
    _paymentMethods = HiveUtils.paymentMethodBox.values.toList();
    _payeers = HiveUtils.payerBox.values.toList();
    _refFiles = HiveUtils.refFileBox.values.toList();
    _transactions = HiveUtils.transactionBox.values.toList();
    _breakpoints = HiveUtils.breakPointBox.values.toList();

    calculateThisMonthTransactions();
  }

  @override
  Future<void> doFirstInit() async {
    if (_categories
        .where((element) =>
            element.name == "Transfer" &&
            element.associatedType == TransactionType.transfer)
        .isEmpty) {
      addCategory(
        TransactionCategory(
          name: "Transfer",
          color: getTransactionTypeColor(TransactionType.transfer).value,
          associatedType: TransactionType.transfer,
        ),
      );
    }
  }

  @override
  Future<void> clean() async {
    await Future.wait([
      HiveUtils.categoryBox.clear(),
      HiveUtils.subCategoryBox.clear(),
      HiveUtils.accountBox.clear(),
      HiveUtils.paymentMethodBox.clear(),
      HiveUtils.payerBox.clear(),
      HiveUtils.refFileBox.clear(),
      HiveUtils.transactionBox.clear(),
      HiveUtils.breakPointBox.clear(),
    ]);

    _categories.clear();
    _subCategories.clear();
    _accounts.clear();
    _paymentMethods.clear();
    _payeers.clear();
    _refFiles.clear();
    _transactions.clear();
    _breakpoints.clear();

    calculateThisMonthTransactions();

    notifyListeners();
  }

  @override
  void save() {}

  @override
  Future<void> addAccount(Account account) async {
    HiveUtils.accountBox.put(account.name, account);

    _accounts = HiveUtils.accountBox.values.toList();

    notifyListeners();
  }

  String getCategoryKey(TransactionCategory category) {
    return "${category.name}-${category.associatedType}";
  }

  @override
  Future<void> addCategory(TransactionCategory category) async {
    await HiveUtils.categoryBox.put(getCategoryKey(category), category);

    _categories = HiveUtils.categoryBox.values.toList();

    notifyListeners();
  }

  @override
  Future<void> addPayer(PayerPayee payerPayee) async {
    HiveUtils.payerBox.put(payerPayee.name, payerPayee);

    _payeers = HiveUtils.payerBox.values.toList();

    notifyListeners();
  }

  @override
  Future<void> addPaymentMethod(PaymentMethod method) async {
    HiveUtils.paymentMethodBox.put(method.name, method);

    _paymentMethods = HiveUtils.paymentMethodBox.values.toList();

    notifyListeners();
  }

  @override
  Future<void> addRefFile(RefFile file) async {}

  @override
  Future<void> addSubCategory(SubCategory subCategory) async {
    HiveUtils.subCategoryBox.put(subCategory.name, subCategory);

    _subCategories = HiveUtils.subCategoryBox.values.toList();

    notifyListeners();
  }

  @override
  Future<void> updateTransaction(
      Transaction oldTransaction, Transaction newTransaction) async {
    await deleteTransaction(oldTransaction);

    addTransaction(newTransaction);
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    transaction.category = transaction.category!.nullForEmpty();
    transaction.subCategory = transaction.subCategory!.nullForEmpty();
    transaction.toAccount = transaction.toAccount!.nullForEmpty();
    transaction.paymentMethod = transaction.paymentMethod!.nullForEmpty();
    transaction.payerPayee = transaction.payerPayee!.nullForEmpty();
    transaction.remarks = transaction.remarks!.nullForEmpty();
    transaction.refFiles =
        transaction.refFiles!.isEmpty ? null : transaction.refFiles;
    transaction.amount = transaction.amount.withPrecision();

    transaction.date = MyDateUtils.dateWithPrecision(transaction.date);

    // check account
    var account = HiveUtils.accountBox.get(transaction.account);
    var b = transaction.balance ??
        getTransactionSign(transaction.transactionType) * transaction.amount;

    b = b.withPrecision();

    // new account
    if (account == null) {
      await addAccount(Account(
        name: transaction.account,
        canDelete: false,
      ));

      account = HiveUtils.accountBox.get(transaction.account);
    }
    // existing account
    else {
      account.canDelete = false;
      account.balance += b;
      await account.save();
    }

    if (transaction.transactionType == TransactionType.transfer) {
      var toAccount = HiveUtils.accountBox.get(transaction.toAccount);
      // new account
      if (toAccount == null) {
        await addAccount(Account(
          name: transaction.account,
          canDelete: false,
        ));
      }
      // existing account
      else {
        toAccount.canDelete = false;
        toAccount.balance += transaction.balance2 ?? transaction.amount;
        toAccount.balance = toAccount.balance.withPrecision();

        await toAccount.save();
      }
    }

    // check category
    if (transaction.category != null) {
      var category = HiveUtils.categoryBox
          .get("${transaction.category}-${transaction.transactionType}");
      // new category
      if (category == null) {
        await addCategory(TransactionCategory(
          name: transaction.category!,
          associatedType: transaction.transactionType,
          canDelete: false,
          color: getRandomColor(
            transaction.transactionType == TransactionType.income,
          ).value,
        ));
      }
      // existing category
      else {
        category.canDelete = false;
        await category.save();
      }
    }

    // check subCategory
    if (transaction.subCategory != null) {
      var subCategory = HiveUtils.subCategoryBox.get(transaction.subCategory);
      // new subCategory
      if (subCategory == null) {
        await addSubCategory(SubCategory(
          name: transaction.subCategory!,
          associatedType: transaction.transactionType,
          canDelete: false,
        ));
      }
      // existing subCategory
      else {
        subCategory.canDelete = false;
        await subCategory.save();
      }
    }

    // check paymentMethod
    if (transaction.paymentMethod != null) {
      var paymentMethod =
          HiveUtils.paymentMethodBox.get(transaction.paymentMethod);
      // new paymentMethod
      if (paymentMethod == null) {
        await addPaymentMethod(PaymentMethod(
          name: transaction.paymentMethod!,
          canDelete: false,
        ));
      }
      // existing paymentMethod
      else {
        paymentMethod.canDelete = false;
        await paymentMethod.save();
      }
    }

    // check payerPayee
    if (transaction.payerPayee != null) {
      var payer = HiveUtils.payerBox.get(transaction.payerPayee);
      // new payerPayee
      if (payer == null) {
        await addPayer(PayerPayee(
          name: transaction.payerPayee!,
          balance: b.withPrecision(),
          canDelete: false,
        ));
      }
      // existing payerPayee
      else {
        payer.canDelete = false;
        payer.balance += b;
        payer.balance = payer.balance.withPrecision();
        await payer.save();
      }
    }

    if (transaction.refFiles != null) {
      for (var f in transaction.refFiles!) {
        var ext = p.extension(f.path);
        var newName = const Uuid().v1() + ext;

        var newPath = p.join(AppUtils.dbPath, "files", newName);

        await IOUtils.copyFile(f.path, newPath);

        f.path = newPath;
      }
    }

    // update balances
    var accountTransactions = transactions.where((element) {
      return element.account == transaction.account ||
          element.toAccount == transaction.account;
    });

    var amountDiff =
        getTransactionSign(transaction.transactionType) * transaction.amount;

    amountDiff = amountDiff.withPrecision();

    // first transaction in this account
    if (accountTransactions.isEmpty) {
      transaction.balance = account!.balance.withPrecision();
    } else if (accountTransactions.first.date.isAfter(transaction.date)) {
      transaction.balance = accountTransactions.first.balance! +
          accountTransactions.first.amount *
              -getTransactionSign(accountTransactions.first.transactionType);
      transaction.balance = transaction.balance!.withPrecision();
    }

    for (var t in accountTransactions) {
      if (t.date.isBefore(transaction.date)) {
        if (t.transactionType == TransactionType.transfer &&
            t.toAccount == transaction.account) {
          transaction.balance = (t.balance2! + amountDiff).withPrecision();
        } else {
          transaction.balance = t.balance! + amountDiff;
          transaction.balance = transaction.balance!.withPrecision();
        }
      }

      if (t.date.isAfter(transaction.date)) {
        if (t.transactionType == TransactionType.transfer &&
            t.toAccount == transaction.account) {
          transaction.balance = (t.balance2! + amountDiff).withPrecision();
        } else {
          t.balance = t.balance! + amountDiff;
          t.balance = t.balance!.withPrecision();
          await t.save();
        }
      }
    }

    if (transaction.transactionType == TransactionType.transfer) {
      // receives amount
      var toAccount = HiveUtils.accountBox.get(transaction.toAccount);
      // update balances
      var accountTransactions = transactions
          .where((element) => element.account == transaction.toAccount);

      var amountDiff = transaction.amount.withPrecision();

      // first transaction in this account
      if (accountTransactions.isEmpty) {
        transaction.balance2 = toAccount!.balance.withPrecision();
      } else if (accountTransactions.first.date.isAfter(transaction.date)) {
        transaction.balance2 = amountDiff.withPrecision();

        // transaction.balance2 = accountTransactions.first.balance! +
        //     accountTransactions.first.amount *
        //         -getTransactionSign(accountTransactions.first.transactionType);
      }

      for (var t in accountTransactions) {
        if (t.date.isBefore(transaction.date)) {
          transaction.balance2 = t.balance! + amountDiff;
          transaction.balance2 = transaction.balance2!.withPrecision();
        }

        if (t.date.isAfter(transaction.date)) {
          t.balance = t.balance! + amountDiff;
          t.balance2 = t.balance2!.withPrecision();
          await t.save();
        }
      }
    }

    var key = transaction.date.toString();
    await HiveUtils.transactionBox.put(key, transaction);

    _transactions = HiveUtils.transactionBox.values.toList();

    calculateThisMonthTransactions();

    notifyListeners();
  }

  @override
  Future<void> deleteAccount(Account account) async {}

  @override
  Future<void> deleteCategory(TransactionCategory category) async {
    await category.delete();

    _categories = HiveUtils.categoryBox.values.toList();
    notifyListeners();
  }

  @override
  Future<void> deletePayer(PayerPayee payerPayee) async {}

  @override
  Future<void> deletePaymentMethod(PaymentMethod method) async {
    await method.delete();
    _paymentMethods = HiveUtils.paymentMethodBox.values.toList();
    notifyListeners();
  }

  @override
  void deleteRefFile() {}

  @override
  void deleteSubCategory() {}

  @override
  Future<void> deleteTransaction(Transaction transaction) async {
    var amountDiff =
        -getTransactionSign(transaction.transactionType) * transaction.amount;

    amountDiff = amountDiff.withPrecision();

    var account = HiveUtils.accountBox.get(transaction.account);
    if (account != null) {
      account.balance += amountDiff;
      account.save();
    }
    if (transaction.payerPayee != null) {
      var payer = HiveUtils.payerBox.get(transaction.payerPayee);
      if (payer != null) {
        payer.balance += amountDiff;
        payer.save();
      }
    }

    for (var t in transactions) {
      if (t.date.isAfter(transaction.date) &&
          t.account == transaction.account) {
        t.balance = t.balance! + amountDiff;
        await t.save();
      }
    }

    // update balance for transfers
    if (transaction.transactionType == TransactionType.transfer) {
      var toAccount = HiveUtils.accountBox.get(transaction.toAccount);
      if (toAccount != null) {
        toAccount.balance -= transaction.amount.withPrecision();
        toAccount.save();
      }

      for (var t in transactions) {
        if (t.date.isAfter(transaction.date) &&
            t.account == transaction.toAccount) {
          t.balance = t.balance! - transaction.amount.withPrecision();
          await t.save();
        }
      }
    }

    // delete refFiles if exists
    if (transaction.refFiles != null) {
      for (var file in transaction.refFiles!) {
        IOUtils.deleteFile(file.path);
      }
    }

    await HiveUtils.transactionBox.delete(transaction.date.toString());

    _transactions = HiveUtils.transactionBox.values.toList();

    calculateThisMonthTransactions();
    notifyListeners();
  }

  @override
  Future<void> addBreakPoint(BreakPoint breakpoint) async {
    var key = MyDateUtils.dateWithPrecision(breakpoint.date);
    await HiveUtils.breakPointBox.put(key.toString(), breakpoint);
    _breakpoints = HiveUtils.breakPointBox.values.toList();

    notifyListeners();
  }

  @override
  Future<void> deleteBreakPoint(BreakPoint breakpoint) async {
    await breakpoint.delete();
    // var key = MyDateUtils.dateWithPrecision(breakpoint.date);
    // await HiveUtils.breakPointBox.delete(key.toString());
    _breakpoints = HiveUtils.breakPointBox.values.toList();
    notifyListeners();
  }
}
