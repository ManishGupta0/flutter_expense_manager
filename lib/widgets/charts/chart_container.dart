import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class ChartContainer extends StatelessWidget {
  const ChartContainer({
    Key? key,
    required this.title,
    this.foregroundColor,
    this.backgroundColor,
    required this.chart,
  }) : super(key: key);

  final String title;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Widget? chart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: backgroundColor ?? Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // title
          Text(
            title,
            style: TextStyle(color: foregroundColor),
          ),

          verticalSpace(16),
          if (chart != null) chart!,
        ],
      ),
    );
  }
}
