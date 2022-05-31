import 'package:flutter/material.dart';

class CurrencyPage extends StatelessWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          Text("Coming Soon..."),
        ],
      ),
    );
  }
}
