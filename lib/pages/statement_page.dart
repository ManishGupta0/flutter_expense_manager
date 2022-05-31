import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/widgets/transaction_list_tile.dart';

class StatementPage extends StatefulWidget {
  const StatementPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatementPage> createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> {
  late ExpenseProvider provider;
  var isFiltered = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ExpenseProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statements"),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (_, provider, __) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemCount: provider.transactions.length,
                    itemBuilder: (_, index) {
                      var t = provider.transactions[
                          provider.transactions.length - index - 1];
                      return TransactionListTile(transaction: t);
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
