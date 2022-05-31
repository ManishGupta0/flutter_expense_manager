import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/utils/chart_utils.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

enum AnalysisReportPrecision {
  hourly,
  daily,
  monthly,
}

class AnalysisReport {
  AnalysisReport({
    required this.dateRange,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalAmount,
    required this.reportInterval,
    required this.transactions,
    required this.closingBalanceData,
    required this.categorywiseIncome,
    required this.categorywiseExpense,
    required this.incomeWisePaymentMethod,
    required this.expenseWisePaymentMethod,
  });
  final DateTimeRange dateRange;
  final double totalIncome;
  final double totalExpense;
  final double totalAmount;
  final AnalysisReportPrecision reportInterval;
  final List<Transaction> transactions;

  final ChartData closingBalanceData;
  final ChartData categorywiseIncome;
  final ChartData categorywiseExpense;
  final ChartData incomeWisePaymentMethod;
  final ChartData expenseWisePaymentMethod;

  factory AnalysisReport.createReport({
    required DateTimeRange dateRange,
    required AnalysisReportPrecision reportPrecision,
    required List<Transaction> transactions,
    required List<TransactionCategory> categories,
  }) {
    transactions = _filterTransaction(transactions, dateRange);

    // calculate income, expense and total amount
    var incomeAmount = 0.0;
    var expenseAmount = 0.0;

    ChartData incomeCategoriesData = ChartData(datas: []);
    ChartData expenseCategoriesData = ChartData(datas: []);
    ChartData incomeWisePaymentMethod = ChartData(datas: []);
    ChartData expenseWisePaymentMethod = ChartData(datas: []);

    for (var transaction in transactions) {
      TransactionCategory? cat;
      var c = categories.where(
        (element) => element.name == transaction.category,
      );

      if (c.isEmpty) {
        cat = null;
      } else {
        cat = c.first;
      }

      var catColor = cat == null ? Colors.white : Color(cat.color);

      if (transaction.transactionType == TransactionType.income) {
        incomeAmount += transaction.amount;
      }
      if (transaction.transactionType == TransactionType.expense) {
        expenseAmount += transaction.amount;
      }

      // for category chart
      if (transaction.transactionType == TransactionType.income) {
        incomeCategoriesData.datas.add(
          SingleChartItem(
            title: transaction.category ?? "Not Specified",
            color: catColor,
            datas: [ChartPoint(0.0, transaction.amount)],
          ),
        );
        incomeWisePaymentMethod.datas.add(
          SingleChartItem(
            title: transaction.paymentMethod ?? "Not Specified",
            color: getRandomColor(),
            datas: [ChartPoint(0.0, transaction.amount)],
          ),
        );
      } else if (transaction.transactionType == TransactionType.expense) {
        expenseCategoriesData.datas.add(
          SingleChartItem(
            title: transaction.category ?? "Not Specified",
            color: catColor,
            datas: [ChartPoint(0.0, transaction.amount)],
          ),
        );

        expenseWisePaymentMethod.datas.add(
          SingleChartItem(
            title: transaction.paymentMethod ?? "Not Specified",
            color: getRandomColor(),
            datas: [ChartPoint(0.0, transaction.amount)],
          ),
        );
      }
    }

    var totalAmount = incomeAmount + expenseAmount;

    // calculate category wise income and expense
    var i = ChartUtils.reduceElements(incomeCategoriesData);
    incomeCategoriesData = i;

    var e = ChartUtils.reduceElements(expenseCategoriesData);
    expenseCategoriesData = e;

    var ip = ChartUtils.reduceElements(incomeWisePaymentMethod);
    incomeWisePaymentMethod = ip;

    var ep = ChartUtils.reduceElements(expenseWisePaymentMethod);
    expenseWisePaymentMethod = ep;

    ChartData closingBalanceData = ChartData(datas: []);
    closingBalanceData = getChartData(
      transactions,
      dateRange,
      reportPrecision,
    );

    return AnalysisReport(
      dateRange: dateRange,
      totalIncome: incomeAmount.withPrecision(),
      totalExpense: expenseAmount.withPrecision(),
      totalAmount: totalAmount.withPrecision(),
      reportInterval: reportPrecision,
      transactions: transactions,
      closingBalanceData: closingBalanceData,
      categorywiseIncome: incomeCategoriesData,
      categorywiseExpense: expenseCategoriesData,
      incomeWisePaymentMethod: incomeWisePaymentMethod,
      expenseWisePaymentMethod: expenseWisePaymentMethod,
    );
  }

