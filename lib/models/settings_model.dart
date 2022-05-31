import 'package:path/path.dart' as p;
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_expense_manager/globals/constants.dart';
import 'package:flutter_expense_manager/globals/globals.dart';

part 'settings_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeID.settingsModel)
class SettingsModel {
  SettingsModel();

  @HiveField(0)
  bool firstInit = true;
  @HiveField(1)
  bool useDarkTheme = true;
  @HiveField(2)
  bool showBalance = true;

  late String dbPath;
  @HiveField(3)
  late String appPath;

  // Date Settings
  @HiveField(4)
  DaysName firstDay = DaysName.sunday;
  @HiveField(5)
  MonthsName firstMonth = MonthsName.january;
  @HiveField(6)
  int firstDate = 1;
  @HiveField(7)
  String dateFormat = dateFormats.first;
  @HiveField(8)
  String timeFormat = timeFormats.first;

  // Temporary Settings
  bool hasStoragePermission = false;
  bool hasManagePermission = false;

  String get refFilesPath => p.join(dbPath, "files");

  String get backupPath => p.join(appPath, "backups");

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
}
