import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/pages/analysis_page.dart';
import 'package:flutter_expense_manager/widgets/dialogs/add_breakpoint_dialog.dart';
import 'package:flutter_expense_manager/widgets/dialogs/common_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/widgets/custom_page_route.dart';
import 'package:flutter_expense_manager/pages/transaction_page.dart';
import 'package:flutter_expense_manager/providers/app_provider.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';
import 'package:flutter_expense_manager/widgets/summery_container.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/widgets/user_card.dart';
import 'package:flutter_expense_manager/widgets/transaction_list_tile.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ExpenseProvider modelProvider;
  late final SettingsProvider settingsProvider;

  double incomeAmount = 0.0;
  double expenseAmount = 0.0;
  double totalAmount = 0.0;

  Future<void> calculateAmount() async {
    incomeAmount = 0.0;
    expenseAmount = 0.0;
    totalAmount = 0.0;

    totalAmount =
        modelProvider.accounts.fold(0.0, (double previousValue, element) {
      return previousValue + element.balance;
    });

    for (var transaction in modelProvider.transactionsThisMonth) {
      if (transaction.transactionType == TransactionType.income) {
        incomeAmount += transaction.amount;
      }
      if (transaction.transactionType == TransactionType.expense) {
        expenseAmount += transaction.amount;
      }
    }
  }

  @override
  void initState() {
    modelProvider = Provider.of<ExpenseProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (_, provider, __) => Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              CustomPageRoute.fromDown(
                child: const TransactionPage(),
              ),
            );
          },
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            verticalSpace(16),
            // User
            const UserCard(),
            verticalSpace(32),

            const Text("This Month"),
            verticalSpace(16),
            // Income/Expense/Total
            FutureBuilder(
              future: calculateAmount(),
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Row(
                  children: [
                    // Income
                    Expanded(
                      child: SummeryContainer(
                        title: "Income",
                        color: getTransactionTypeColor(TransactionType.income),
                        icon: const Icon(Icons.arrow_downward),
                        amount: incomeAmount.withPrecision(),
                      ),
                    ),
                    horizontalSpace(16),
                    // Expense
                    Expanded(
                      child: SummeryContainer(
                        title: "Expense",
                        color: getTransactionTypeColor(TransactionType.expense),
                        icon: const Icon(Icons.arrow_upward),
                        amount: expenseAmount.withPrecision(),
                      ),
                    ),
                    horizontalSpace(16),
                    // Balance
                    if (settingsProvider.settings.showBalance)
                      Expanded(
                        child: SummeryContainer(
                          title: "Balance",
                          color: Colors.blue,
                          icon: const Icon(Icons.attach_money),
                          amount: totalAmount.withPrecision(),
                        ),
                      ),
                  ],
                );
              },
            ),
            verticalSpace(32),

            // Recent Transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Transactions"),
                TextButton(
                  child: const Text("View All"),
                  onPressed: () {
                    var appProvider =
                        Provider.of<AppProvider>(context, listen: false);
                    appProvider.updatePage(1);
                  },
                ),
              ],
            ),
            verticalSpace(16),

            if (provider.transactions.isEmpty)
              const Center(child: Text("No Transactions yet!!")),

            if (provider.transactions.isNotEmpty)
              ...List.generate(
                min(3, provider.transactions.length),
                (index) => TransactionListTile(
                  transaction: provider
                      .transactions[provider.transactions.length - index - 1],
                ),
              ),

            verticalSpace(16),
            // Analysis
            const Text("Analysis"),
            verticalSpace(16),
            Row(
              children: const [
                Expanded(
                  child: AnalysisCard(
                    analysisSpan: DateSpan.day,
                    icon: Icon(Icons.calendar_view_day, size: 30),
                    analysisName: "Daily Analysis",
                  ),
                ),
                Expanded(
                  child: AnalysisCard(
                    analysisSpan: DateSpan.week,
                    icon: Icon(Icons.calendar_view_week, size: 30),
                    analysisName: "Week Analysis",
                  ),
                ),
                Expanded(
                  child: AnalysisCard(
                    analysisSpan: DateSpan.month,
                    icon: Icon(Icons.calendar_view_month, size: 30),
                    analysisName: "Month Analysis",
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: AnalysisCard(
                    analysisSpan: DateSpan.year,
                    icon: Icon(Icons.calendar_today, size: 30),
                    analysisName: "Year Analysis",
                  ),
                ),
                Expanded(
                  child: AnalysisCard(
                    icon: const Icon(Icons.analytics_outlined, size: 30),
                    analysisName: "Custom Analysis",
                    onTap: () async {
                      var d = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 100),
                        lastDate: DateTime.now(),
                        helpText: "Select Date Range",
                        confirmText: "Select",
                        saveText: "Select",
                      );
                      if (d != null) {
                        DateTime end;

                        end = d.end
                            .add(const Duration(days: 1))
                            .subtract(const Duration(microseconds: 1));

                        DateTimeRange dateRange =
                            DateTimeRange(start: d.start, end: end);

                        Navigator.push(
                          context,
                          CustomPageRoute.fromDown(
                            child: AnalysisPage(
                              sampleDate: DateTime.now(),
                              dateRange: dateRange,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: AnalysisCard(
                    icon:
                        const Icon(Icons.insert_page_break_outlined, size: 30),
                    analysisName: "Breakpoint Analysis",
                    onTap: provider.breakpoints.isEmpty
                        ? () async {
                            var breakpoint = await showDialog<BreakPoint>(
                              context: context,
                              builder: (context) {
                                return commonDialog(
                                    child: const AddBreakpointDialog());
                              },
                            );
                            if (breakpoint != null) {
                              await provider.addBreakPoint(breakpoint);
                            }
                          }
                        : () {
                            Navigator.push(
                              context,
                              CustomPageRoute.fromDown(
                                child: AnalysisPage(
                                  sampleDate: DateTime.now(),
                                  isBreakpoint: true,
                                ),
                              ),
                            );
                          },
                  ),
                ),
              ],
            ),
            verticalSpace(16),
          ],
        ),
      ),
    );
  }
}

class AnalysisCard extends StatelessWidget {
  const AnalysisCard({
    Key? key,
    this.analysisSpan,
    required this.icon,
    required this.analysisName,
    this.dateRange,
    this.onTap,
  }) : super(key: key);

  final DateSpan? analysisSpan;
  final Widget icon;
  final String analysisName;
  final DateTimeRange? dateRange;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                CustomPageRoute.fromDown(
                  child: AnalysisPage(
                    sampleDate: DateTime.now(),
                    analysisSpan: analysisSpan ?? DateSpan.day,
                  ),
                ),
              );
            },
        child: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              icon,
              Text(
                analysisName,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
