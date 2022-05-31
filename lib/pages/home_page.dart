import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/widgets/custom_page_route.dart';
import 'package:flutter_expense_manager/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            CustomPageRoute.fromDown(
              child: const TransactionPage(),
            ),
          );
        },
      ),
    );
  }
}
