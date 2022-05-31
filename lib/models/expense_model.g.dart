// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionCategoryAdapter extends TypeAdapter<TransactionCategory> {
  @override
  final int typeId = 1;

  @override
  TransactionCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionCategory(
      name: fields[1] as String,
      canDelete: fields[2] as bool,
      associatedType: fields[3] as TransactionType,
      color: fields[4] as int,
    )..date = fields[0] as DateTime;
  }

  @override
  void write(BinaryWriter writer, TransactionCategory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.canDelete)
      ..writeByte(3)
      ..write(obj.associatedType)
      ..writeByte(4)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubCategoryAdapter extends TypeAdapter<SubCategory> {
  @override
  final int typeId = 2;

  @override
  SubCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubCategory(
      name: fields[1] as String,
      canDelete: fields[2] as bool,
      associatedType: fields[3] as TransactionType,
    )
      ..date = fields[0] as DateTime
      ..color = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, SubCategory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.canDelete)
      ..writeByte(3)
      ..write(obj.associatedType)
      ..writeByte(4)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final int typeId = 3;

  @override
  Account read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Account(
      name: fields[1] as String,
      type: fields[2] as String?,
      balance: fields[3] as double,
      canDelete: fields[4] as bool,
    )..date = fields[0] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.canDelete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentMethodAdapter extends TypeAdapter<PaymentMethod> {
  @override
  final int typeId = 4;

  @override
  PaymentMethod read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentMethod(
      name: fields[1] as String,
      canDelete: fields[2] as bool,
    )..date = fields[0] as DateTime;
  }

  @override
  void write(BinaryWriter writer, PaymentMethod obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.canDelete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PayerPayeeAdapter extends TypeAdapter<PayerPayee> {
  @override
  final int typeId = 5;

  @override
  PayerPayee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PayerPayee(
      name: fields[1] as String,
      type: fields[2] as String?,
      balance: fields[3] as double,
      canDelete: fields[4] as bool,
    )..date = fields[0] as DateTime;
  }

  @override
  void write(BinaryWriter writer, PayerPayee obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.canDelete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayerPayeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RefFileAdapter extends TypeAdapter<RefFile> {
  @override
  final int typeId = 6;

  @override
  RefFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RefFile(
      path: fields[1] as String,
      fileType: fields[2] as String,
    )..date = fields[0] as DateTime;
  }

  @override
  void write(BinaryWriter writer, RefFile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.fileType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 7;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      transactionType: fields[0] as TransactionType,
      date: fields[1] as DateTime,
      account: fields[4] as String,
      amount: fields[8] as double,
      toAccount: fields[5] as String?,
      category: fields[2] as String?,
      subCategory: fields[3] as String?,
      paymentMethod: fields[6] as String?,
      payerPayee: fields[7] as String?,
      remarks: fields[11] as String?,
      refFiles: (fields[12] as List?)?.cast<RefFile>(),
      balance: fields[9] as double?,
      balance2: fields[10] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.transactionType)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.subCategory)
      ..writeByte(4)
      ..write(obj.account)
      ..writeByte(5)
      ..write(obj.toAccount)
      ..writeByte(6)
      ..write(obj.paymentMethod)
      ..writeByte(7)
      ..write(obj.payerPayee)
      ..writeByte(8)
      ..write(obj.amount)
      ..writeByte(9)
      ..write(obj.balance)
      ..writeByte(10)
      ..write(obj.balance2)
      ..writeByte(11)
      ..write(obj.remarks)
      ..writeByte(12)
      ..write(obj.refFiles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BreakPointAdapter extends TypeAdapter<BreakPoint> {
  @override
  final int typeId = 8;

  @override
  BreakPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreakPoint(
      date: fields[0] as DateTime,
      breakPointName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BreakPoint obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.breakPointName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCategory _$TransactionCategoryFromJson(Map<String, dynamic> json) =>
    TransactionCategory(
      name: json['name'] as String,
      canDelete: json['canDelete'] as bool? ?? true,
      associatedType: $enumDecodeNullable(
              _$TransactionTypeEnumMap, json['associatedType']) ??
          TransactionType.income,
      color: json['color'] as int? ?? 4294967295,
    )..date = DateTime.parse(json['date'] as String);

Map<String, dynamic> _$TransactionCategoryToJson(
        TransactionCategory instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'canDelete': instance.canDelete,
      'associatedType': _$TransactionTypeEnumMap[instance.associatedType],
      'color': instance.color,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.all: 'all',
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
  TransactionType.transfer: 'transfer',
};

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) => SubCategory(
      name: json['name'] as String,
      canDelete: json['canDelete'] as bool? ?? true,
      associatedType: $enumDecodeNullable(
              _$TransactionTypeEnumMap, json['associatedType']) ??
          TransactionType.income,
    )
      ..date = DateTime.parse(json['date'] as String)
      ..color = json['color'] as int;

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'canDelete': instance.canDelete,
      'associatedType': _$TransactionTypeEnumMap[instance.associatedType],
      'color': instance.color,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      name: json['name'] as String,
      type: json['type'] as String?,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      canDelete: json['canDelete'] as bool? ?? true,
    )..date = DateTime.parse(json['date'] as String);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'type': instance.type,
      'balance': instance.balance,
      'canDelete': instance.canDelete,
    };

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      name: json['name'] as String,
      canDelete: json['canDelete'] as bool? ?? true,
    )..date = DateTime.parse(json['date'] as String);

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'canDelete': instance.canDelete,
    };

