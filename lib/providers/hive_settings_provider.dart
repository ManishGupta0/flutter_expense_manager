import 'package:hive/hive.dart';
import 'package:flutter_expense_manager/globals/globals.dart';
import 'package:flutter_expense_manager/globals/constants.dart';
import 'package:flutter_expense_manager/models/settings_model.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';

class HiveSettingsProvider extends SettingsProvider {
  SettingsModel _appSettingsModel = SettingsModel();
  @override
  SettingsModel get settings => _appSettingsModel;

  @override
  void load() async {
    var box = Hive.box<SettingsModel>(Names.appSettingsBox);
    if (box.isNotEmpty) {
      var dbPath = _appSettingsModel.dbPath;
      var appPath = _appSettingsModel.appPath;
      var hasStoragePermission = _appSettingsModel.hasStoragePermission;
      var hasManagePermission = _appSettingsModel.hasManagePermission;

      _appSettingsModel = box.values.first;

      _appSettingsModel.dbPath = dbPath;
      _appSettingsModel.hasStoragePermission = hasStoragePermission;
      _appSettingsModel.hasManagePermission = hasManagePermission;

      if (!hasManagePermission) {
        _appSettingsModel.appPath = appPath;
      }
    } else {
      await save();
    }
  }

  @override
  void clean() {}

  @override
  Future<void> save() async {
    var box = Hive.box<SettingsModel>(Names.appSettingsBox);
    await box.put(0, _appSettingsModel);

    _appSettingsModel = box.values.first;
    notifyListeners();
  }

  @override
  void updateFirstInitDone(bool value) async {
    _appSettingsModel.firstInit = value;
    await save();
  }

  @override
  void updateDarkTheme(bool value) async {
    _appSettingsModel.useDarkTheme = value;
    await save();
  }

  @override
  void updateShowBalance(bool value) async {
    _appSettingsModel.showBalance = value;
    await save();
  }

  @override
  void updateAppPath(String value) async {
    _appSettingsModel.appPath = value;
    await save();
  }

  @override
  void updateFirstDay(DaysName day) async {
    _appSettingsModel.firstDay = day;
    await save();
  }

  @override
  void updateFirstMonth(MonthsName month) async {
    _appSettingsModel.firstMonth = month;
    await save();
  }

  @override
  void updateFirstDate(int date) async {
    _appSettingsModel.firstDate = date;
    await save();
  }

  @override
  void updateDateFormat(String format) async {
    _appSettingsModel.dateFormat = format;
    await save();
  }

  @override
  void updateTimeFormat(String format) async {
    _appSettingsModel.timeFormat = format;
    await save();
  }
}
