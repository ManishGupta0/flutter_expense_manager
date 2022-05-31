import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var modelProvider = Provider.of<ExpenseProvider>(context, listen: false);
    // var appProvider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Consumer<SettingsProvider>(
        builder: (_, provider, __) => ListView(
          children: [
            SwitchListTile(
              value: provider.settings.useDarkTheme,
              title: const Text("Use Dark Theme"),
              onChanged: (value) {
                provider.updateDarkTheme(value);
              },
            ),
            SwitchListTile(
              value: provider.settings.showBalance,
              title: const Text("Show Balance"),
              onChanged: (value) {
                provider.updateShowBalance(value);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("Reset"),
              subtitle: const Text("Delete all app Data"),
              onTap: () {
                modelProvider.clean();
              },
            ),
          ],
        ),
      ),
    );
  }
}
