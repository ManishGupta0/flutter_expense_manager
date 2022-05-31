import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/analysis_report.dart';
import 'package:flutter_expense_manager/utils/date_utils.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';
import 'package:flutter_expense_manager/widgets/charts/chart_container.dart';
import 'package:flutter_expense_manager/widgets/charts/chart_legend.dart';
import 'package:flutter_expense_manager/widgets/charts/my_line_chart.dart';
import 'package:flutter_expense_manager/widgets/charts/my_pie_chart.dart';
import 'package:flutter_expense_manager/widgets/date_range_slider.dart';
import 'package:flutter_expense_manager/widgets/summery_container.dart';
import 'package:flutter_expense_manager/widgets/transaction_list_tile.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({
    Key? key,
    required this.sampleDate,
    this.analysisSpan = DateSpan.day,
    this.dateRange,
    this.isBreakpoint = false,
  }) : super(key: key);

  final DateSpan
      analysisSpan; // for date span analysis (day, week, month, year)
  final DateTime sampleDate; // used to get first date range
  final DateTimeRange? dateRange; // for custom analysis
  final bool isBreakpoint; // for breakpoint analysis

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late ExpenseProvider modelProvider;
  late SettingsProvider settingsProvider;

  late String title;
  late DateTime _date;

  late AnalysisReportPrecision precision;
  late AnalysisReport _report;

  late DateTimeRange? _dateRange;
  String? fromText, toText;
  late String dateFormat;

  Future<void> calculateData() async {
    _report = AnalysisReport.createReport(
      dateRange: _dateRange!,
      reportPrecision: precision,
      transactions: modelProvider.transactions,
      categories: modelProvider.categories,
    );

    if (_report.closingBalanceData.datas.isNotEmpty) {
      var span = widget.analysisSpan;

      if (_dateRange != null) {
        if (_dateRange!.duration.inHours < 25) {
          span = DateSpan.day;
        } else if (_dateRange!.duration.inDays > 32) {
          span = DateSpan.year;
        } else {
          span = DateSpan.week;
        }
      }
      switch (span) {
        case DateSpan.day:
          _report.closingBalanceData.xAxis = [];
          for (var element in _report.closingBalanceData.datas.first.datas) {
            var d = DateTime(
              _dateRange!.start.year,
              _dateRange!.start.month,
              _dateRange!.start.day,
              _dateRange!.start.hour + element.x.toInt(),
            );
            _report.closingBalanceData.xAxis!.add(
              MyDateUtils.getFormattedDate(d, dateFormat: "H"),
            );
          }
          break;
        case DateSpan.week:
          _report.closingBalanceData.xAxis = [];
          var index = 0;
          var count = _report.closingBalanceData.datas.first.datas.length;
          for (var element in _report.closingBalanceData.datas.first.datas) {
            var d = DateTime(
              _dateRange!.start.year,
              _dateRange!.start.month,
              _dateRange!.start.day + element.x.toInt(),
            );
            if (count > 10 && index % 2 == 0) {
              _report.closingBalanceData.xAxis!.add("");
            } else {
              _report.closingBalanceData.xAxis!.add(
                MyDateUtils.getFormattedDate(d, dateFormat: "d MMM"),
              );
            }
            index += 1;
          }
          break;
        case DateSpan.month:
          _report.closingBalanceData.xAxis = [];
          for (var element in _report.closingBalanceData.datas.first.datas) {
            var d = DateTime(
              _dateRange!.start.year,
              _dateRange!.start.month,
              _dateRange!.start.day + element.x.toInt(),
            );
            _report.closingBalanceData.xAxis!.add(
              MyDateUtils.getFormattedDate(d, dateFormat: "d"),
            );
          }
          break;
        case DateSpan.year:
          _report.closingBalanceData.xAxis = [];
          for (var element in _report.closingBalanceData.datas.first.datas) {
            var d = DateTime(
              _dateRange!.start.year,
              _dateRange!.start.month + element.x.toInt(),
            );
            _report.closingBalanceData.xAxis!.add(
              MyDateUtils.getFormattedDate(d, dateFormat: "MMM"),
            );
          }
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    modelProvider = Provider.of<ExpenseProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    _date = widget.sampleDate;

    if (widget.isBreakpoint) {
      title = "Breakpoint";
    } else if (widget.dateRange != null) {
      title = "Custom";
    } else {
      title = EnumToString.convertToString(widget.analysisSpan).toTitle();
    }

    update();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setBreakpointRange() {
    DateTime start = modelProvider.breakpoints.first.date;
    //DateTime start = modelProvider.transactions.first.date;
    DateTime? end;

    if (_date.isBefore(modelProvider.breakpoints.first.date)) {
      _date = _dateRange!.start.add(const Duration(microseconds: 1));
    }
    if (_date.isAfter(modelProvider.breakpoints.last.date)) {
      if (DateTime.now().isBefore(modelProvider.breakpoints.last.date)) {
        _date = modelProvider.breakpoints.last.date;
      } else {
        _date = DateTime.now();
        toText = "Today";
      }
    }

    for (var breakPoint in modelProvider.breakpoints) {
      if (breakPoint.date.isBefore(_date)) {
        start = breakPoint.date;
        fromText = breakPoint.breakPointName;
      }
      if (breakPoint.date.isAfter(_date) && end == null) {
        end = breakPoint.date
            .add(const Duration(days: 1))
            .subtract(const Duration(microseconds: 1));
        toText = breakPoint.breakPointName;
      }
    }
    end ??= DateTime.now();
    var d = DateTimeRange(start: start, end: end);
    _dateRange = d;
  }

  void update() {
    var span = widget.analysisSpan;
    if (widget.isBreakpoint) {
      setBreakpointRange();
    } else {
      _dateRange = widget.dateRange;
    }

    if (_dateRange != null) {
      if (_dateRange!.duration.inHours < 25) {
        span = DateSpan.day;
      } else if (_dateRange!.duration.inDays > 32) {
        span = DateSpan.year;
      } else {
        span = DateSpan.week;
      }
    }

    switch (span) {
      case DateSpan.day:
        _dateRange = _dateRange ?? MyDateUtils.getDayRange(_date);
        if (_dateRange!.start.year == DateTime.now().year &&
            _dateRange!.end.year == DateTime.now().year) {
          dateFormat = "d MMM";
        } else {
          dateFormat = "d MMM yyyy";
        }
        precision = AnalysisReportPrecision.hourly;
        break;
      case DateSpan.week:
        _dateRange = _dateRange ??
            MyDateUtils.getWeekRange(
              _date,
              settingsProvider.settings.firstDay,
            );
        if (_dateRange!.start.year == DateTime.now().year &&
            _dateRange!.end.year == DateTime.now().year) {
          dateFormat = "d MMM";
        } else {
          dateFormat = "d MMM yyyy";
        }
        precision = AnalysisReportPrecision.daily;
        break;
      case DateSpan.month:
        dateFormat = "MMMM yyyy";
        _dateRange = _dateRange ??
            MyDateUtils.getMonthRange(
              _date,
              settingsProvider.settings.firstDate,
            );
        precision = AnalysisReportPrecision.daily;
        break;
      case DateSpan.year:
        dateFormat = "yyyy";
        _dateRange = _dateRange ??
            MyDateUtils.getYearRange(
              _date,
              settingsProvider.settings.firstMonth,
            );
        precision = AnalysisReportPrecision.monthly;
        break;
    }

    if (widget.isBreakpoint) {
      dateFormat = "d MMM yyyy";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title Analysis"),
      ),
      body: Column(
        children: [
          DateRangeSlider(
            showNavigation: widget.dateRange == null,
            dateRange: _dateRange!,
            fromText: fromText,
            toText: toText,
            dateFormat: dateFormat,
            onPrevious: () {
              setState(() {
                _date =
                    _dateRange!.start.subtract(const Duration(microseconds: 1));
                update();
              });
            },
            onNext: () {
              setState(() {
                _date = _dateRange!.end.add(const Duration(microseconds: 1));
                update();
              });
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: calculateData(),
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    if (_report.transactions.isEmpty)
                      const Center(child: Text("No Transactions")),
                    if (_report.transactions.isNotEmpty) ...[
                      const Text("Summery"),
                      verticalSpace(16),
                      // Income/Expense/Total
                      Row(
                        children: [
                          // Income
                          Expanded(
                            child: SummeryContainer(
                              title: "Income",
                              color: getTransactionTypeColor(
                                  TransactionType.income),
                              icon: const Icon(Icons.arrow_downward),
                              amount: _report.totalIncome,
                            ),
                          ),
                          horizontalSpace(16),
                          // Expense
                          Expanded(
                            child: SummeryContainer(
                              title: "Expense",
                              color: getTransactionTypeColor(
                                  TransactionType.expense),
                              icon: const Icon(Icons.arrow_upward),
                              amount: _report.totalExpense,
                            ),
                          ),
                        ],
                      ),

                      verticalSpace(32),
                      //--------
                      // if (_balanceChartData.isNotEmpty)
                      ChartContainer(
                        title: "Balance Chart",
                        chart: MyLineChart(
                          data: _report.closingBalanceData,
                        ),
                      ),
                      verticalSpace(16),

                      //------------------------------
                      if (_report.categorywiseIncome.datas.isNotEmpty)
                        ChartContainer(
                          title: "Income Category Chart",
                          chart: MyPieChart(
                            showPercentage: true,
                            data: _report.categorywiseIncome,
                          ),
                        ),
                      if (_report.categorywiseIncome.datas.isNotEmpty)
                        verticalSpace(16),

                      //------------------------------
                      if (_report.categorywiseExpense.datas.isNotEmpty)
                        ChartContainer(
                          title: "Expense Category Chart",
                          chart: MyPieChart(
                            showPercentage: true,
                            data: _report.categorywiseExpense,
                          ),
                        ),
                      if (_report.categorywiseExpense.datas.isNotEmpty)
                        verticalSpace(16),

                      //------------------------------
                      if (_report.incomeWisePaymentMethod.datas.isNotEmpty)
                        ChartContainer(
                          title: "Payment Methods used for Income",
                          chart: ChartLegend(
                            showCheckBox: false,
                            showIcon: false,
                            data: _report.incomeWisePaymentMethod,
                          ),
                        ),
                      if (_report.incomeWisePaymentMethod.datas.isNotEmpty)
                        verticalSpace(16),

                      if (_report.expenseWisePaymentMethod.datas.isNotEmpty)
                        ChartContainer(
                          title: "Payment Methods used for Expense",
                          chart: ChartLegend(
                            showCheckBox: false,
                            showIcon: false,
                            data: _report.expenseWisePaymentMethod,
                          ),
                        ),

                      if (_report.expenseWisePaymentMethod.datas.isNotEmpty)
                        verticalSpace(16),

                      const Text("Transactions"),
                      verticalSpace(16),
                      if (_report.transactions.isNotEmpty)
                        ..._report.transactions
                            .map((e) => TransactionListTile(transaction: e))
                            .toList(),
                      if (_report.transactions.isEmpty)
                        const Text("No Transactions"),
                      verticalSpace(16),
                    ]
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
