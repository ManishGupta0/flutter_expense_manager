import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_expense_manager/globals/constants.dart';

part 'globals.g.dart';

final GlobalKey<ScaffoldMessengerState> globalSnackbarKey =
    GlobalKey<ScaffoldMessengerState>();

@HiveType(typeId: HiveTypeID.transactionType)
enum TransactionType {
  @HiveField(0)
  all,
  @HiveField(1)
  income,
  @HiveField(2)
  expense,
  @HiveField(3)
  transfer,
}

@HiveType(typeId: HiveTypeID.monthsName)
enum MonthsName {
  @HiveField(0)
  january,
  @HiveField(1)
  february,
  @HiveField(2)
  march,
  @HiveField(3)
  april,
  @HiveField(4)
  may,
  @HiveField(5)
  june,
  @HiveField(6)
  july,
  @HiveField(7)
  august,
  @HiveField(8)
  september,
  @HiveField(9)
  october,
  @HiveField(10)
  november,
  @HiveField(11)
  december,
}

@HiveType(typeId: HiveTypeID.daysName)
enum DaysName {
  @HiveField(0)
  sunday,
  @HiveField(1)
  monday,
  @HiveField(2)
  tuesday,
  @HiveField(3)
  wednesday,
  @HiveField(4)
  thursday,
  @HiveField(5)
  friday,
  @HiveField(6)
  saturday,
}

List<String> dateFormats = [
  "EEE MMM d, yyyy",
  "MMM d, yyyy",
  "yyyy-MM-dd",
  "MM-dd-yyyy",
  "dd-MM-yyyy",
  "yyyy/MM/dd",
  "MM/dd/yyyy",
  "dd/MM/yyyy",
];

List<String> timeFormats = [
  "h:mm a",
  "H:mm a",
  "h:mm:ss a",
  "H:mm:ss a",
];

enum DateSpan {
  day,
  week,
  month,
  year,
}

enum TimeSpan {
  microsecond,
  millisecond,
  second,
  minute,
  hour,
}
