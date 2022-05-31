import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_expense_manager/globals/constants.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

part 'expense_model.g.dart';

abstract class Jsonable {
  Map<String, dynamic> toJson();
}

@JsonSerializable()
@HiveType(typeId: HiveTypeID.transactionCategory)
class TransactionCategory extends HiveObject with Jsonable {
  TransactionCategory({
    required this.name,
    this.canDelete = true,
    this.associatedType = TransactionType.income,
    this.color = 4294967295,
  }) : date = DateTime.now();
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  String name;
  @HiveField(2)
  bool canDelete;
  @HiveField(3)
  TransactionType associatedType;
  @HiveField(4)
  int color;

  factory TransactionCategory.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategoryFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionCategoryToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveTypeID.subCategory)
class SubCategory extends TransactionCategory {
  SubCategory({
    required String name,
    bool canDelete = true,
    TransactionType associatedType = TransactionType.income,
  }) : super(name: name, canDelete: canDelete, associatedType: associatedType);

  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveTypeID.account)
class Account extends HiveObject with Jsonable {
  Account({
    required this.name,
    this.type,
    this.balance = 0.0,
    this.canDelete = true,
  })  : date = DateTime.now(),
        color = getRandomColor();

  @HiveField(0)
  DateTime date;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? type;
  @HiveField(3)
  double balance;
  @HiveField(4)
  bool canDelete;

  @JsonKey(ignore: true)
  Color color;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveTypeID.paymentMethod)
class PaymentMethod extends HiveObject with Jsonable {
  PaymentMethod({
    required this.name,
    this.canDelete = true,
  }) : date = DateTime.now();

  @HiveField(0)
  DateTime date;
  @HiveField(1)
  String name;
  @HiveField(2)
  bool canDelete;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveTypeID.payerPayee)
class PayerPayee extends Account {
  PayerPayee({
    required String name,
    String? type,
    double balance = 0.0,
    bool canDelete = true,
  }) : super(name: name, type: type, balance: balance, canDelete: canDelete);

  factory PayerPayee.fromJson(Map<String, dynamic> json) =>
      _$PayerPayeeFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PayerPayeeToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveTypeID.refFile)
class RefFile extends HiveObject with Jsonable {
  RefFile({required this.path, required this.fileType}) : date = DateTime.now();

  @HiveField(0)
  DateTime date;
  @HiveField(1)
  String path;
  @HiveField(2)
  String fileType;

  factory RefFile.fromJson(Map<String, dynamic> json) =>
      _$RefFileFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$RefFileToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveTypeID.transaction)
class Transaction extends HiveObject with Jsonable {
  Transaction({
    required this.transactionType,
    required this.date,
    required this.account,
    required this.amount,
    this.toAccount,
    this.category,
    this.subCategory,
    this.paymentMethod,
    this.payerPayee,
    this.remarks,
    this.refFiles,
    this.balance,
    this.balance2,
  });

  factory Transaction.withDefaultValues() => Transaction(
        transactionType: TransactionType.income,
        date: DateTime(2020, 02, 04, 01, 02, 03),
        account: "Bank",
        amount: 10.0,
        category: "Category 0",
        subCategory: "Sub Category",
        paymentMethod: "Cash",
        payerPayee: "Payer",
        remarks: "This is Remarks",
        balance: 100.0,
      );

  @HiveField(0)
  TransactionType transactionType;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  String? category;
  @HiveField(3)
  String? subCategory;
  @HiveField(4)
  String account;
  @HiveField(5)
  String? toAccount;
  @HiveField(6)
  String? paymentMethod;
  @HiveField(7)
  String? payerPayee;
  @HiveField(8)
  double amount;
  @HiveField(9)
  double? balance;
  @HiveField(10)
  double? balance2;
  @HiveField(11)
  String? remarks;
  @HiveField(12)
  List<RefFile>? refFiles;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveTypeID.breakPoint)
class BreakPoint extends HiveObject with Jsonable {
  BreakPoint({
    required this.date,
    required this.breakPointName,
  });

  @HiveField(0)
  DateTime date;
  @HiveField(1)
  String breakPointName;

  factory BreakPoint.fromJson(Map<String, dynamic> json) =>
      _$BreakPointFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$BreakPointToJson(this);
}

@JsonSerializable()
class ExpenseModel {
  ExpenseModel({
    this.categories = const [],
    this.subCategories = const [],
    this.accounts = const [],
    this.paymentMethods = const [],
    this.payeers = const [],
    this.refFiles = const [],
    this.transactions = const [],
    this.breakpoints = const [],
  });

  List<TransactionCategory> categories = [];
  List<SubCategory> subCategories = [];
  List<Account> accounts = [];
  List<PaymentMethod> paymentMethods = [];
  List<PayerPayee> payeers = [];
  List<RefFile> refFiles = [];
  List<Transaction> transactions = [];
  List<BreakPoint> breakpoints = [];

  List<Transaction> transactionThisMonth = [];

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);
}
