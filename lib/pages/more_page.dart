import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/widgets/custom_page_route.dart';
import 'package:flutter_expense_manager/widgets/user_card.dart';
import 'package:flutter_expense_manager/pages/settings/account_page.dart';
import 'package:flutter_expense_manager/pages/settings/app_settings_page.dart';
import 'package:flutter_expense_manager/pages/settings/backup_restore_page.dart';
import 'package:flutter_expense_manager/pages/settings/breakpoints_page.dart';
import 'package:flutter_expense_manager/pages/settings/categories_page.dart';
import 'package:flutter_expense_manager/pages/settings/currency_page.dart';
import 'package:flutter_expense_manager/pages/settings/date_time_page.dart';
import 'package:flutter_expense_manager/pages/settings/payer_payee_page.dart';
import 'package:flutter_expense_manager/pages/settings/payment_methods_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: UserCard(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text("Categories"),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: const CategoryPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text("Accounts"),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: const AccountPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.moving_rounded),
            title: const Text("Payment Methods"),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: const PaymentMethodPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text("Payers/Payees"),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: const PayerPayeePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_page_break_outlined),
            title: const Text("Breakpoints"),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: const BreakPointPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text("Currency"),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: const CurrencyPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time_sharp),
            title: const Text("Date & Time"),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: const DateTimeSettingsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_backup_restore),
            title: const Text("Backup & Restore"),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: const BackupRestorePage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: const AppSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
