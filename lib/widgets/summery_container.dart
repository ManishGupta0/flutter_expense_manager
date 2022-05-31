import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class SummeryContainer extends StatelessWidget {
  const SummeryContainer({
    Key? key,
    required this.title,
    required this.color,
    required this.icon,
    required this.amount,
  }) : super(key: key);

  final String title;
  final Color color;
  final Widget icon;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white54,
            foregroundColor: Colors.white,
            child: icon,
          ),
          horizontalSpace(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(amount.withPrecision().toString()),
            ],
          ),
        ],
      ),
    );
  }
}
