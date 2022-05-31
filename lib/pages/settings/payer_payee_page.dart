import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/app_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';
import 'package:flutter_expense_manager/widgets/dialogs/add_payer_dialog.dart';
import 'package:flutter_expense_manager/widgets/dialogs/common_dialog.dart';

class PayerPayeePage extends StatelessWidget {
  const PayerPayeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context, listen: false);

    return Consumer<ExpenseProvider>(
      builder: (_, expenseProvider, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Payers/Payees"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var account = await showDialog<PayerPayee>(
                context: context,
                builder: (context) {
                  return commonDialog(
                    child: const AddPayerDialog(),
                  );
                },
              );
              if (account != null) {
                expenseProvider.addPayer(account);
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    ...expenseProvider.payeers
                        .map(
                          (e) => ListTile(
                            title: Text(e.name),
                            subtitle: Text(e.type ?? ""),
                            trailing: Text(
                              e.balance.toString(),
                              style: TextStyle(
                                color: getBalanceColor(e.balance),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              appProvider.updatePage(1);
                            },
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
