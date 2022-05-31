import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/date_utils.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/pages/transaction_page.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';
import 'package:flutter_expense_manager/widgets/custom_page_route.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({Key? key, required this.transaction})
      : super(key: key);
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    var modelProvider = Provider.of<ExpenseProvider>(context, listen: false);

    var cat = modelProvider.categories.firstWhere(
      (element) => element.name == transaction.category,
      orElse: () => TransactionCategory(
        name: "",
      ),
    );

    return Consumer<SettingsProvider>(
      builder: (_, provider, __) {
        var formattedDate = MyDateUtils.getFormattedDate(
          transaction.date,
          dateFormat: provider.settings.dateFormat,
          timeFormat: provider.settings.timeFormat,
        );
        var categoryText = "";

        if (transaction.category != null) {
          categoryText = transaction.category!;
          if (transaction.subCategory != null) {
            categoryText += " : ${transaction.subCategory!}";
          }
        } else {
          categoryText = "Not Specified";
        }

        return Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute.fromDown(
                  child: TransactionPage(
                    edit: true,
                    transaction: transaction,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // Main Details
                  Row(
                    children: [
                      // Category Icon
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(cat.color),
                        ),
                        child: transaction.transactionType ==
                                TransactionType.transfer
                            ? const Icon(Icons.swap_horiz)
                            : const Icon(Icons.category_outlined),
                      ),
                      horizontalSpace(),
                      // Main Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (transaction.payerPayee != null)
                              Text("${transaction.payerPayee}"),
                            Text(formattedDate),
                            if (transaction.category != null)
                              Text(categoryText),
                            if (transaction.remarks != null)
                              Text(
                                "Remarks: ${transaction.remarks}",
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      // Amount
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (transaction.transactionType !=
                              TransactionType.transfer)
                            Icon(
                              transaction.transactionType ==
                                      TransactionType.income
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: getTransactionTypeColor(
                                transaction.transactionType,
                              ),
                            ),
                          Text(
                            transaction.amount.toString(),
                            style: TextStyle(
                              color: getTransactionTypeColor(
                                transaction.transactionType,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Balance
                  if (provider.settings.showBalance) const Divider(),
                  if (provider.settings.showBalance)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(transaction.account),
                        Text(transaction.balance.toString()),
                      ],
                    ),
                  if (provider.settings.showBalance &&
                      transaction.transactionType == TransactionType.transfer)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(transaction.toAccount!),
                        Text(transaction.balance2.toString()),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
