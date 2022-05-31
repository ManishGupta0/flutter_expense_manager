import 'package:hive/hive.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/globals/constants.dart';
import 'package:flutter_expense_manager/models/settings_model.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';

class HiveUtils {
  static var _categoryBox = Hive.box<TransactionCategory>(Names.categoryBox);
  static var _subCategoryBox = Hive.box<SubCategory>(Names.subCategoryBox);
  static var _accountBox = Hive.box<Account>(Names.accountBox);
  static var _paymentMethodBox =
      Hive.box<PaymentMethod>(Names.paymentMethodBox);
  static var _payerBox = Hive.box<PayerPayee>(Names.payerBox);
  static var _refFileBox = Hive.box<RefFile>(Names.refFileBox);
  static var _transactionBox = Hive.box<Transaction>(Names.transactionBox);
  static var _breakPointBox = Hive.box<BreakPoint>(Names.breakPointBox);

  static Box<TransactionCategory> get categoryBox => _categoryBox;
  static Box<SubCategory> get subCategoryBox => _subCategoryBox;
  static Box<Account> get accountBox => _accountBox;
  static Box<PaymentMethod> get paymentMethodBox => _paymentMethodBox;
  static Box<PayerPayee> get payerBox => _payerBox;
  static Box<RefFile> get refFileBox => _refFileBox;
  static Box<Transaction> get transactionBox => _transactionBox;
  static Box<BreakPoint> get breakPointBox => _breakPointBox;

  static void init(String path) {
    Hive.init(path);
  }

  static Future<void> openBoxex() async {
    await Hive.openBox<SettingsModel>(Names.appSettingsBox);

    await Hive.openBox<TransactionType>(Names.transactionTypeBox);
    await Hive.openBox<TransactionCategory>(Names.categoryBox);
    await Hive.openBox<SubCategory>(Names.subCategoryBox);
    await Hive.openBox<Account>(Names.accountBox);
    await Hive.openBox<PaymentMethod>(Names.paymentMethodBox);
    await Hive.openBox<PayerPayee>(Names.payerBox);
    await Hive.openBox<RefFile>(Names.refFileBox);
    await Hive.openBox<Transaction>(Names.transactionBox);
    await Hive.openBox<BreakPoint>(Names.breakPointBox);

    _categoryBox = Hive.box<TransactionCategory>(Names.categoryBox);
    _subCategoryBox = Hive.box<SubCategory>(Names.subCategoryBox);
    _accountBox = Hive.box<Account>(Names.accountBox);
    _paymentMethodBox = Hive.box<PaymentMethod>(Names.paymentMethodBox);
    _payerBox = Hive.box<PayerPayee>(Names.payerBox);
    _refFileBox = Hive.box<RefFile>(Names.refFileBox);
    _transactionBox = Hive.box<Transaction>(Names.transactionBox);
    _breakPointBox = Hive.box<BreakPoint>(Names.breakPointBox);
  }

  static Future<void> closeBoxex() async {
    await Hive.close();
  }

  static Future<void> reOpen() async {
    await closeBoxex();
    await openBoxex();
  }

  static void registerAdapters() {
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(MonthsNameAdapter());
    Hive.registerAdapter(DaysNameAdapter());

    Hive.registerAdapter(SettingsModelAdapter());

    Hive.registerAdapter(TransactionCategoryAdapter());
    Hive.registerAdapter(SubCategoryAdapter());
    Hive.registerAdapter(AccountAdapter());
    Hive.registerAdapter(PaymentMethodAdapter());
    Hive.registerAdapter(PayerPayeeAdapter());
    Hive.registerAdapter(RefFileAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(BreakPointAdapter());
  }
}