  static List<Transaction> _filterTransaction(
    List<Transaction> transactions,
    DateTimeRange dateRange,
  ) {
    return transactions.where((element) {
      return element.date.isAfter(dateRange.start) &&
          element.date.isBefore(dateRange.end);
    }).toList();
  }

  static DateTime increaseDateTime(
    DateTime date,
    AnalysisReportPrecision precision,
  ) {
    switch (precision) {
      case AnalysisReportPrecision.hourly:
        return date.add(const Duration(
          minutes: 59,
          seconds: 59,
          milliseconds: 999,
          microseconds: 999,
        ));
      case AnalysisReportPrecision.daily:
        return date.add(const Duration(
          hours: 23,
          minutes: 59,
          seconds: 59,
          milliseconds: 999,
          microseconds: 999,
        ));
      case AnalysisReportPrecision.monthly:
        return DateTime(
          date.year,
          date.month + 1,
          date.day,
          date.hour,
          date.minute,
          date.second,
          date.millisecond,
          date.microsecond,
        ).subtract(const Duration(microseconds: 1));
    }
  }

  static String getXCoord(DateTime date, AnalysisReportPrecision precision) {
    switch (precision) {
      case AnalysisReportPrecision.hourly:
        return (date.hour + 1).toString();
      case AnalysisReportPrecision.daily:
        return date.day.toString();
      case AnalysisReportPrecision.monthly:
        return date.month.toString();
    }
  }

  static final Map<String, Color> _accountColors = {};

  static ChartData getChartData(
    List<Transaction> transactions,
    DateTimeRange range,
    AnalysisReportPrecision precision,
  ) {
    Map<String, SingleChartItem> chartMap = {};

    DateTime start = range.start;
    DateTime breakPoint = increaseDateTime(start, precision);

    var index = 0.0;

    while (breakPoint.isBefore(range.end)) {
      breakPoint = increaseDateTime(start, precision);
      var items = _filterTransaction(
        transactions,
        DateTimeRange(start: start, end: breakPoint),
      );

      Map<String, double> accountMap = {};

      for (var item in items) {
        accountMap[item.account] = item.balance!;
        if (!_accountColors.containsKey(item.account)) {
          _accountColors[item.account] = getRandomColor();
        }
      }

      for (var t in accountMap.entries) {
        if (!chartMap.containsKey(t.key)) {
          chartMap[t.key] = SingleChartItem(
            title: t.key,
            color: _accountColors[t.key]!,
            datas: [ChartPoint(index, t.value)],
          );

          // Fill values for index of 0 to index
          for (var i = 0; i < index; i++) {
            chartMap[t.key]!.datas.insert(
                  i,
                  ChartPoint(
                    i.toDouble(),
                    chartMap[t.key]!.datas.last.y,
                  ),
                );
          }
        } else {
          chartMap[t.key]!.datas.add(ChartPoint(index, t.value));
        }
      }

      // Add Blank Straight Line
      if (chartMap.length > accountMap.length) {
        for (var item in chartMap.entries) {
          if (!accountMap.containsKey(item.key)) {
            chartMap[item.key]!.datas.add(
                  ChartPoint(
                    index,
                    chartMap[item.key]!.datas.last.y,
                  ),
                );
          }
        }
      }

      start = breakPoint.add(const Duration(microseconds: 1));
      index++;
    }

    ChartData chartData = ChartData(datas: []);

    for (var item in chartMap.entries) {
      chartData.datas.add(item.value);
    }

    return chartData;
  }
}
