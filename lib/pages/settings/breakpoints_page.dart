import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/utils/date_utils.dart';
import 'package:flutter_expense_manager/widgets/dialogs/add_breakpoint_dialog.dart';
import 'package:flutter_expense_manager/widgets/dialogs/common_dialog.dart';

class BreakPointPage extends StatefulWidget {
  const BreakPointPage({Key? key}) : super(key: key);

  @override
  State<BreakPointPage> createState() => _BreakPointPageState();
}

class _BreakPointPageState extends State<BreakPointPage> {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    return Consumer<ExpenseProvider>(
      builder: (_, expenseProvider, __) => Scaffold(
        appBar: AppBar(
          title: const Text("BreakPoints"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var breakpoint = await showDialog<BreakPoint>(
              context: context,
              builder: (context) {
                return commonDialog(child: const AddBreakpointDialog());
              },
            );
            if (breakpoint != null) {
              await expenseProvider.addBreakPoint(breakpoint);
            }
          },
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ...expenseProvider.breakpoints.map(
              (e) {
                var date = MyDateUtils.getFormattedDate(
                  e.date,
                  dateFormat: settingsProvider.settings.dateFormat,
                );
                return ListTile(
                  title: Text(e.breakPointName),
                  subtitle: Text("Created on $date"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    splashRadius: 16,
                    onPressed: () async {
                      await expenseProvider.deleteBreakPoint(e);
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
