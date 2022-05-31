import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/utils/date_utils.dart';

class DateRangeSlider extends StatelessWidget {
  const DateRangeSlider({
    Key? key,
    this.showNavigation = true,
    this.fromText,
    this.toText,
    required this.dateRange,
    required this.dateFormat,
    this.onPrevious,
    this.onNext,
  }) : super(key: key);

  final bool showNavigation;
  final String? fromText;
  final String? toText;
  final DateTimeRange dateRange;
  final String dateFormat;

  final void Function()? onPrevious;
  final void Function()? onNext;

  @override
  Widget build(BuildContext context) {
    var fromDate = MyDateUtils.getFormattedDate(
      dateRange.start,
      dateFormat: dateFormat,
    );
    var toDate = MyDateUtils.getFormattedDate(
      dateRange.end,
      dateFormat: dateFormat,
    );
    var finalText = "";
    var finalDate = fromDate;

    if (fromDate != toDate) {
      finalDate = "$fromDate - $toDate";
    }
    if (fromText != null) {
      finalText += fromText!;
    }

    if (toText != null) {
      if (fromText != null) {
        finalText += " - ";
      }
      finalText += toText!;
    }

    return Row(
      children: [
        if (showNavigation)
          IconButton(
            splashRadius: 16,
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
        Expanded(
          child: Column(
            children: [
              if (finalText.isNotEmpty)
                Text(
                  finalText,
                  textAlign: TextAlign.center,
                ),
              Text(
                finalDate,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        if (showNavigation)
          IconButton(
            splashRadius: 16,
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
      ],
    );
  }
}
