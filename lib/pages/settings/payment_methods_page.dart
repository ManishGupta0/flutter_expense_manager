import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/widgets/input_textfield.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (_, provider, __) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  ...provider.paymentMethods.map(
                    (e) => ListTile(
                      title: Text(e.name),
                      trailing: e.canDelete
                          ? IconButton(
                              icon: const Icon(Icons.delete),
                              splashRadius: 16,
                              onPressed: () {
                                provider.deletePaymentMethod(e);
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.edit),
                              splashRadius: 16,
                              onPressed: () {},
                            ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: InputTextField(
                labelText: "New Payment Method Name",
                onSubmit: (value) {
                  provider.addPaymentMethod(PaymentMethod(name: value));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
