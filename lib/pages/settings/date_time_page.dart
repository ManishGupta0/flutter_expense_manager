import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/utils/extensions.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class DateTimeSettingsPage extends StatelessWidget {
  const DateTimeSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<MonthsName>> monthItems =
        EnumToString.toList(MonthsName.values)
            .map((e) => DropdownMenuItem(
                value: EnumToString.fromString(MonthsName.values, e),
                child: Text(e.toTitle())))
            .toList();

    final List<DropdownMenuItem<DaysName>> dayItems =
        EnumToString.toList(DaysName.values)
            .map((e) => DropdownMenuItem(
                value: EnumToString.fromString(DaysName.values, e),
                child: Text(e.toTitle())))
            .toList();

    final List<DropdownMenuItem<int>> dateItems = List.generate(
      31,
      (index) => DropdownMenuItem(
          value: index + 1,
          child: Text(
              (index + 1).toString() + (index > 27 ? " (If Month Have)" : ""))),
    );

    final List<DropdownMenuItem<String>> dateFormatItems = List.generate(
      dateFormats.length,
      (index) => DropdownMenuItem(
        value: dateFormats.elementAt(index),
        child: Text(
          "${dateFormats.elementAt(index)}   (${DateFormat(dateFormats.elementAt(index)).format(
            DateTime.now(),
          )})",
        ),
      ),
    );

    final List<DropdownMenuItem<String>> timeFormatItems = List.generate(
      timeFormats.length,
      (index) => DropdownMenuItem(
        value: timeFormats.elementAt(index),
        child: Text(
          "${timeFormats.elementAt(index)}   (${DateFormat(timeFormats.elementAt(index)).format(
            DateTime.now(),
          )})",
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Date & Time Settings"),
      ),
      body: Consumer<SettingsProvider>(
        builder: (_, provider, __) => ListView(
          padding: const EdgeInsets.all(8),
          children: [
            DropdownButtonFormField<DaysName>(
              value: provider.settings.firstDay,
              decoration: const InputDecoration(
                labelText: "First Day of Week",
                isDense: true,
              ),
              items: dayItems,
              onChanged: (value) {
                if (value != null) {
                  provider.updateFirstDay(value);
                }
              },
            ),
            verticalSpace(32),
            DropdownButtonFormField<MonthsName>(
              value: provider.settings.firstMonth,
              decoration: const InputDecoration(
                labelText: "First Month of Year",
                isDense: true,
              ),
              items: monthItems,
              onChanged: (value) {
                if (value != null) {
                  provider.updateFirstMonth(value);
                }
              },
            ),
            verticalSpace(32),
            DropdownButtonFormField<int>(
              value: provider.settings.firstDate,
              decoration: const InputDecoration(
                labelText: "First Day of Month",
                isDense: true,
              ),
              items: dateItems,
              onChanged: (value) {
                if (value != null) {
                  provider.updateFirstDate(value);
                }
              },
            ),
            verticalSpace(32),
            DropdownButtonFormField<String>(
              value: provider.settings.dateFormat,
              decoration: const InputDecoration(
                labelText: "Date Format",
                isDense: true,
              ),
              items: dateFormatItems,
              onChanged: (value) {
                if (value != null) {
                  provider.updateDateFormat(value);
                }
              },
            ),
            verticalSpace(32),
            DropdownButtonFormField<String>(
              value: provider.settings.timeFormat,
              decoration: const InputDecoration(
                labelText: "Time Format",
                isDense: true,
              ),
              items: timeFormatItems,
              onChanged: (value) {
                if (value != null) {
                  provider.updateTimeFormat(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
