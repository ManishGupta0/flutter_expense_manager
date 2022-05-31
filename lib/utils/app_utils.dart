import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_expense_manager/providers/hive_settings_provider.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';

class AppUtils {
  static String dbPath = "";
  static String _appPathInternal = "";
  static String _appPathExternal = "";

  static Future<void> getDbPath() async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
      dbPath = dir!.path;
    } else if (Platform.isWindows) {
      dir = await getApplicationDocumentsDirectory();
      dbPath = p.join(dir.path, "Expense Manager");
    }
  }

  static Future<void> getAppPath() async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
      _appPathExternal = _appPathInternal = dir!.path;

      var index = _appPathInternal.indexOf("Android");
      if (index != -1) {
        _appPathExternal =
            p.join(_appPathInternal.replaceRange(index, null, ""), "ET");
      }
    } else if (Platform.isWindows) {
      dir = await getApplicationDocumentsDirectory();
      _appPathExternal = _appPathInternal = p.join(dir.path, "Expense Manager");
    }
  }

  static Future<bool> getPermission(Permission permission) async {
    var status = await permission.status;
    if (!status.isGranted) {
      await permission.request();
      status = await permission.status;
    }

    return status.isGranted;
  }

  static Future<SettingsProvider> initApp() async {
    var model = HiveSettingsProvider();

    await Future.wait([
      getDbPath(),
      getAppPath(),
    ]);

    model.settings.hasStoragePermission =
        await getPermission(Permission.storage);

    model.settings.hasManagePermission =
        await getPermission(Permission.manageExternalStorage);

    model.settings.dbPath = dbPath;
    if (model.settings.hasStoragePermission &&
        !model.settings.hasManagePermission) {
      model.settings.appPath = _appPathInternal;
    } else if (model.settings.hasManagePermission) {
      model.settings.appPath = _appPathExternal;
    }

    if (model.settings.hasStoragePermission) {}
    if (model.settings.hasManagePermission) {}

    Directory(model.settings.dbPath).create();
    Directory(model.settings.appPath).create();
    Directory(model.settings.refFilesPath).create();
    Directory(model.settings.backupPath).create();

    return model;
  }

  static Future<bool> createBackup({
    required SettingsProvider appSettings,
    required ExpenseProvider model,
  }) async {
    await model.export(appSettings.settings.appPath);

    var encoder = ZipFileEncoder();

    var backupFileName = "backup_${DateTime.now()}";
    backupFileName = backupFileName
        .replaceAll("-", "_")
        .replaceAll(" ", "_")
        .replaceAll(":", "_")
        .replaceAll(".", "_");

    backupFileName += ".zip";

    encoder.create(p.join(appSettings.settings.backupPath, backupFileName));

    var dbDir = Directory(appSettings.settings.dbPath);
    encoder.addDirectory(Directory(appSettings.settings.refFilesPath));

    await for (var entity in dbDir.list()) {
      if (entity is File && p.extension(entity.path) != ".lock") {
        encoder.addFile(File(entity.path));
      }
    }

    encoder.close();
    return true;
  }

  static Future<bool> restoreBackup(String restoreFrom,
      {required SettingsProvider appSettings}) async {
    final bytes = File(restoreFrom).readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(p.join(appSettings.settings.dbPath, filename))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(p.join(appSettings.settings.dbPath, filename))
            .create(recursive: true);
      }
    }
    return true;
  }
}
