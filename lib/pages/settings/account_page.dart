import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';
import 'package:flutter_expense_manager/widgets/dialogs/add_account_dialog.dart';
import 'package:flutter_expense_manager/widgets/dialogs/account_info_dialog.dart';
import 'package:flutter_expense_manager/widgets/dialogs/common_dialog.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    return Consumer<ExpenseProvider>(
      builder: (_, provider, __) {
        var total =
            provider.accounts.fold(0.0, (double previousValue, element) {
          return previousValue + element.balance;
        });
        return Scaffold(
          appBar: AppBar(
            title: const Text("Accounts"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var account = await showDialog<Account>(
                context: context,
                builder: (context) {
                  return commonDialog(child: const AddAccountDialog());
                },
              );
              if (account != null) {
                provider.addAccount(account);
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
                    if (settingsProvider.settings.showBalance &&
                        provider.accounts.isNotEmpty) ...[
                      ListTile(
                        title: const Text(
                          "Total",
                        ),
                        trailing: Text(
                          total.toString(),
                          style: TextStyle(
                            color: getBalanceColor(total),
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                    ...provider.accounts
                        .map(
                          (e) => ListTile(
                            title: Text(e.name),
                            subtitle: Text(e.type ?? ""),
                            trailing: settingsProvider.settings.showBalance
                                ? Text(
                                    e.balance.toString(),
                                    style: TextStyle(
                                      color: getBalanceColor(e.balance),
                                    ),
                                  )
                                : null,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return commonDialog(
                                    child: AccountInfoDialog(account: e),
                                  );
                                },
                              );
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
