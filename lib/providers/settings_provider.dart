import 'package:flutter/foundation.dart';
import 'package:flutter_expense_manager/models/settings_model.dart';
import 'package:flutter_expense_manager/globals/globals.dart';

abstract class SettingsProvider extends ChangeNotifier {
  SettingsModel get settings;

  void notify() {
    notifyListeners();
  }

  void load();
  void clean();
  void save();

  void updateFirstInitDone(bool value);
  void updateDarkTheme(bool value);
  void updateShowBalance(bool value);
  void updateAppPath(String value);
  // DateTime
  void updateFirstDay(DaysName day);
  void updateFirstMonth(MonthsName month);
  void updateFirstDate(int date);
  void updateDateFormat(String format);
  void updateTimeFormat(String format);
}
