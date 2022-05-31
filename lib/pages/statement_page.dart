import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/widgets/transaction_list_tile.dart';
import 'package:flutter_expense_manager/models/filter_model.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/hive_expense_provider.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';
import 'package:flutter_expense_manager/utils/filter_utils.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';
import 'package:flutter_expense_manager/widgets/bottom_sheet.dart';
import 'package:flutter_expense_manager/widgets/statement_filter.dart';

class StatementPage extends StatefulWidget {
  const StatementPage({Key? key, this.filters}) : super(key: key);

  final FilterModel? filters;

  @override
  State<StatementPage> createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> {
  late ExpenseProvider provider;
  late FilterModel filterModel;
  var isFiltered = false;

  List<Transaction> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ExpenseProvider>(context, listen: false);
    filterModel = widget.filters ?? FilterModel();
  }

  @override
  Widget build(BuildContext context) {
    filteredTransactions = provider.transactions
        .where(
          (t) => isFilterApplied(transaction: t, filters: filterModel),
        )
        .toList();

    var total = filteredTransactions
        .fold<double>(
          0.0,
          (previousValue, element) =>
              previousValue +
              element.amount * getTransactionSign(element.transactionType),
        )
        .withPrecision();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statements"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            splashRadius: 16,
            onPressed: () {
              showDraggableBottomSheet(
                context,
                initialChildSize: 0.56,
                child: StatementFilter(
                  filters: filterModel,
                  onSubmit: (value) {
                    setState(() {
                      filterModel = value;
                      isFiltered = filterModel.isFilterApplied;
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
          if (provider.transactions.length != filteredTransactions.length)
            IconButton(
              icon: const Icon(Icons.filter_list_off),
              splashRadius: 16,
              onPressed: () {
                setState(() {
                  filterModel = FilterModel();
                });
              },
            ),
        ],
      ),
      body: Consumer<ExpenseProvider>(
        builder: (_, provider, __) {
          filteredTransactions = provider.transactions
              .where(
                (t) => isFilterApplied(transaction: t, filters: filterModel),
              )
              .toList();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (_, index) {
                      var t = filteredTransactions[
                          filteredTransactions.length - index - 1];
                      return TransactionListTile(transaction: t);
                    }),
              ),
              if (filterModel.payer != null)
                ListTile(
                  title: const Text("Total"),
                  trailing: Text(
                    "$total",
                    style: TextStyle(
                      color: getBalanceColor(total),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
