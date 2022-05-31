import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/app_layout.dart';
import 'package:flutter_expense_manager/globals/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: const AppLayout(),
    );
  }
}