PayerPayee _$PayerPayeeFromJson(Map<String, dynamic> json) => PayerPayee(
      name: json['name'] as String,
      type: json['type'] as String?,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      canDelete: json['canDelete'] as bool? ?? true,
    )..date = DateTime.parse(json['date'] as String);

Map<String, dynamic> _$PayerPayeeToJson(PayerPayee instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'type': instance.type,
      'balance': instance.balance,
      'canDelete': instance.canDelete,
    };

RefFile _$RefFileFromJson(Map<String, dynamic> json) => RefFile(
      path: json['path'] as String,
      fileType: json['fileType'] as String,
    )..date = DateTime.parse(json['date'] as String);

Map<String, dynamic> _$RefFileToJson(RefFile instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'path': instance.path,
      'fileType': instance.fileType,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      date: DateTime.parse(json['date'] as String),
      account: json['account'] as String,
      amount: (json['amount'] as num).toDouble(),
      toAccount: json['toAccount'] as String?,
      category: json['category'] as String?,
      subCategory: json['subCategory'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      payerPayee: json['payerPayee'] as String?,
      remarks: json['remarks'] as String?,
      refFiles: (json['refFiles'] as List<dynamic>?)
          ?.map((e) => RefFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      balance: (json['balance'] as num?)?.toDouble(),
      balance2: (json['balance2'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType],
      'date': instance.date.toIso8601String(),
      'category': instance.category,
      'subCategory': instance.subCategory,
      'account': instance.account,
      'toAccount': instance.toAccount,
      'paymentMethod': instance.paymentMethod,
      'payerPayee': instance.payerPayee,
      'amount': instance.amount,
      'balance': instance.balance,
      'balance2': instance.balance2,
      'remarks': instance.remarks,
      'refFiles': instance.refFiles,
    };

BreakPoint _$BreakPointFromJson(Map<String, dynamic> json) => BreakPoint(
      date: DateTime.parse(json['date'] as String),
      breakPointName: json['breakPointName'] as String,
    );

Map<String, dynamic> _$BreakPointToJson(BreakPoint instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'breakPointName': instance.breakPointName,
    };

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) => ExpenseModel(
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) =>
                  TransactionCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subCategories: (json['subCategories'] as List<dynamic>?)
              ?.map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
              ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      payeers: (json['payeers'] as List<dynamic>?)
              ?.map((e) => PayerPayee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      refFiles: (json['refFiles'] as List<dynamic>?)
              ?.map((e) => RefFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      breakpoints: (json['breakpoints'] as List<dynamic>?)
              ?.map((e) => BreakPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..transactionThisMonth = (json['transactionThisMonth'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ExpenseModelToJson(ExpenseModel instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'subCategories': instance.subCategories,
      'accounts': instance.accounts,
      'paymentMethods': instance.paymentMethods,
      'payeers': instance.payeers,
      'refFiles': instance.refFiles,
      'transactions': instance.transactions,
      'breakpoints': instance.breakpoints,
      'transactionThisMonth': instance.transactionThisMonth,
    };
