import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expense_manager/models/expense_model.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';
import 'package:flutter_expense_manager/widgets/dialogs/add_category_dialog.dart';
import 'package:flutter_expense_manager/widgets/dialogs/common_dialog.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Categories"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Income"),
              Tab(text: "Expense"),
              Tab(text: "Transfer"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Income
            incomeTabView(),
            // Expense
            expenseTabView(),
            // Transfer
            transferTabView(),
          ],
        ),
      ),
    );
  }

  Widget incomeTabView() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, __) => Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(8),
            children: provider.categories
                .where((element) =>
                    element.associatedType == TransactionType.income)
                .map(
                  (e) => categoryListTile(context, e, provider),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor:
                    getTransactionTypeColor(TransactionType.income),
                onPressed: () async {
                  var category = await showDialog<TransactionCategory>(
                    context: context,
                    builder: (context) {
                      return commonDialog(child: const AddCategoryDialog());
                    },
                  );
                  if (category != null) {
                    category.name = category.name.toTitle();
                    category.associatedType = TransactionType.income;
                    provider.addCategory(category);
                  }
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget expenseTabView() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, __) => Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(8),
            children: provider.categories
                .where((element) =>
                    element.associatedType == TransactionType.expense)
                .map(
                  (e) => categoryListTile(context, e, provider),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor:
                    getTransactionTypeColor(TransactionType.expense),
                onPressed: () async {
                  var category = await showDialog<TransactionCategory>(
                    context: context,
                    builder: (context) {
                      return commonDialog(
                          child: const AddCategoryDialog(
                        assentColor: false,
                      ));
                    },
                  );
                  if (category != null) {
                    category.name = category.name.toTitle();
                    category.associatedType = TransactionType.expense;
                    provider.addCategory(category);
                  }
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transferTabView() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, __) => Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(8),
            children: provider.categories
                .where((element) =>
                    element.associatedType == TransactionType.transfer)
                .map(
                  (e) => categoryListTile(context, e, provider),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor:
                    getTransactionTypeColor(TransactionType.transfer),
                onPressed: () async {
                  var category = await showDialog<TransactionCategory>(
                    context: context,
                    builder: (context) {
                      return commonDialog(
                          child: const AddCategoryDialog(
                        assentColor: false,
                      ));
                    },
                  );
                  if (category != null) {
                    category.name = category.name.toTitle();
                    category.associatedType = TransactionType.transfer;
                    provider.addCategory(category);
                  }
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryListTile(
    BuildContext context,
    TransactionCategory e,
    ExpenseProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        tileColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.all(8.0),
        title: Text(e.name),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(e.color),
          ),
          child: const Icon(
            Icons.category_outlined,
          ),
        ),
        trailing: e.canDelete
            ? IconButton(
                icon: const Icon(Icons.delete),
                splashRadius: 16,
                onPressed: () {
                  provider.deleteCategory(e);
                },
              )
            : IconButton(
                icon: const Icon(Icons.edit),
                splashRadius: 16,
                onPressed: () {},
              ),
        onTap: () {},
      ),
    );
  }
}
