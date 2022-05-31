// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 0;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel()
      ..firstInit = fields[0] as bool
      ..useDarkTheme = fields[1] as bool
      ..showBalance = fields[2] as bool
      ..appPath = fields[3] as String
      ..firstDay = fields[4] as DaysName
      ..firstMonth = fields[5] as MonthsName
      ..firstDate = fields[6] as int
      ..dateFormat = fields[7] as String
      ..timeFormat = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.firstInit)
      ..writeByte(1)
      ..write(obj.useDarkTheme)
      ..writeByte(2)
      ..write(obj.showBalance)
      ..writeByte(3)
      ..write(obj.appPath)
      ..writeByte(4)
      ..write(obj.firstDay)
      ..writeByte(5)
      ..write(obj.firstMonth)
      ..writeByte(6)
      ..write(obj.firstDate)
      ..writeByte(7)
      ..write(obj.dateFormat)
      ..writeByte(8)
      ..write(obj.timeFormat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel()
      ..firstInit = json['firstInit'] as bool
      ..useDarkTheme = json['useDarkTheme'] as bool
      ..showBalance = json['showBalance'] as bool
      ..dbPath = json['dbPath'] as String
      ..appPath = json['appPath'] as String
      ..firstDay = $enumDecode(_$DaysNameEnumMap, json['firstDay'])
      ..firstMonth = $enumDecode(_$MonthsNameEnumMap, json['firstMonth'])
      ..firstDate = json['firstDate'] as int
      ..dateFormat = json['dateFormat'] as String
      ..timeFormat = json['timeFormat'] as String
      ..hasStoragePermission = json['hasStoragePermission'] as bool
      ..hasManagePermission = json['hasManagePermission'] as bool;

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'firstInit': instance.firstInit,
      'useDarkTheme': instance.useDarkTheme,
      'showBalance': instance.showBalance,
      'dbPath': instance.dbPath,
      'appPath': instance.appPath,
      'firstDay': _$DaysNameEnumMap[instance.firstDay],
      'firstMonth': _$MonthsNameEnumMap[instance.firstMonth],
      'firstDate': instance.firstDate,
      'dateFormat': instance.dateFormat,
      'timeFormat': instance.timeFormat,
      'hasStoragePermission': instance.hasStoragePermission,
      'hasManagePermission': instance.hasManagePermission,
    };

const _$DaysNameEnumMap = {
  DaysName.sunday: 'sunday',
  DaysName.monday: 'monday',
  DaysName.tuesday: 'tuesday',
  DaysName.wednesday: 'wednesday',
  DaysName.thursday: 'thursday',
  DaysName.friday: 'friday',
  DaysName.saturday: 'saturday',
};

const _$MonthsNameEnumMap = {
  MonthsName.january: 'january',
  MonthsName.february: 'february',
  MonthsName.march: 'march',
  MonthsName.april: 'april',
  MonthsName.may: 'may',
  MonthsName.june: 'june',
  MonthsName.july: 'july',
  MonthsName.august: 'august',
  MonthsName.september: 'september',
  MonthsName.october: 'october',
  MonthsName.november: 'november',
  MonthsName.december: 'december',
};
