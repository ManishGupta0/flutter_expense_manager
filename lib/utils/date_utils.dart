import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_expense_manager/globals/globals.dart';

class MyDateUtils {
  static String getFormattedDate(
    date, {
    String? dateFormat,
    String? timeFormat,
  }) {
    var format = dateFormat ?? "";
    if (format.isNotEmpty) {
      format += " ";
    }
    format += timeFormat ?? "";

    return DateFormat(format).format(date);
  }

  static DateTime dateWithPrecision(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
    );
  }

  static DateTimeRange getDayRange(DateTime date) {
    var start = DateTime(date.year, date.month, date.day);
    var end = start
        .add(const Duration(days: 1))
        .subtract(const Duration(microseconds: 1));

    return DateTimeRange(start: start, end: end);
  }

  static DateTimeRange getWeekRange(DateTime date, DaysName firstDay) {
    var weekDay = date.weekday % 7;
    var diffDay = weekDay - firstDay.index;
    if (diffDay < 0) {
      diffDay += 7;
    }

    var start = date.subtract(Duration(days: diffDay));
    start = DateTime(start.year, start.month, start.day);

    var end = start
        .add(const Duration(days: 7))
        .subtract(const Duration(microseconds: 1));

    return DateTimeRange(start: start, end: end);
  }

  static DateTimeRange getMonthRange(DateTime date, int firstDate) {
    var start = date;
    var end = date;

    var diffDay = date.day - firstDate + 1;

    if (diffDay >= 0) {
      start = DateTime(date.year, date.month, firstDate);
      end = DateTime(date.year, date.month + 1, firstDate);
    } else {
      start = DateTime(date.year, date.month - 1, firstDate);
      end = DateTime(date.year, date.month, firstDate);
    }

    end = end
        .add(const Duration(days: 1))
        .subtract(const Duration(microseconds: 1));
    return DateTimeRange(start: start, end: end);
  }

  static DateTimeRange getYearRange(DateTime date, MonthsName firstMonth) {
    var diffMonth = date.month - firstMonth.index + 1;
    var start = date;
    var end = date;
    if (diffMonth >= 0) {
      start = DateTime(date.year, firstMonth.index + 1);
      end = DateTime(date.year + 1, firstMonth.index + 1);
    } else {
      start = DateTime(date.year - 1, firstMonth.index + 1);
      end = DateTime(date.year, firstMonth.index + 1);
    }
    end = end
        .add(const Duration(days: 1))
        .subtract(const Duration(microseconds: 1));

    return DateTimeRange(start: start, end: end);
  }
}
