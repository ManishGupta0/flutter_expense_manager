import 'package:flutter/widgets.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';

abstract class ExpenseProvider extends ChangeNotifier {
  List<TransactionCategory> get categories;
  List<SubCategory> get subCategories;
  List<Account> get accounts;
  List<PaymentMethod> get paymentMethods;
  List<PayerPayee> get payeers;
  List<RefFile> get refFiles;
  List<Transaction> get transactions;
  List<BreakPoint> get breakpoints;

  List<Transaction> get transactionsThisMonth;

  void notify() {
    notifyListeners();
  }

  Future<String> export(String exportPath);
  Future<String> import(String importPath);

  void load();
  Future<void> doFirstInit();
  Future<void> clean();
  void save();

  Future<void> addCategory(TransactionCategory category);
  Future<void> deleteCategory(TransactionCategory category);

  Future<void> addSubCategory(SubCategory subCategory);
  void deleteSubCategory();

  Future<void> addAccount(Account account);
  Future<void> deleteAccount(Account account);

  Future<void> addPaymentMethod(PaymentMethod method);
  Future<void> deletePaymentMethod(PaymentMethod method);

  Future<void> addPayer(PayerPayee payerPayee);
  Future<void> deletePayer(PayerPayee payerPayee);

  Future<void> addRefFile(RefFile file);
  void deleteRefFile();

  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(
      Transaction oldTransaction, Transaction newTransaction);
  Future<void> deleteTransaction(Transaction transaction);

  Future<void> addBreakPoint(BreakPoint breakpoint);
  Future<void> deleteBreakPoint(BreakPoint breakpoint);
}
