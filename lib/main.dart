import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/app_layout.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/globals/themes.dart';
import 'package:flutter_expense_manager/providers/app_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/providers/hive_expense_provider.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/utils/app_utils.dart';
import 'package:flutter_expense_manager/utils/hive_utils.dart';

late SettingsProvider appSettings;
late ExpenseProvider expenseProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appSettings = await AppUtils.initApp();
  HiveUtils.init(appSettings.settings.dbPath);
  HiveUtils.registerAdapters();
  await HiveUtils.openBoxex();

  appSettings.load();
  expenseProvider = HiveExpenseProvider();
  expenseProvider.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
          create: (context) => AppProvider(),
        ),
        ChangeNotifierProvider<ExpenseProvider>(
          create: (context) => expenseProvider,
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (context) => appSettings,
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: ((_, provider, __) => MaterialApp(
              title: 'Expense Manager',
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: globalSnackbarKey,
              theme: provider.settings.useDarkTheme ? darkTheme : lightTheme,
              home: const AppLayout(),
            )),
      ),
    );
  }
}
