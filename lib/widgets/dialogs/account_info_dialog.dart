import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class AccountInfoDialog extends StatelessWidget {
  const AccountInfoDialog({Key? key, required this.account, this.titleText})
      : super(key: key);

  final String? titleText;
  final Account account;

  @override
  Widget build(BuildContext context) {
    var modelProvider = Provider.of<ExpenseProvider>(context, listen: false);
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleText ?? "Account"),
          const Divider(),
          verticalSpace(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name"),
                  const Text("Type"),
                  if (settingsProvider.settings.showBalance)
                    const Text("Balance"),
                ],
              ),
              horizontalSpace(64),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.name),
                  Text(account.type ?? "Not Specified"),
                  if (settingsProvider.settings.showBalance)
                    Text(account.balance.toString()),
                ],
              ),
            ],
          ),
          verticalSpace(),
          const Divider(),
          ButtonBar(
            children: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  modelProvider.deleteAccount(account);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
