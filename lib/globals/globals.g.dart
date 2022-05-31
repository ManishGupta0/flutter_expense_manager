// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'globals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 9;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.all;
      case 1:
        return TransactionType.income;
      case 2:
        return TransactionType.expense;
      case 3:
        return TransactionType.transfer;
      default:
        return TransactionType.all;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.all:
        writer.writeByte(0);
        break;
      case TransactionType.income:
        writer.writeByte(1);
        break;
      case TransactionType.expense:
        writer.writeByte(2);
        break;
      case TransactionType.transfer:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MonthsNameAdapter extends TypeAdapter<MonthsName> {
  @override
  final int typeId = 10;

  @override
  MonthsName read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MonthsName.january;
      case 1:
        return MonthsName.february;
      case 2:
        return MonthsName.march;
      case 3:
        return MonthsName.april;
      case 4:
        return MonthsName.may;
      case 5:
        return MonthsName.june;
      case 6:
        return MonthsName.july;
      case 7:
        return MonthsName.august;
      case 8:
        return MonthsName.september;
      case 9:
        return MonthsName.october;
      case 10:
        return MonthsName.november;
      case 11:
        return MonthsName.december;
      default:
        return MonthsName.january;
    }
  }

  @override
  void write(BinaryWriter writer, MonthsName obj) {
    switch (obj) {
      case MonthsName.january:
        writer.writeByte(0);
        break;
      case MonthsName.february:
        writer.writeByte(1);
        break;
      case MonthsName.march:
        writer.writeByte(2);
        break;
      case MonthsName.april:
        writer.writeByte(3);
        break;
      case MonthsName.may:
        writer.writeByte(4);
        break;
      case MonthsName.june:
        writer.writeByte(5);
        break;
      case MonthsName.july:
        writer.writeByte(6);
        break;
      case MonthsName.august:
        writer.writeByte(7);
        break;
      case MonthsName.september:
        writer.writeByte(8);
        break;
      case MonthsName.october:
        writer.writeByte(9);
        break;
      case MonthsName.november:
        writer.writeByte(10);
        break;
      case MonthsName.december:
        writer.writeByte(11);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthsNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DaysNameAdapter extends TypeAdapter<DaysName> {
  @override
  final int typeId = 11;

  @override
  DaysName read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DaysName.sunday;
      case 1:
        return DaysName.monday;
      case 2:
        return DaysName.tuesday;
      case 3:
        return DaysName.wednesday;
      case 4:
        return DaysName.thursday;
      case 5:
        return DaysName.friday;
      case 6:
        return DaysName.saturday;
      default:
        return DaysName.sunday;
    }
  }

  @override
  void write(BinaryWriter writer, DaysName obj) {
    switch (obj) {
      case DaysName.sunday:
        writer.writeByte(0);
        break;
      case DaysName.monday:
        writer.writeByte(1);
        break;
      case DaysName.tuesday:
        writer.writeByte(2);
        break;
      case DaysName.wednesday:
        writer.writeByte(3);
        break;
      case DaysName.thursday:
        writer.writeByte(4);
        break;
      case DaysName.friday:
        writer.writeByte(5);
        break;
      case DaysName.saturday:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DaysNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
