import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class PayerInfoDialog extends StatelessWidget {
  const PayerInfoDialog({Key? key, required this.payer}) : super(key: key);

  final PayerPayee payer;

  @override
  Widget build(BuildContext context) {
    var modelProvider = Provider.of<ExpenseProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Asset Account"),
          const Divider(),
          verticalSpace(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Name"),
                  Text("Type"),
                  Text("Balance"),
                ],
              ),
              horizontalSpace(64),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(payer.name),
                  Text(payer.type ?? ""),
                  Text(payer.balance.toString()),
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
                  modelProvider.deletePayer(payer);
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
